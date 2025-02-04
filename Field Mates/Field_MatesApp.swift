//
//  Field_MatesApp.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 30.01.2025.
//

import SwiftUI

@main
struct Field_MatesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate // Declare AppDelegate here

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appDelegate.userViewModel) // Inject environment objects
        }
    }
}
