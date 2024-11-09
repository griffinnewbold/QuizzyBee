struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}
