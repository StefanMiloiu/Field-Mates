//
//  CloudKitObject.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 31.01.2025.
//


import CloudKit

protocol CloudKitObject {
    static var recordType: String { get }
    var recordID: CKRecord.ID? { get set }
    
    var id: UUID { get }

    init?(record: CKRecord)
    func toCKRecord(_ record: CKRecord?) -> CKRecord
}
