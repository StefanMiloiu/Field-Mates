//
//  SignInWithApple.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 31.01.2025.
//

import AuthenticationServices
import SwiftUI

struct SignInWithAppleView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        SignInWithAppleButton(.signIn, onRequest: { request in
            request.requestedScopes = [.fullName, .email]
        }, onCompletion: { result in
            switch result {
            case .success(let authResults):
                if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
                    // Extract the unique user ID
                    let userID = appleIDCredential.user
                    print("User ID: \(userID)")
                    
                    // Save the userID or use it with CloudKit
                    UserDefaults.standard.set(userID, forKey: "appleUserID")
                    UserDefaults.standard.set(true, forKey: "seenOnboarding")
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    // Navigate to the main app
                    coordinator.showMainView()
                }
            case .failure(let error):
                print("Sign in with Apple failed: \(error.localizedDescription)")
            }
        })
        .signInWithAppleButtonStyle(.black)
        .frame(height: 50)
        .cornerRadius(10)
        .padding()
    }
}

#Preview {
    SignInWithAppleView()
}
