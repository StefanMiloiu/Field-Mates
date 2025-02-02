//
//  OnboardingContainerView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 01.02.2025.
//

import SwiftUI

struct OnboardingContainerView: View {
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
