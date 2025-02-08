//
//  ICloudUserDataManager.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 30.01.2025.
//
// Icloud status required for the app
import Foundation
import CloudKit

class ICloudUserDataManager {
    //MARK: - Properties
    var iCloudStatus: ICloudStatus = .couldNotDetermine

    //MARK: - iCloud Status
    /// Get iCloud account status with a completion handler
    func getICloudStatus(completion: @escaping (ICloudStatus) -> Void) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2.0) {
            CKContainer.default().accountStatus { status, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("❌ Error checking iCloud account status: \(error.localizedDescription)")
                        completion(.error)
                        return
                    }
                    
                    switch status {
                    case .available:
                        completion(.available)
                    case .couldNotDetermine, .noAccount:
                        completion(.couldNotDetermine)
                    case .restricted:
                        completion(.restricted)
                    case .temporarilyUnavailable:
                        completion(.temporarilyUnavailable)
                    @unknown default:
                        completion(.couldNotDetermine)
                    }
                }
            }
        }
    }
    
    func fetchCurrentUserRecord() async throws -> CKRecord? {
        let userRecordID = try await fetchCurrentUserRecordID()
        let database = CKContainer.default().publicCloudDatabase
        let record = try await database.record(for: userRecordID)
        return record
    }
    
    func fetchCurrentUserRecordID() async throws -> CKRecord.ID {
        let container = CKContainer.default()
        let userRecordID = try await container.userRecordID()
        return userRecordID
    }
}
