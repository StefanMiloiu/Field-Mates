//
//  ContentView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 30.01.2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var coordinator = AppCoordinator()

    var body: some View {
        Group {
            switch coordinator.currentView {
            case .onboarding:
                OnboardingView()
            case .main:
                MainView()
            }
        }
        .onAppear {
            if UserDefaults.standard.bool(forKey: "isLoggedIn") {
                coordinator.showMainView()
            } else {
                coordinator.showOnboarding()
            }
        }
        .environmentObject(coordinator) // Share coordinator across views
    }
}

#Preview {
    ContentView()
}
