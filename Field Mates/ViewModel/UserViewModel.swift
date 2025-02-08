//
//  UserViewModel.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 03.02.2025.
//

import Foundation

/// A view model responsible for managing user-related data and interactions with CloudKit.
class UserViewModel: ObservableObject {
    
    /// The currently authenticated user.
    @Published var user: User?
    
    /// The service responsible for user-related operations.
    private let userService = UserService()
    
    init() {
        print("Initialized UserViewModel. ObjectID =", ObjectIdentifier(self))
    }
    /// Sets up a CloudKit subscription to listen for changes to the `User` record type.
    func setupSubscription() {
        userService.setupSubscription { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("✅ Subscription successfully set up.")
                case .failure(let error):
                    print("⚠️ Failed to set up subscription: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// Fetches the user from CloudKit based on the stored Apple User ID.
    func fetchUserByID() {
        guard let userID = UserDefaults.standard.appleUserID else {
            print("⚠️ No stored Apple User ID found.")
            return
        }
        
        userService.fetchUser(by: userID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.user = user
                    print("✅ User successfully fetched: \(user)")
                case .failure(let error):
                    print("❌ Failed to fetch user: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchUserByIDAndUsername(username: String) {
        guard let userID = UserDefaults.standard.appleUserID else {
            print("⚠️ No stored Apple User ID found.")
            return
        }
        
        userService.fetchUser(by: userID, username: username){ result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    print("✅ User successfully fetched: \(user)")
                case .failure(let error):
                    print("❌ Failed to fetch user: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// Updates the user record in CloudKit.
    /// - Parameter user: The `User` object to be updated.
    func updateUser(_ user: User) {
        userService.updateUser(user) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("✅ User updated successfully.")
                case .failure(let error):
                    print("❌ Failed to update user: \(error.localizedDescription)")
                }
            }
        }
    }
}
