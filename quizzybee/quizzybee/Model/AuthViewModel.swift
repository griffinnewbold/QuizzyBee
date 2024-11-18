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
    
    // MARK: - Log In Function with Completion Handler
    func logIn(email: String, password: String, completion: @escaping (User?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                completion(nil)
                return
            }
            
            guard let firebaseUser = result?.user else {
                completion(nil)
                return
            }
            
            // Fetch user details from Firebase
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
    private func fetchUser(withID userID: String, completion: @escaping (User?) -> Void) {
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
