//
//  SignUp.swift
//  cognito
//
//  Created by Felipe Ramirez Vargas on 24/3/21.
//

import SwiftUI
import Amplify
import SCLAlertView

struct SignUp: View {
    
    @State private var username = ""
    @State private var password = ""
    @State private var email = ""
    
    var body: some View {
        VStack{
            Text("Register").bold().font(.title)
            Text("Enter Details Below").font(.subheadline)
                .padding(EdgeInsets(top: 0, leading: 0,
                                    bottom: 70, trailing: 0))
            
            TextField("Username", text: $username)
                .padding()
                .background(Color("flash-white"))
                .cornerRadius(4.0)
                .padding(EdgeInsets(top: 0, leading: 0,
                                    bottom: 15, trailing: 0))
                .autocapitalization(.none)
            
            TextField("Email", text: $email)
                .padding()
                .background(Color("flash-white"))
                .cornerRadius(4.0)
                .padding(EdgeInsets(top: 0, leading: 0,
                                    bottom: 15, trailing: 0))
                .autocapitalization(.none)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color("flash-white"))
                .cornerRadius(4.0)
                .padding(.bottom, 10)
                .autocapitalization(.none)
            
            Button(action: signUp) {
                HStack(alignment: .center){
                    Spacer()
                    Text("SignUp").foregroundColor(Color.white)
                    Spacer()
                }
            }.padding().background(Color.green)
            .cornerRadius(4.0)
        }
    }
    
    func signUp() {
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        
        Amplify.Auth.signUp(username: username,
                            password: password,
                            options: options
        ){result in
            switch result {
            case .success(let signUpResult):
                switch signUpResult.nextStep {
                case .confirmUser(let details, let info):
                    print(details ?? "no details", info ?? "no additional info")
                    
                    DispatchQueue.main.async {
                     
                        let alert = SCLAlertView(
                        )
                        let txt = alert.addTextField("Enter confirm number")
                        alert.addButton("Confirm") {
                            confirmSignUp(emailCode: txt.text!)
                            print("Facilitar Codigo")
                        }
                        alert.showEdit("SMS", subTitle: "Enter the code received in your email", closeButtonTitle: "Cancel")
                    }
                    
                case .done:
                    print("Sign up complete")
                }
                
            case .failure(let error):
                           print(error)
                           DispatchQueue.main.async {
                               SCLAlertView().showError("Error", subTitle: error.errorDescription) // Error
                           }
            }
        }
    }
    
    func confirmSignUp(emailCode: String) {
        Amplify.Auth.confirmSignUp(for: username, confirmationCode: emailCode) { result in
            
            switch result {
            
            case .success(let confirmSignUpResult):
                
                switch confirmSignUpResult.nextStep {
                case .confirmUser(let details, let info):
                    print(details ?? "no details", info ?? "no additional info")
                    
                    
                case .done:
                    print("\(username) confirmed their email")
                    username = ""
                    password = ""
                    email = ""
                    DispatchQueue.main.async {
                        SCLAlertView().showInfo("Success", subTitle: "Email Confirmed") // Info
                    }
                
                }
                
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    SCLAlertView().showError("Error", subTitle: error.errorDescription) // Error
                }
                
            }
            
        }
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
