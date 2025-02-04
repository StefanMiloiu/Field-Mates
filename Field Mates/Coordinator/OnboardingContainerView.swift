//
//  OnboardingContainerView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 01.02.2025.
//

import SwiftUI

/// A container view that manages the onboarding flow based on the current step.
struct OnboardingContainerView: View {
    
    /// The onboarding coordinator that determines the current onboarding step.
    @EnvironmentObject var onboardingCoordinator: OnboardingCoordinator
    
    var body: some View {
        switch onboardingCoordinator.currentStep {
        case .welcome:
            OnboardingView()
        case .createAccount:
            CreateAccountView()
        case .existingAccount:
            AccountExistsView(email: UserDefaults.standard.email ?? "")
        }
    }
}
