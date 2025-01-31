//
//  AppCoordinator.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 31.01.2025.
//


import SwiftUI

class AppCoordinator: ObservableObject {
    @Published var currentView: AppView = .main

    enum AppView {
        case onboarding
        case main
    }

    func showOnboarding() {
        currentView = .onboarding
    }

    func showMainView() {
        currentView = .main
    }
    
}
