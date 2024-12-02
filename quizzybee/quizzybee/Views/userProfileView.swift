//
//  userProfileView.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

/// A user profile view that allows updating the profile image and selecting a voice model.
struct userProfileView: View {
    // MARK: - Environment Objects
    @EnvironmentObject var authViewModel: AuthViewModel // Manages user authentication and profile updates.
    @Environment(\.dismiss) var dismiss // Dismisses the view when the back button is tapped.

    // MARK: - State Properties
    @State private var selectedImage = "UserImage1" // Currently selected profile image.
    @State private var refreshID = UUID()           // Refresh identifier to update the user image dynamically.
    @State private var voiceModels: [Voice] = []    // List of available voice models.
    @State private var selectedVoice: String = "Default" // Currently selected voice model.

    // MARK: - Body
    var body: some View {
        ZStack {
            // Background
            Color(hex: "2C2C2C").ignoresSafeArea() // Black background

            // Content
            ScrollView {
                VStack(spacing: 0) {
                    // Top Bar
                    HStack {
                        Button(action: { dismiss() }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.yellow)
                                Text("Back to Dashboard")
                                    .foregroundColor(.yellow)
                                    .font(.headline)
                            }
                        }
                        Spacer()
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, 16)

                    // User Image
                    userImage(size: 120, // Profile image with a larger size for visibility
                              imageName: authViewModel.user?.profileImage ?? "UserImage1")
                        .padding(.top, 16)
                        .padding(.bottom, 20)
                        .id(refreshID)

                    // Image Selector
                    imageSelector(selectedImage: $selectedImage)
                        .onChange(of: selectedImage) { oldValue, newValue in
                            authViewModel.updateUserProfileImage(imageName: newValue)
                        }
                        .padding(.horizontal, 16)

                    Spacer()

                    // Profile Information
                    profileList()
                        .environmentObject(authViewModel)
                        .padding(.horizontal, 16)
                        .background(Color(hex: "2C2C2C"))
                        .cornerRadius(12)
                        .padding(.vertical, 20)

                    // Voice Model Selector
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Select Voice Model:")
                            .foregroundColor(.yellow)
                            .font(.headline)
                            .padding(.horizontal, 16)

                        Picker("Voice Model", selection: $selectedVoice) {
                            Text("Default").tag("Default")
                            ForEach(voiceModels, id: \.voice_id) { voice in
                                Text(voice.name).tag(voice.voice_id)
                            }
                        }
                        .accentColor(.yellow)
                        .pickerStyle(MenuPickerStyle())
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .onChange(of: selectedVoice) { _, newValue in
                            saveSelectedVoiceModel(newValue)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
                .padding(.bottom, 20) // Space at the bottom to prevent clipping
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            fetchVoiceModels()
            loadSelectedVoice()
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name("UserImageUpdated"),
                object: nil,
                queue: .main
            ) { _ in
                refreshID = UUID()
            }
        }
    }

    // MARK: - Helper Methods

    /// Fetches the available voice models from the ElevenLabs API.
    private func fetchVoiceModels() {
        Task {
            do {
                let voices = try await ElevenLabsAPI.fetchVoices()
                voiceModels = voices
            } catch {
                print("Error fetching voices: \(error.localizedDescription)")
            }
        }
    }

    /// Loads the currently selected voice model for the user.
    private func loadSelectedVoice() {
        if let currentVoiceModel = authViewModel.user?.voiceModel {
            selectedVoice = currentVoiceModel
        }
    }

    /// Saves the selected voice model to the user's profile.
    /// - Parameter voiceID: The ID of the selected voice model.
    private func saveSelectedVoiceModel(_ voiceID: String) {
        authViewModel.updateUserVoiceModel(voiceID: voiceID)
    }
}
