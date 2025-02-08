//
//  MatchStatus.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 06.02.2025.
//

import CloudKit
import Foundation


struct MatchParticipants: CloudKitObject {
    
    // MARK: - Conformance to Identifiable
    var id: String
    
    // MARK: - CloudKitObject Protocol
    static var recordType: String { "MatchParticipants" }
    var recordID: CKRecord.ID?
    
    // MARK: - Properties
    var matchID: String
    var userID: String
    var status: MatchStatus
    
    // MARK: - Initializers
    init(
        id: String = UUID().uuidString,
        recordID: CKRecord.ID? = nil,
        matchID: String,
        userID: String,
        status: MatchStatus = .joined
    ) {
        self.id = id
        self.recordID = recordID
        self.matchID = matchID
        self.userID = userID
        self.status = status
    }
    
    // MARK: - Initialize from CKRecord
    init?(record: CKRecord) {
        guard let matchID = record["matchID"] as? String,
              let userID = record["userID"] as? String,
              let statusString = record["status"] as? String,
              let status = MatchStatus(rawValue: statusString)
        else {
            return nil
        }
        
        self.matchID = matchID
        self.userID = userID
        self.status = status
        self.recordID = record.recordID
        self.id = record["uuid"] as? String ?? UUID().uuidString
    }
    
    // MARK: - Convert to CKRecord
    func toCKRecord(_ record: CKRecord? = nil) -> CKRecord {
        let record = record ?? CKRecord(recordType: Self.recordType)
        
        record["uuid"] = id as NSString
        record["matchID"] = matchID as NSString
        record["userID"] = userID as NSString
        record["status"] = status.rawValue as NSString
        
        return record
    }
}
