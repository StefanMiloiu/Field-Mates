//
//  UserDefaults+Helper.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 31.01.2025.
//

import Foundation

/*
 UserDefaults.standard.set(userID, forKey: "appleUserID")
 UserDefaults.standard.set(true, forKey: "seenOnboarding")
 UserDefaults.standard.set(true, forKey: "isLoggedIn")
 */
extension UserDefaults {
    
    var isLoggedIn: Bool {
        get {
            return bool(forKey: "isLoggedIn")
        }
        set {
            set(newValue, forKey: "isLoggedIn")
        }
    }
    
    var seenOnboarding: Bool {
        get {
            return bool(forKey: "seenOnboarding")
        }
        set {
            set(newValue, forKey: "seenOnboarding")
        }
    }
    
    var appleUserID: String? {
        get {
            return string(forKey: "appleUserID")
        }
        set {
            set(newValue, forKey: "appleUserID")
        }
    }
    
    var email: String? {
        get {
            return string(forKey: "email")
        }
        set {
            set(newValue, forKey: "email")
        }
    }
    
}


