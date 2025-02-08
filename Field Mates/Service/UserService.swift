//
//  UserService.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 03.02.2025.
//

import Foundation
import CloudKit

/// A service class responsible for managing user-related operations in CloudKit.
class UserService {
    //MARK: - Properties
    private let cloudKitManager = GenericCloudKitManager()
    
    //MARK: - Fetch User
    /// Fetches a user from CloudKit based on the given UUID.
    /// - Parameter userID: The UUID of the user to fetch.
    /// - Returns: A result containing the `User` or an error.
    func fetchUser(by userID: String, completion: @escaping (Result<User, Error>) -> Void) {
        let predicate = NSPredicate(format: "uuid == %@", userID)
        cloudKitManager.fetchAll(ofType: User.self, predicate: predicate) { result in
            switch result {
            case .success(let users):
                if let user = users.first {
                    completion(.success(user))
                } else {
                    completion(.failure(NSError(domain: "UserService", code: 404, userInfo: [NSLocalizedDescriptionKey: "No matching user found."])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //MARK: - Fetch User by ID and Userbane
    /// Fetches a user from CloudKit based on the given UUID.
    /// - Parameter userID: The UUID of the user to fetch.
    /// - Returns: A result containing the `User` or an error.
    func fetchUser(by userID: String,username: String, completion: @escaping (Result<User, Error>) -> Void) {
        let predicate = NSPredicate(format: "uuid != %@ AND username == %@", userID, username)
        cloudKitManager.fetchAll(ofType: User.self, predicate: predicate) { result in
            switch result {
            case .success(let users):
                if let user = users.first {
                    completion(.success(user))
                } else {
                    completion(.failure(NSError(domain: "UserService", code: 404, userInfo: [NSLocalizedDescriptionKey: "No matching user found."])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //MARK: - Update User
    /// Updates a user record in CloudKit.
    /// - Parameter user: The `User` object to update.
    func updateUser(_ user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        cloudKitManager.update(user) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }


    //MARK: - Setup Subscription
    /// Sets up a subscription for the `User` record type.
    /// - Parameter completion: A closure called with success or error.
    func setupSubscription(completion: @escaping (Result<Void, Error>) -> Void) {
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
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
