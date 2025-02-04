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
    static var recordType: String { "User" }
    var recordID: CKRecord.ID?
    
    // MARK: - Your Properties
    var email: String
    var phoneNumber: String?
    var username: String
    var firstName: String
    var lastName: String
    var bio: String?
    var profilePicture: Data? // Now it's Data instead of URL
    var dateOfBirth: Date?
    var skillLevel: SkillLevel?
    var preferredPosition: Position?
    var signupDate: Date?
    var city: String?
    var country: String?
    
    // MARK: - Initializers
    init(
        id: String,
        recordID: CKRecord.ID? = nil,
        email: String,
        phoneNumber: String? = nil,
        username: String,
        firstName: String,
        lastName: String,
        bio: String? = nil,
        profilePicture: Data? = nil, // Now uses Data
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
    
    // MARK: - Initialize from CKRecord
    init?(record: CKRecord) {
        guard let email = record["email"] as? String,
              let firstName = record["firstName"] as? String,
              let lastName = record["lastName"] as? String,
              let username = record["username"] as? String
        else {
            return nil
        }
        
        let phoneNumber = record["phoneNumber"] as? String
        let bio = record["bio"] as? String
        let city = record["city"] as? String
        let country = record["country"] as? String
        let dateOfBirth = record["dateOfBirth"] as? Date
        let signupDate = record["signupDate"] as? Date
        
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
        
        let uuid = record["uuid"] as? String ?? UUID().uuidString
        
        // Convert CKAsset to Data
        if let asset = record["profilePicture"] as? CKAsset,
           let fileURL = asset.fileURL,
           let imageData = try? Data(contentsOf: fileURL) {
            self.profilePicture = imageData
        } else {
            self.profilePicture = nil
        }
        
        self.recordID = record.recordID
        self.id = uuid
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
    
    // MARK: - Convert to CKRecord
    func toCKRecord(_ record: CKRecord? = nil) -> CKRecord {
        let record = record ?? CKRecord(recordType: Self.recordType)
        
        record["email"] = email as NSString
        record["firstName"] = firstName as NSString
        record["lastName"] = lastName as NSString
        record["phoneNumber"] = phoneNumber as NSString?
        record["username"] = username as NSString?
        record["bio"] = bio as NSString?
        record["city"] = city as NSString?
        record["country"] = country as NSString?
        record["uuid"] = id as NSString
        record["dateOfBirth"] = dateOfBirth as NSDate?
        record["signupDate"] = signupDate as NSDate?
        
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
        
        // Convert Data to CKAsset
        if let profilePictureData = profilePicture {
            let tempURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(UUID().uuidString)
                .appendingPathExtension("jpg")
            
            do {
                try profilePictureData.write(to: tempURL)
                let asset = CKAsset(fileURL: tempURL)
                record["profilePicture"] = asset
            } catch {
                print("Error writing profile picture to temporary file: \(error)")
                record["profilePicture"] = nil
            }
        } else {
            record["profilePicture"] = nil
        }
        
        return record
    }
    
    func skillToString() -> String {
        switch self.skillLevel {
        case .beginner: return "Beginner"
        case .intermediate: return "Intermediate"
        case .advanced: return "Advanced"
        case .professional: return "Professional"
        case .none: return "Not Specified"
        }
    }
    
    func preferredPositionToString() -> String {
        switch self.preferredPosition {
        case .Forward: return "Forward"
        case .Defender: return "Defender"
        case .Goalkeeper: return "Goalkeeper"
        case .Midfielder: return "Midfielder"
        case .none: return "Not Specified"
        }
    }
    
    mutating func setProfilePicture(_ image: Data) {
        self.profilePicture = image
    }
}
