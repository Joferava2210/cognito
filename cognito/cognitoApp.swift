//
//  cognitoApp.swift
//  cognito
//
//  Created by Felipe Ramirez Vargas on 24/3/21.
//

import SwiftUI
import Amplify
import AmplifyPlugins

@main
struct cognitoApp: App {
    init() {
        configureAmplify()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    private func configureAmplify(){
        do{
            Amplify.Logging.logLevel = .verbose
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
              print("Amplify OK")
              print("Amplify configured with auth plugin")
        } catch {
            print("An error ocurred setting up Amplify: \(error)")
        }
    }
}
