//
//  CloudKitManager.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 30.01.2025.
//
import CloudKit

final class GenericCloudKitManager {

    private let database = CKContainer(identifier: "iCloud.com.miloiu.Field-Mates").publicCloudDatabase
    
    // CREATE
    func create<T: CloudKitObject>(_ object: T,
                                   completion: @escaping (Result<T, Error>) -> Void) {
        
        let customRecordID = CKRecord.ID(recordName: object.id)
        let record = object.toCKRecord(CKRecord(recordType: T.recordType,
                                                recordID: customRecordID))
        database.save(record) { savedRecord, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard
                    let savedRecord = savedRecord,
                    let savedObject = T(record: savedRecord)
                else {
                    let parseError = NSError(domain: "CloudKit",
                                             code: -1,
                                             userInfo: [NSLocalizedDescriptionKey: "Failed to parse saved record"])
                    completion(.failure(parseError))
                    return
                }
                completion(.success(savedObject))
            }
        }
    }
    
    // READ
    func fetchAll<T: CloudKitObject>(ofType type: T.Type,
                                     predicate: NSPredicate = NSPredicate(value: true),
                                     completion: @escaping (Result<[T], Error>) -> Void) {
        
        let query = CKQuery(recordType: T.recordType, predicate: predicate)

        database.fetch(withQuery: query,
                       inZoneWith: nil,
                       desiredKeys: nil,
                       resultsLimit: CKQueryOperation.maximumResults) { result in
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
                
                // If you want to handle pagination, you can either:
                // 1) Recursively fetch more with fetch(withQueryCursor:),
                // 2) Return what you have so far, or
                // 3) Combine both approaches.
                
                // For simplicity, let's just return what we have:
                completion(.success(objects))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // UPDATE
    func update<T: CloudKitObject>(_ object: T,
                                   completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let recordID = object.recordID else {
            let missingIDError = NSError(domain: "CloudKit",
                                         code: -1,
                                         userInfo: [NSLocalizedDescriptionKey: "RecordID is missing"])
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
                    let notFoundError = NSError(domain: "CloudKit",
                                                code: -1,
                                                userInfo: [NSLocalizedDescriptionKey: "Record not found"])
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
                        guard
                            let savedRecord = savedRecord,
                            let savedObject = T(record: savedRecord)
                        else {
                            let parseError = NSError(domain: "CloudKit",
                                                     code: -1,
                                                     userInfo: [NSLocalizedDescriptionKey: "Failed to parse updated record"])
                            completion(.failure(parseError))
                            return
                        }
                        completion(.success(savedObject))
                    }
                }
            }
        }
    }
    
    // DELETE
    func delete<T: CloudKitObject>(_ object: T,
                                   completion: @escaping (Result<CKRecord.ID, Error>) -> Void) {
        
        guard let recordID = object.recordID else {
            let missingIDError = NSError(domain: "CloudKit",
                                         code: -1,
                                         userInfo: [NSLocalizedDescriptionKey: "RecordID is missing"])
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
                    let unknownError = NSError(domain: "CloudKit",
                                               code: -1,
                                               userInfo: [NSLocalizedDescriptionKey: "No ID returned on delete"])
                    completion(.failure(unknownError))
                    return
                }
                completion(.success(deletedID))
            }
        }
    }
}
