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
    func getICloudStatus() {
        CKContainer.default().accountStatus { [weak self] returnedStatus, returnedError in
            DispatchQueue.main.async {
                guard let self = self else { return }
                guard returnedError == nil else {
                    self.iCloudStatus = .error
                    return
                }

                switch returnedStatus {
                case .available:
                    self.iCloudStatus = .available
                case .couldNotDetermine:
                    self.iCloudStatus = .couldNotDetermine
                case .noAccount:
                    self.iCloudStatus = .couldNotDetermine
                case .restricted:
                    self.iCloudStatus = .restricted
                case .temporarilyUnavailable:
                    self.iCloudStatus = .temporarilyUnavailable
                @unknown default:
                    print("Unknown iCloud status")
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
