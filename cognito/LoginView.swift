//
//  LoginView.swift
//  cognito
//
//  Created by Felipe Ramirez Vargas on 25/3/21.
//

import SwiftUI
import Amplify
import SCLAlertView

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""

    @EnvironmentObject var contentVM: ContentViewMoedl
    
    var body: some View {
        VStack{
            Text("Login").bold().font(.title)
            Text("One more step").font(.subheadline)
                .padding(EdgeInsets(top:0, leading: 0, bottom: 70, trailing: 0))
            
            TextField("Username", text:$username)
                .padding()
                .background(Color("flash-white"))
                .cornerRadius(4.0)
                .padding(EdgeInsets(top:0, leading: 0, bottom: 15, trailing: 0))
                .autocapitalization(.none)
            
            SecureField("Password", text:$password)
                .padding()
                .background(Color("flash-white"))
                .cornerRadius(4.0)
                .padding(.bottom,10)
                .autocapitalization(.none)
            
            Button(action:signIn) {
                HStack(alignment: .center){
                    Spacer()
                    Text("Login").foregroundColor(Color.white).bold()
                    Spacer()
                }
            }.padding().background(Color.purple).cornerRadius(4.0)
        }
    }
    
    func signIn() {
        Amplify.Auth.signIn(username: username, password: password) { result in
            switch result {
            
            case.success:
                print("\(username) signed in")
                DispatchQueue.main.async {
                    self.contentVM.logged = true
                    print("Login in")
                }
             
            case.failure(let error):
                print(error)
                DispatchQueue.main.async {
                    SCLAlertView().showError("Error", subTitle: error.errorDescription)
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
