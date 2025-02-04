//
//  UserViewModel.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 03.02.2025.
//

import Foundation
import CloudKit

/// A view model responsible for managing user-related data and interactions with CloudKit.
class UserViewModel: ObservableObject {
    
    /// The currently authenticated user.
    @Published var user: User?
    
    /// The CloudKit manager responsible for handling CloudKit operations.
    private let cloudKitManager = GenericCloudKitManager()
    
    /// Sets up a CloudKit subscription to listen for changes to the `User` record type.
    func setupSubscription() {
        let subscriptionID = "UserChanges"
        let publicDB = CKContainer.default().publicCloudDatabase

        publicDB.fetch(withSubscriptionID: subscriptionID) { existingSubscription, error in
            if let error = error as? CKError, error.code == .unknownItem {
                // Subscription doesn't exist; create a new one
                let subscription = CKQuerySubscription(
                    recordType: "User",
                    predicate: NSPredicate(value: true),
                    subscriptionID: subscriptionID,
                    options: [.firesOnRecordCreation, .firesOnRecordUpdate, .firesOnRecordDeletion]
                )

                let notificationInfo = CKSubscription.NotificationInfo()
                notificationInfo.shouldSendContentAvailable = true
                subscription.notificationInfo = notificationInfo

                publicDB.save(subscription) { _, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            print("⚠️ Failed to set up subscription: \(error.localizedDescription)")
                        } else {
                            print("✅ Subscription successfully set up.")
                        }
                    }
                }
            } else if let error = error {
                print("⚠️ Error fetching subscription: \(error.localizedDescription)")
            } else {
                print("✅ Subscription already exists.")
            }
        }
    }
    
    /// Fetches the user from CloudKit based on the stored Apple User ID.
    func fetchUserByID() {
        print("🔍 Fetching user by stored Apple ID")
        guard let userID = UserDefaults.standard.appleUserID else {
            print("⚠️ No stored Apple User ID found.")
            return
        }
        fetchUserByID(with: userID)
    }
    
    /// Fetches a user from CloudKit based on a given user ID.
    /// - Parameter ID: The UUID of the user to fetch.
    func fetchUserByID(with ID: String) {
        let predicate = NSPredicate(format: "uuid == %@", ID)
        cloudKitManager.fetchAll(ofType: User.self, predicate: predicate) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    if let currentUser = users.first {
                        self.user = currentUser
                        print("✅ User successfully fetched: \(currentUser)")
                    } else {
                        print("⚠️ No matching user found.")
                    }
                case .failure(let error):
                    print("❌ Failed to fetch user: \(error)")
                }
            }
        }
    }
    
    /// Updates a given user record in CloudKit.
    /// - Parameter ckRecord: The user record to be updated.
    func update(_ ckRecord: User) {
        cloudKitManager.update(ckRecord) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("✅ User updated successfully.")
                case .failure(let error):
                    print("❌ Failed to update user: \(error)")
                }
            }
        }
    }
}
