//
//  CloudKitManager.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 30.01.2025.
//
// Generic manager for handling CRUD operations in CloudKit.
// This class provides methods to create, read, update, and delete records
// from the iCloud public database associated with the app's container.
import CloudKit

final class GenericCloudKitManager {
    
    /// Reference to the CloudKit public database.
    private let database = CKContainer(identifier: "iCloud.com.miloiu.Field-Mates").publicCloudDatabase
    
    // MARK: - CREATE
    
    /// Creates a new record in CloudKit.
    /// - Parameters:
    ///   - object: The object conforming to `CloudKitObject` to be created.
    ///   - completion: Completion handler with a result containing the saved object or an error.
    func create<T: CloudKitObject>(_ object: T,
                                   completion: @escaping (Result<T, Error>) -> Void) {
        let customRecordID = CKRecord.ID(recordName: object.id)
        let record = object.toCKRecord(CKRecord(recordType: T.recordType, recordID: customRecordID))
        
        database.save(record) { savedRecord, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let savedRecord = savedRecord, let savedObject = T(record: savedRecord) else {
                    let parseError = NSError(domain: "CloudKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse saved record"])
                    completion(.failure(parseError))
                    return
                }
                completion(.success(savedObject))
            }
        }
    }
    
    // MARK: - READ
    
    /// Fetches all records of a specified type from CloudKit.
    /// - Parameters:
    ///   - type: The type of object to fetch.
    ///   - predicate: A predicate to filter the records (default is all records).
    ///   - completion: Completion handler with a result containing an array of fetched objects or an error.
    func fetchAll<T: CloudKitObject>(ofType type: T.Type,
                                     predicate: NSPredicate = NSPredicate(value: true),
                                     completion: @escaping (Result<[T], Error>) -> Void) {
        let query = CKQuery(recordType: T.recordType, predicate: predicate)
        
        database.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults) { result in
            switch result {
            case .success(let (matchResults, _)):
                var objects: [T] = []
                for (_, recordResult) in matchResults {
                    do {
                        let record = try recordResult.get()
                        if let parsedObject = T(record: record) {
                            objects.append(parsedObject)
                        }
                    } catch {
                        print("Error fetching record: \(error)")
                    }
                }
                completion(.success(objects))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - UPDATE
    
    /// Updates an existing record in CloudKit.
    /// - Parameters:
    ///   - object: The object conforming to `CloudKitObject` to be updated.
    ///   - completion: Completion handler with a result containing the updated object or an error.
    func update<T: CloudKitObject>(_ object: T,
                                   completion: @escaping (Result<T, Error>) -> Void) {
        guard let recordID = object.recordID else {
            let missingIDError = NSError(domain: "CloudKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "RecordID is missing"])
            completion(.failure(missingIDError))
            return
        }
        
        database.fetch(withRecordID: recordID) { fetchedRecord, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let fetchedRecord = fetchedRecord else {
                    let notFoundError = NSError(domain: "CloudKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "Record not found"])
                    completion(.failure(notFoundError))
                    return
                }
                
                let updatedRecord = object.toCKRecord(fetchedRecord)
                self.database.save(updatedRecord) { savedRecord, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        guard let savedRecord = savedRecord, let savedObject = T(record: savedRecord) else {
                            let parseError = NSError(domain: "CloudKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse updated record"])
                            completion(.failure(parseError))
                            return
                        }
                        completion(.success(savedObject))
                    }
                }
            }
        }
    }
    
    // MARK: - DELETE
    
    /// Deletes a record from CloudKit.
    /// - Parameters:
    ///   - object: The object conforming to `CloudKitObject` to be deleted.
    ///   - completion: Completion handler with a result containing the deleted record ID or an error.
    func delete<T: CloudKitObject>(_ object: T,
                                   completion: @escaping (Result<CKRecord.ID, Error>) -> Void) {
        guard let recordID = object.recordID else {
            let missingIDError = NSError(domain: "CloudKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "RecordID is missing"])
            completion(.failure(missingIDError))
            return
        }
        
        database.delete(withRecordID: recordID) { deletedID, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let deletedID = deletedID else {
                    let unknownError = NSError(domain: "CloudKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "No ID returned on delete"])
                    completion(.failure(unknownError))
                    return
                }
                completion(.success(deletedID))
            }
        }
    }
}
