import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoggedIn = false
    @Published var errorMessage: String?

    init() {
        self.user = Auth.auth().currentUser
        self.isLoggedIn = self.user != nil
    }

    // Sign up
    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            } else {
                self?.user = result?.user
                self?.isLoggedIn = true
            }
        }
    }

    // Log in
    func logIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            } else {
                self?.user = result?.user
                self?.isLoggedIn = true
            }
        }
    }

    // Log out
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
