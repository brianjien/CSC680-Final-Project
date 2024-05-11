import SwiftUI
struct LoginView: View {
    @EnvironmentObject var userManager: UserManager
    @Binding var navigateToRegistration: Bool
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    var onLoginSuccess: () -> Void // Add this closure

    var body: some View {
        VStack(spacing: 12) {
            Text("Login")
            // Username input
            TextField("Enter username", text: $username)
                .padding()
                .frame(maxWidth: .infinity)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(.black).opacity(0.1))
                )
            // Password input
            SecureField("Enter password", text: $password)
                .padding()
                .frame(maxWidth: .infinity)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(.black).opacity(0.1))
                )
            // Login button
            Button(action: {
                login(username: username, password: password) // Call login function with parameters
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 372, height: 33)
                    .background(Color.black)
                    .cornerRadius(8)
            }
            // Cancel button
            Button(action: {}) {
                Text("Cancel")
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 372, height: 33)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 0.50)
                    )
            }
            // Sign up link
            Text("Need an account? Sign up here!")
                .underline()
                .foregroundColor(.black)
                .onTapGesture {
                    navigateToRegistration = true
                }
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
        .frame(width: 382, height: 483)
        .background(Color.white)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func login(username: String, password: String) {
        if let user = userManager.registeredUsers.first(where: { $0.username == username && $0.password == password }) {
            print("Pass")
            userManager.isLoggedIn = true
            userManager.currentUser = user
            onLoginSuccess() // Call the closure upon successful login
        } else {
            print("Invalid username or password")
            // Set showAlert to true if login fails
            showAlert = true
            alertMessage = "Invalid username or password."
        }
    }
}
