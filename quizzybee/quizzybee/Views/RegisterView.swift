import SwiftUI

struct RegisterView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            Text("Register Today!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            Spacer()
            
            VStack(spacing: 20) {
                CustomTextField(placeholder: "Full Name:", text: $fullName)
                CustomTextField(placeholder: "Email:", text: $email)
                SecureField("Password:", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.horizontal, 20)
            
            Button(action: {
                // Register logic here
            }) {
                Text("Register")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.horizontal, 50)
            .padding(.top, 20)
            
            Spacer()
            
            HStack {
                Text("Already Registered?")
                NavigationLink("Login", destination: LoginView())
                    .foregroundColor(.yellow)
            }
            .padding(.bottom, 20)
        }
        .background(Color.gray.ignoresSafeArea())
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
