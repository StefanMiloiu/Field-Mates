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
    @EnvironmentObject private var launchScreenState: LaunchScreenStateManager
    
    /// The application's main coordinator, managing the flow between onboarding and the main app.
    @StateObject private var coordinator = AppCoordinator()
    
    /// The shared user view model that handles user-related data and CloudKit operations.
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var showiCloudAlert = false
    @State private var isRefreshing: Bool = false
    
    var body: some View {
        Group {
            if showiCloudAlert {
                VStack {
                    Text("iCloud Sign-In Required")
                        .font(.title)
                        .padding()
                    Text("You must be signed into iCloud to use Field Mates. Please sign in from Settings.")
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button("Open Settings") {
                        openiCloudSettings()
                    }
                    Button("Try Again") {
                        let icloud = ICloudUserDataManager()
                        icloud.getICloudStatus { status in
                            DispatchQueue.main.async {
                                if status == .available {
                                    showiCloudAlert = false
                                    refreshApp()
                                } else {
                                    print("⚠️ Still not signed into iCloud.")
                                }
                            }
                        }
                    }
                    .padding()
                    .buttonStyle(.bordered)
                }
            } else {
                switch coordinator.currentFlow {
                case .onboarding:
                    OnboardingContainerView()
                        .environmentObject(coordinator.onboardingCoordinator)
                case .main:
                    MainView()
                        .environmentObject(coordinator.mainCoordinator)
                        .environmentObject(coordinator.profileCoordinator)
                default:
                    EmptyView()
                }
            }
        }
        .task {
            try? await Task.sleep(for: Duration.seconds(1))
            self.launchScreenState.dismiss()
        }
        .onAppear {
            coordinator.start() // Determine the initial app flow.
        }
        .onReceive(NotificationCenter.default.publisher(for: .icloudAuthenticationRequired)) { _ in
            showiCloudAlert = true
        }
        .onReceive(NotificationCenter.default.publisher(for: .icloudAuthenticationSuccess)) { _ in
            showiCloudAlert = false
//            refreshApp()
        }
        .environmentObject(coordinator) // Injects the coordinator into the environment.
    }
    
    /// Opens the iCloud settings page
    private func openiCloudSettings() {
        if let url = URL(string: "App-Prefs:root=APPLE_ACCOUNT") {
            UIApplication.shared.open(url)
        }
    }
    
    /// Refreshes the app when the user signs in to iCloud
    private func refreshApp() {
        isRefreshing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isRefreshing = false
            coordinator.start()
            userViewModel.fetchUserByID()
        }
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
    // Create a non‑optional instance of UserViewModel here.
    var userViewModel: UserViewModel = UserViewModel()
    private var iCloudCheckTimer: Timer?

    override init() {
        super.init()
        // This instance is created only once.
        print("Initialized UserViewModel in AppDelegate.")
    }
    
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
        
        let icloud = ICloudUserDataManager()
        icloud.getICloudStatus { status in
            DispatchQueue.main.async {
                if status == .available {
                    print("✅ User is signed in to iCloud")
                    self.userViewModel.setupSubscription()
                } else {
                    print("⚠️ User is NOT signed into iCloud")
                    NotificationCenter.default.post(name: .icloudAuthenticationRequired, object: nil)
                    self.startiCloudMonitoring()
                }
            }
        }
        
        return true
    }
    
    /// Continuously checks if the user has signed into iCloud
    private func startiCloudMonitoring() {
        iCloudCheckTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            let icloud = ICloudUserDataManager()
            icloud.getICloudStatus { status in
                DispatchQueue.main.async {
                    if status == .available {
                        print("✅ User just signed into iCloud! Refreshing app.")
                        NotificationCenter.default.post(name: .icloudAuthenticationSuccess, object: nil)
                        self.iCloudCheckTimer?.invalidate() // Stop checking
                    }
                }
            }
        }
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

extension Notification.Name {
    static let icloudAuthenticationRequired = Notification.Name("icloudAuthenticationRequired")
    static let icloudAuthenticationSuccess = Notification.Name("icloudAuthenticationSuccess")
}
