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
        .onAppear {
            coordinator.start()
        }
        .environmentObject(coordinator)
    }
}

#Preview {
    ContentView()
}
