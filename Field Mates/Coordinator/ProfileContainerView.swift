//
//  ProfileContainerView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 03.02.2025.
//

import SwiftUI

/// A container view that manages navigation within the profile section.
struct ProfileContainerView: View {
    
    /// The coordinator responsible for managing profile-related navigation.
    @EnvironmentObject var coordinator: ProfileCoordinator
    
    var body: some View {
        NavigationStack {
            ProfileView()
                .navigationDestination(
                    isPresented: Binding(
                        get: { coordinator.currentStep == .skillLevel },
                        set: { _ in coordinator.goToProfile() } // Returns to the profile screen when dismissed
                    )
                ) {
                    SkillLevelView()
                        .toolbarBackground(.visible, for: .navigationBar)
                        .tint(.red)
                }
                .navigationDestination(
                    isPresented: Binding(
                        get: { coordinator.currentStep == .position },
                        set: { _ in coordinator.goToProfile() }
                    )
                ) {
                    PlayerPositionView()
                        .toolbarBackground(.visible, for: .navigationBar)
                        .tint(.red)
                }
                .navigationDestination(
                    isPresented: Binding(
                        get: { coordinator.currentStep == .personalInformation },
                        set: { _ in coordinator.goToProfile() }
                    )
                ) {
                    PersonalInformationView()
                        .toolbarBackground(.visible, for: .navigationBar)
                }
                .navigationDestination(
                    isPresented: Binding(
                        get: { coordinator.currentStep == .editAccount },
                        set: { _ in coordinator.goToProfile() }
                    )
                ) {
                    CreateAccountView()
                        .toolbarBackground(.visible, for: .navigationBar)
                }
        }
        .tint(.primary)
    }
}

#Preview {
    ProfileContainerView()
}
