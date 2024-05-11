//
//  RegistrationView.swift
//  CSC680 Final Project
//
<<<<<<< HEAD
//  Created by brianjien on 5/11/24.
//
// MARK: - Registration View
=======
//  Created by 陳心榆 on 5/11/24.
//
>>>>>>> 057177fce9911a81046546483607ed6f1c05b428
import SwiftUI
struct RegistrationView: View {
    @EnvironmentObject var userManager: UserManager
    @Binding var navigateToRegistration: Bool
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        VStack{
            Text("   Registration")
            VStack{
                TextField("Enter username", text: $username)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(
                                Color(.black).opacity(0.10)
                            )
                    )
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
            VStack {
                SecureField("Enter password", text: $password)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(
                                Color(.black).opacity(0.10)
                            )
                    )
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
            VStack{
                SecureField("Confirm password", text: $confirmPassword)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(
                                Color(.black).opacity(0.10)
                            )
                    )
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
            
            Button(action: register) {
                Text("Register")
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 372, height: 33)
                    .background(.black)
                    .cornerRadius(8)
            }
            
            Button(action: {
                self.navigateToRegistration = false
            }) {
                Text("Cancel")
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 372, height: 33)
                    .background(.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.black, lineWidth: 0.50)
                    )
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func register() {
        if username.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            showAlert = true
            alertMessage = "Please enter a username, password, and confirm password."
            return
        }
        
        if password != confirmPassword {
            showAlert = true
            alertMessage = "Passwords do not match. Please enter the same password in both fields."
            return
        }
        
        userManager.register(username: username, password: password)
        navigateToRegistration = false
    }
}


