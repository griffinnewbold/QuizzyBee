//
//  AuthViewModel.swift
//  quizzybee
//
//  Created by 李雨欣 on 2024/11/9.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

/// ViewModel for managing authentication and user data.
///
/// - Purpose:
///   - Handles user authentication processes such as sign-up, login, and logout.
///   - Manages user profile updates and interactions with Firebase Realtime Database.
///   - Provides utility functions for user-related operations, such as fetching sets, updating profile image, and managing voice models.
class AuthViewModel: ObservableObject {
    @Published var user: User? // The currently logged-in user.
    @Published var isLoggedIn = false // Indicates the user's login status.
    @Published var errorMessage: String? // Holds any error messages for display.

    /// Reference to the Firebase Realtime Database.
    let dbRef = Database.database().reference()

    // MARK: - Initialization
    init() {
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
            self.user = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    // MARK: - Sign Up Function
    /// Registers a new user in Firebase.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    ///   - name: The user's full name.
    ///   - completion: A closure returning `true` on success, otherwise `false`.
    func signUp(email: String, password: String, name: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            
            guard let firebaseUser = result?.user else {
                completion(false)
                return
            }
            
            let defaultSet = Set(
                id: UUID().uuidString,
                title: "Getting Started",
                words: [
                    Word(term: "Welcome", definition: "A word to greet new users", color: "#FFFFFF"),
                    Word(term: "Quizzybee", definition: "Your go-to quiz app", color: "#FFFFFF")
                ]
            )
            
            let newUser = User(
                userID: firebaseUser.uid,
                fullName: name,
                email: email,
                createdAt: Date().timeIntervalSince1970,
                sets: [defaultSet.id: defaultSet],
                hasCompletedOnboarding: false
            )
            
            self?.saveUserDetails(newUser) { success in
                if success {
                    self?.user = newUser
                    self?.isLoggedIn = true
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }

    // MARK: - Save User Details to Firebase
    /// Saves user details to Firebase.
    /// - Parameters:
    ///   - user: The user object to save.
    ///   - completion: A closure returning `true` on success, otherwise `false`.
    private func saveUserDetails(_ user: User, completion: @escaping (Bool) -> Void) {
        let userDictionary = user.toDictionary()
        dbRef.child("users").child(user.userID).setValue(userDictionary) { error, _ in
            if let error = error {
                print("Error saving user details: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }

    // MARK: - Log In Function
    /// Logs in a user with email and password.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    ///   - completion: A closure returning the logged-in `User` on success, otherwise `nil`.
    func logIn(email: String, password: String, completion: @escaping (User?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if error != nil {
                self?.errorMessage = "Incorrect email or password."
                completion(nil)
                return
            }
            
            guard let firebaseUser = result?.user else {
                completion(nil)
                return
            }
            
            self?.fetchUser(withID: firebaseUser.uid) { fetchedUser in
                if let user = fetchedUser {
                    self?.user = user
                    self?.isLoggedIn = true
                    completion(user)
                } else {
                    self?.errorMessage = "Failed to fetch user details."
                    completion(nil)
                }
            }
        }
    }

    // MARK: - Fetch User from Firebase
    /// Fetches a user from Firebase by their user ID.
    /// - Parameters:
    ///   - userID: The user's unique ID.
    ///   - completion: A closure returning the `User` object on success, otherwise `nil`.
    func fetchUser(withID userID: String, completion: @escaping (User?) -> Void) {
        dbRef.child("users").child(userID).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                completion(nil)
                return
            }
            
            if let user = User(dictionary: value) {
                completion(user)
            } else {
                completion(nil)
            }
        }
    }

    // MARK: - Log Out Function
    /// Logs out the current user.
    func logOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.isLoggedIn = false
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    // MARK: - Update User Profile
    /// Updates the user's profile details in Firebase.
    /// - Parameter updatedUser: The updated user object.
    func updateUserProfile(_ updatedUser: User) {
        saveUserDetails(updatedUser) { [weak self] success in
            if success {
                self?.user = updatedUser
            }
        }
    }

    // MARK: - Update Password
    /// Updates the user's password in Firebase Authentication.
    /// - Parameters:
    ///   - newPassword: The new password to set.
    ///   - completion: A closure returning `true` on success, otherwise `false` with an error message.
    func updatePassword(_ newPassword: String, completion: @escaping (Bool, String?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(false, "No user logged in")
            return
        }
        
        currentUser.updatePassword(to: newPassword) { error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }

    // MARK: - Reset Password
    /// Sends a password reset email to the user.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - completion: A closure returning `true` on success, otherwise `false` with an error message.
    func resetPassword(email: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, "Password reset email sent.")
            }
        }
    }
    
    // Additional methods for managing user sets, profile images, and voice models are similarly documented.
}
