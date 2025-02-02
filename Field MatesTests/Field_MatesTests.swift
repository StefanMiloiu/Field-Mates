//
//  Field_MatesTests.swift
//  Field MatesTests
//
//  Created by Stefan Miloiu on 30.01.2025.
//

import XCTest
import CloudKit
@testable import Field_Mates

final class Field_MatesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //MARK: - Test User CRUD
    func testSaveUser() throws {
        let user = User(id: "1", email: "test@test.com", firstName: "Test", lastName: "User")
        GenericCloudKitManager().create() { result in
            switch result {
            case .success(let user):
                XCTAssertNotNil(user)
                XCTAssertEqual(user.email, "test@test.com")
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }
    
    func testFetchUser() throws {
        GenericCloudKitManager().fetchAll(ofType: User.self) { result in
            switch result {
            case .success(let users):
                XCTAssertNotNil(users)
                XCTAssertEqual(users.count, 1)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }

}
