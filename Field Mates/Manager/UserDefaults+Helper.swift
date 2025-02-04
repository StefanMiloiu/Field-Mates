//
//  UserDefaults+Helper.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 31.01.2025.
//

import Foundation

/// An extension of `UserDefaults` to simplify access to commonly used keys.
extension UserDefaults {
    
    /// A Boolean value indicating whether the user is logged in.
    var isLoggedIn: Bool {
        get { bool(forKey: "isLoggedIn") }
        set { set(newValue, forKey: "isLoggedIn") }
    }
    
    /// A Boolean value indicating whether the user has completed the onboarding process.
    var seenOnboarding: Bool {
        get { bool(forKey: "seenOnboarding") }
        set { set(newValue, forKey: "seenOnboarding") }
    }
    
    /// The unique identifier for the user when signing in with Apple.
    var appleUserID: String? {
        get { string(forKey: "appleUserID") }
        set { set(newValue, forKey: "appleUserID") }
    }
    
    /// The stored email address of the user.
    var email: String? {
        get { string(forKey: "email") }
        set { set(newValue, forKey: "email") }
    }
}
