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
    private let cloudKitManager = GenericCloudKitManager()

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
                    UserDefaults.standard.appleUserID = userID
                    UserDefaults.standard.seenOnboarding = true
                    UserDefaults.standard.isLoggedIn = true
                    UserDefaults.standard.email = appleIDCredential.email
                    print("Apple Email: \(String(describing: appleIDCredential.email))")
                    // Navigate to the main app
                    let predicate = NSPredicate(format: "uuid == %@", userID)
                    cloudKitManager.fetchAll(ofType: User.self,
                                             predicate: predicate) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let users):
                                if let currentUser = users.first {
                                    UserDefaults.standard.email = currentUser.email
                                    coordinator.onboardingCoordinator.goToExistingAccount()
                                } else {
                                    coordinator.onboardingCoordinator.goToCreateAccount()
                                }
                            case .failure(_):
                                coordinator.onboardingCoordinator.goToCreateAccount()
                            }
                        }
                    }
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
