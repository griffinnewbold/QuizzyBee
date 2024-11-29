//
//  userProfileView.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/10.
//

import SwiftUI

struct userProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    // For updating images
    @State private var selectedImage = "UserImage1"
    @State private var refreshID = UUID()
    
    // For voice model selection
    @State private var voiceModels: [Voice] = []
    @State private var selectedVoice: String = "Default" // Default value
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color(hex: "2C2C2C").ignoresSafeArea() // Black background
            
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
                    userImage(size: 120, // Increased size for better visibility
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
                    
                    Spacer() // Pushes profile and voice model sections downward
                    
                    // Profile List
                    profileList()
                        .environmentObject(authViewModel)
                        .padding(.horizontal, 16)
                        .background(Color(hex: "2C2C2C")) // Dark gray background
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
                .padding(.bottom, 20) // Adds space at the bottom to prevent clipping
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
    
    private func loadSelectedVoice() {
        if let currentVoiceModel = authViewModel.user?.voiceModel {
            selectedVoice = currentVoiceModel
        }
    }
    
    private func saveSelectedVoiceModel(_ voiceID: String) {
        authViewModel.updateUserVoiceModel(voiceID: voiceID)
    }
}

#Preview {
    return ZStack {
        Color(hex: "2C2C2C").ignoresSafeArea()
        
        userProfileView()
            .environmentObject(AuthViewModel())
    }
}
