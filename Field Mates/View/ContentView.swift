//
//  ContentView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 30.01.2025.
//

import SwiftUI
import CoreData
import CloudKit

//MARK: - ContentView
/// The main entry view for the application, managing navigation flows.
struct ContentView: View {
    
    /// The application's main coordinator, managing the flow between onboarding and the main app.
    @StateObject private var coordinator = AppCoordinator()
    
    /// The shared user view model that handles user-related data and CloudKit operations.
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        Group {
            switch coordinator.currentFlow {
            case .onboarding:
                OnboardingContainerView()
                    .environmentObject(coordinator.onboardingCoordinator)
            case .main:
                MainView()
                    .environmentObject(coordinator.mainCoordinator)
                    .environmentObject(coordinator.profileCoordinator)
            default:
                EmptyView() // Fallback case to handle unexpected states.
            }
        }
        .onAppear {
            coordinator.start() // Determine the initial app flow.
        }
        .environmentObject(coordinator) // Injects the coordinator into the environment.
    }
}

#Preview {
    ContentView()
        .environmentObject(AppCoordinator())
}

//MARK: - App Delegate
/// The application's delegate, responsible for handling lifecycle events and CloudKit notifications.
class AppDelegate: NSObject, UIApplicationDelegate {
    
    /// Shared `UserViewModel` instance to manage user data.
    var userViewModel = UserViewModel()
    
    /// Handles push notifications from CloudKit.
    /// - Parameters:
    ///   - application: The shared application instance.
    ///   - userInfo: The dictionary containing notification data.
    /// - Returns: A `UIBackgroundFetchResult` indicating if new data was retrieved.
    @MainActor
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async -> UIBackgroundFetchResult {
        // Check if the notification is from CloudKit and related to user changes
        if let notification = CKNotification(fromRemoteNotificationDictionary: userInfo),
           notification.subscriptionID == "UserChanges" {
            print("📩 Received CloudKit notification for UserChanges")
            
            // Fetch updated user data
            await MainActor.run {
                userViewModel.fetchUserByID()
            }
            return .newData
        }
        return .noData
    }
    
    /// Called when the application finishes launching.
    /// - Parameters:
    ///   - application: The shared application instance.
    ///   - launchOptions: Dictionary containing launch options.
    /// - Returns: A Boolean indicating whether the app successfully launched.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        requestNotificationPermissions()
        application.registerForRemoteNotifications()
        userViewModel.setupSubscription() // Ensure CloudKit subscription is set up.
        return true
    }
    
    /// Requests push notification permissions from the user.
    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("❌ Failed to request notification permissions: \(error.localizedDescription)")
            } else {
                print("✅ Notification permissions granted: \(granted)")
            }
        }
    }
}
