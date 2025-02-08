//
//  AppCoordinator.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 31.01.2025.
//

import SwiftUI

//MARK: - AppCoordinator
/// The root application coordinator that manages the app's flow.
class AppCoordinator: ObservableObject {
    
    /// The current active flow in the app.
    @Published var currentFlow: Flow = .onboarding
    
    let onboardingCoordinator = OnboardingCoordinator()
    let mainCoordinator = MainCoordinator()
    let profileCoordinator = ProfileCoordinator()
    
    /// Defines the possible flows in the app.
    enum Flow {
        case onboarding
        case main
        case profile
    }
    
    /// Determines which flow to start based on login status.
    func start() {
        if UserDefaults.standard.isLoggedIn {
            currentFlow = .main
        } else {
            currentFlow = .onboarding
        }
    }
    
    /// Transitions from onboarding to the main app flow.
    func didFinishOnboarding() {
        currentFlow = .main
    }
}

//MARK: - OnboardingCoordinator
/// Manages the onboarding flow of the app.
class OnboardingCoordinator: ObservableObject {
    
    /// The current onboarding step.
    @Published var currentStep: OnboardingStep = .welcome
    
    /// Represents the different onboarding steps.
    enum OnboardingStep {
        case welcome
        case createAccount
        case existingAccount
    }
    
    /// Navigates to the welcome screen.
    func goToWelcome() {
        currentStep = .welcome
    }
    
    /// Navigates to the create account screen.
    func goToCreateAccount() {
        currentStep = .createAccount
    }
    
    /// Navigates to the existing account screen.
    func goToExistingAccount() {
        currentStep = .existingAccount
    }
}

//MARK: - ProfileCoordinator
/// Manages the profile section navigation.
class ProfileCoordinator: ObservableObject {
    
    @Published var currentStep: ProfileStep = .profile
    @Published var navigationController: UINavigationController?

    /// Starts the profile flow from a given navigation controller.
    func start(from navigationController: UINavigationController?) {
        self.navigationController = navigationController
        goToProfile() // Set the initial screen
    }
    
    /// Represents the different profile-related steps.
    enum ProfileStep {
        case profile
        case skillLevel
        case position
        case personalInformation
        case editAccount
    }
    
    /// Navigates to the profile screen.
    func goToProfile() {
        currentStep = .profile
        navigationController?.popToRootViewController(animated: true)
    }

    /// Navigates to the skill level selection screen.
    func goToSkillLevel() {
        currentStep = .skillLevel
        let skillLevelView = UIHostingController(rootView: SkillLevelView())
        navigationController?.pushViewController(skillLevelView, animated: true)
    }
    
    /// Navigates to the position selection screen.
    func goToPosition() {
        currentStep = .position
        let positionView = UIHostingController(rootView: PlayerPositionView())
        navigationController?.pushViewController(positionView, animated: true)
    }
    
    /// Navigates to the personal information screen.
    func goToPersonalInformation() {
        currentStep = .personalInformation
        let personalInformationView = UIHostingController(rootView: PersonalInformationView())
        navigationController?.pushViewController(personalInformationView, animated: true)
    }
    
    /// Navigate to edit account
    func goToEditAccount() {
        currentStep = .editAccount
        let editAccountView = UIHostingController(rootView: CreateAccountView())
        navigationController?.pushViewController(editAccountView, animated: true)
    }
}

//MARK: - MainViewCoordinator
/// Manages the main app navigation.
class MainCoordinator: ObservableObject {
    
    @Published var currentStep: MainStep = .home
    
    /// Represents the main sections of the app.
    enum MainStep {
        case home
        case settings
    }
    
    /// Navigates to the home screen.
    func goToHome() {
        currentStep = .home
    }
    
    /// Navigates to the settings screen.
    func goToSettings() {
        currentStep = .settings
    }
}

//MARK: - SettingsCoordinator
/// Handles settings-related navigation.
class SettingsCoordinator: ObservableObject {
    
    @Published var currentStep: SettingsStep = .account
    
    /// Represents different settings sections.
    enum SettingsStep {
        case account
        case privacy
    }
}
