//
//  AuthViewModel.swift
//  quizzybee
//
//  Created by Griffin C Newbold on 11/13/24.
//


import SwiftUI
import FirebaseAuth
import FirebaseDatabase

class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoggedIn = false
    @Published var errorMessage: String?
    
    private let dbRef = Database.database().reference()
    
    init() {
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
            self.user = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    

    // MARK: - Sign Up Function with Completion Handler
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
                    Word(term: "Welcome", definition: "A word to greet new users"),
                    Word(term: "Quizzybee", definition: "Your go-to quiz app")
                ]
            )
               
            let newUser = User(
               userID: firebaseUser.uid,
               fullName: name,
               email: email,
               createdAt: Date().timeIntervalSince1970,
               sets: [defaultSet]
            )
               
           // Save the user details to Firebase
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
    func logIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }
            
            guard let firebaseUser = result?.user else { return }
            
            self?.fetchUser(withID: firebaseUser.uid)
            
            self?.isLoggedIn = true
        }
    }
    
    // MARK: - Fetch User from Firebase
    func fetchUser(withID userID: String) {
        dbRef.child("users").child(userID).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                self?.errorMessage = "Failed to fetch user data."
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let fetchedUser = try JSONDecoder().decode(User.self, from: jsonData)
                DispatchQueue.main.async {
                    self?.user = fetchedUser
                    print("logged in user:")
                    print(fetchedUser)
                }
            } catch {
                print("Error decoding user: \(error.localizedDescription)")
                self?.errorMessage = "Failed to decode user data."
            }
        }
    }
    
    // MARK: - Log Out Function
    func logOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.isLoggedIn = false
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
