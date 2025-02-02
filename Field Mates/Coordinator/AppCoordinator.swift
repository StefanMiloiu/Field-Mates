//
//  AppCoordinator.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 31.01.2025.
//


import SwiftUI

class AppCoordinator: ObservableObject {
    // The root coordinator that decides if we show the onboarding flow or the main flow
    @Published var currentFlow: Flow = .onboarding
    
    let onboardingCoordinator = OnboardingCoordinator()
    let mainCoordinator = MainCoordinator()
    let profileCoordinator = ProfileCoordinator()
    
    enum Flow {
        case onboarding
        case main
        case profile
    }
    
    func start() {
        // Decide which flow to start (onboarding vs. main) based on login status, user defaults, etc.
        if UserDefaults.standard.isLoggedIn {
            currentFlow = .main
        } else {
            currentFlow = .onboarding
        }
    }
    
    func didFinishOnboarding() {
        currentFlow = .main
    }
    
}

class OnboardingCoordinator: ObservableObject {
    // Handles multiple steps in the onboarding process
    @Published var currentStep: OnboardingStep = .welcome
    
    enum OnboardingStep {
        case welcome
        case createAccount
        case existingAccount
    }
    
    func goToWelcome() {
        currentStep = .welcome
    }
    
    func goToCreateAccount() {
        currentStep = .createAccount
    }
    
    func goToExistingAccount() {
        currentStep = .existingAccount
    }
    
}

class ProfileCoordinator: ObservableObject {
    @Published var currentStep: ProfileStep = .profile

    enum ProfileStep {
        case profile
        case skillLevel
    }
    
    func goToProfile() {
        currentStep = .profile
    }
    
    func goToSkillLevel() {
        currentStep = .skillLevel
    }
}

class MainCoordinator: ObservableObject {
    // Handles the main app flow
    
    @Published var currentStep: MainStep = .home
    
    enum MainStep {
        case home
        case settings
    }
    
    func goToHome() {
        currentStep = .home
    }
    
    func goToSettings() {
        currentStep = .settings
    }
}

class SettingsCoordinator: ObservableObject {
    
    @Published var currentStep: SettingsStep = .account
    
    enum SettingsStep {
        case account
        case privacy
    }
    
    
    
}
