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
    @StateObject var launchScreenState = LaunchScreenStateManager()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                if launchScreenState.state != .finished {
                    LaunchScreenView()
                }
            }
            .environmentObject(appDelegate.userViewModel)
            .environmentObject(launchScreenState)
        }
    }
}
