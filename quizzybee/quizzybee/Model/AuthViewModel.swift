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
                sets: [defaultSet.id: defaultSet]
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
            
            // Fetch user details from Firebase
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
            
            // Convert the snapshot dictionary to a User object
            if let user = User(dictionary: value) {
                DispatchQueue.main.async {
                    self?.user = user
                    print("Logged in user:", user)
                }
            } else {
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
    
    // MARK: Update Profile
    func updateUserProfile(_ updatedUser: User) {
        saveUserDetails(updatedUser) { [weak self] success in
            if success {
                self?.user = updatedUser
            }
        }
    }

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
    
}
