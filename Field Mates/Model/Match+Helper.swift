//
//  Match+Helper.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 06.02.2025.
//

import CloudKit
import Foundation

struct Match: CloudKitObject {
    
    // MARK: - Conformance to Identifiable
    var id: String
    
    // MARK: - CloudKitObject Protocol
    static var recordType: String { "Match" }
    var recordID: CKRecord.ID?
    
    // MARK: - Properties
    var matchDate: Date
    var location: String
    var latitude: Double
    var longitude: Double
    var maxPlayers: Int
    var skillLevel: SkillLevel
    var organizerID: String
    var participants: [String] // List of User IDs
    
    // MARK: - Initializers
    init(
        id: String = UUID().uuidString,
        recordID: CKRecord.ID? = nil,
        matchDate: Date,
        location: String,
        latitude: Double,
        longitude: Double,
        maxPlayers: Int,
        skillLevel: SkillLevel,
        organizerID: String,
        participants: [String] = []
    ) {
        self.id = id
        self.recordID = recordID
        self.matchDate = matchDate
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.maxPlayers = maxPlayers
        self.skillLevel = skillLevel
        self.organizerID = organizerID
        self.participants = participants
    }
    
    // MARK: - Initialize from CKRecord
    init?(record: CKRecord) {
        guard let matchDate = record["matchDate"] as? Date,
              let location = record["location"] as? String,
              let latitude = record["latitude"] as? Double,
              let longitude = record["longitude"] as? Double,
              let maxPlayers = record["maxPlayers"] as? Int,
              let organizerID = record["organizerID"] as? String,
              let rawSkillLevel = record["skillLevel"] as? String
        else {
            return nil
        }
        
        self.matchDate = matchDate
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.maxPlayers = maxPlayers
        self.organizerID = organizerID
        self.skillLevel = SkillLevel(rawValue: Int(rawSkillLevel) ?? 1) ?? .beginner
        self.participants = record["participants"] as? [String] ?? []
        
        self.recordID = record.recordID
        self.id = record["uuid"] as? String ?? UUID().uuidString
    }
    
    // MARK: - Convert to CKRecord
    func toCKRecord(_ record: CKRecord? = nil) -> CKRecord {
        let record = record ?? CKRecord(recordType: Self.recordType)
        
        record["uuid"] = id as NSString
        record["matchDate"] = matchDate as NSDate
        record["location"] = location as NSString
        record["latitude"] = latitude as NSNumber
        record["longitude"] = longitude as NSNumber
        record["maxPlayers"] = maxPlayers as NSNumber
        record["organizerID"] = organizerID as NSString
        record["skillLevel"] = String(skillLevel.rawValue) as NSString
        record["participants"] = participants as NSArray
        
        return record
    }
    
    // MARK: - Helper Methods
    mutating func addParticipant(_ userID: String) {
        if !participants.contains(userID) && participants.count < maxPlayers {
            participants.append(userID)
        }
    }
    
    mutating func removeParticipant(_ userID: String) {
        participants.removeAll { $0 == userID }
    }
}
