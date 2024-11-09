import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            Text("Login Today!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            Spacer()
            
            VStack(spacing: 20) {
                CustomTextField(placeholder: "Email:", text: $email)
                SecureField("Password:", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.horizontal, 20)
            
            Button(action: {
                // Login logic here
            }) {
                Text("Login")
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
                Text("Not Registered Yet?")
                NavigationLink("Register", destination: RegisterView())
                    .foregroundColor(.yellow)
            }
            .padding(.bottom, 20)
        }
        .background(Color.gray.ignoresSafeArea())
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
