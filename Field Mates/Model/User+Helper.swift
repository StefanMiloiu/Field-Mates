//
//  User.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 30.01.2025.
//

import CloudKit
import Foundation

struct User: CloudKitObject {
    
    // MARK: - Conformance to Identifiable
    var id: String
    
    // MARK: - CloudKitObject Protocol
    static var recordType: String { "User" } // The record type in CloudKit
    var recordID: CKRecord.ID? // Keep track of the CloudKit record's ID
    
    // MARK: - Your Properties
    var email: String
    var phoneNumber: String?
    var username: String
    var firstName: String
    var lastName: String
    var bio: String?
    var profilePicture: URL?
    var dateOfBirth: Date?
    var skillLevel: SkillLevel?
    var preferredPosition: Position?
    var signupDate: Date?
    var city: String?
    var country: String?
    
    // MARK: - Initializers
    
    // Swift init
    init(
        id: String,
        recordID: CKRecord.ID? = nil,
        email: String,
        phoneNumber: String? = nil,
        username: String,
        firstName: String,
        lastName: String,
        bio: String? = nil,
        profilePicture: URL? = nil,
        dateOfBirth: Date? = nil,
        skillLevel: SkillLevel? = nil,
        preferredPosition: Position? = nil,
        signupDate: Date? = nil,
        city: String? = nil,
        country: String? = nil
    ) {
        self.id = id
        self.recordID = recordID
        self.email = email
        self.phoneNumber = phoneNumber
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.bio = bio
        self.profilePicture = profilePicture
        self.dateOfBirth = dateOfBirth
        self.skillLevel = skillLevel
        self.preferredPosition = preferredPosition
        self.signupDate = signupDate
        self.city = city
        self.country = country
    }
    
    // Failable initializer from CKRecord
    init?(record: CKRecord) {
        // REQUIRED FIELDS
        guard let email = record["email"] as? String,
              let firstName = record["firstName"] as? String,
              let lastName = record["lastName"] as? String,
        let username = record["username"] as? String
        else {
            return nil
        }
        
        // OPTIONAL FIELDS
        let phoneNumber = record["phoneNumber"] as? String
        let bio = record["bio"] as? String
        let city = record["city"] as? String
        let country = record["country"] as? String
        let dateOfBirth = record["dateOfBirth"] as? Date
        let signupDate = record["signupDate"] as? Date
        
        // If you store an enum as a string, convert it:
        if let rawSkillLevel = record["skillLevel"] as? String {
            self.skillLevel = SkillLevel(rawValue: Int(rawSkillLevel) ?? 1)
        } else {
            self.skillLevel = nil
        }
        
        if let rawPosition = record["preferredPosition"] as? String {
            self.preferredPosition = Position(rawValue: rawPosition)
        } else {
            self.preferredPosition = nil
        }
        
        // If you store the UUID in a field named "uuid", parse it:
        // Otherwise, just generate a new one if you only rely on CloudKit ID
        let uuid = record["uuid"] as? String
        
        // If you store URL fields as String, you might parse them:
        if let profilePictureString = record["profilePicture"] as? String {
            self.profilePicture = URL(string: profilePictureString)
        } else {
            self.profilePicture = nil
        }
        
        // Assign the rest
        self.recordID = record.recordID
        self.id = uuid!
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.username = username
        self.bio = bio
        self.city = city
        self.country = country
        self.dateOfBirth = dateOfBirth
        self.signupDate = signupDate
    }
    
    // Convert this struct to CKRecord
    func toCKRecord(_ record: CKRecord? = nil) -> CKRecord {
        // If we have an existing record, update that one
        let record = record ?? CKRecord(recordType: Self.recordType)
        
        // REQUIRED fields
        record["email"] = email as NSString
        record["firstName"] = firstName as NSString
        record["lastName"] = lastName as NSString
        
        // OPTIONAL fields
        record["phoneNumber"] = phoneNumber as NSString?
        record["username"] = username as NSString?
        record["bio"] = bio as NSString?
        record["city"] = city as NSString?
        record["country"] = country as NSString?
        
        // If you keep a local UUID, you can store it in the record as well
        record["uuid"] = id as NSString
        
        // For URLs, CloudKit doesn't directly store `URL?`,
        // so you might store it as a String or convert it to a CKAsset.
        // Below is a simple "store as string" approach:
        if let profilePicture {
            record["profilePicture"] = profilePicture.absoluteString as NSString
        } else {
            record["profilePicture"] = nil
        }
        
        // Dates can be stored directly as Date
        record["dateOfBirth"] = dateOfBirth as NSDate?
        record["signupDate"] = signupDate as NSDate?
        
        // Enums stored as strings
        if let skillLevel {
            record["skillLevel"] = String(skillLevel.rawValue) as NSString
        } else {
            record["skillLevel"] = nil
        }
        
        if let preferredPosition {
            record["preferredPosition"] = preferredPosition.rawValue as NSString
        } else {
            record["preferredPosition"] = nil
        }
        
        return record
    }
}
