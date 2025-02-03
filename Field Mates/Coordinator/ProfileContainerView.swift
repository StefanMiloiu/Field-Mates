//
//  ProfileContainerView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 03.02.2025.
//

import SwiftUI

struct ProfileContainerView: View {
    @EnvironmentObject var coordinator: ProfileCoordinator
    @Binding var connetctedUser: User?
    
    var body: some View {
        NavigationStack {
            ProfileView(connectedUser: $connetctedUser)
                .navigationDestination(isPresented: Binding(
                    get: { coordinator.currentStep == .skillLevel },
                    set: { _ in coordinator.goToProfile() } // Go back when dismissed
                )) {
                    SkillLevelView(connectedUser: $connetctedUser)
                        .toolbarBackground(.visible, for: .navigationBar)
                        .tint(.red)
                }
                .navigationDestination(isPresented: Binding(
                    get: { coordinator.currentStep == .position },
                    set: { _ in coordinator.goToProfile() } // Go back when dismissed
                )) {
                    PlayerPositionView(connectedUser: $connetctedUser)
                        .toolbarBackground(.visible, for: .navigationBar)
                        .tint(.red)
                }
                .navigationDestination(isPresented: Binding(
                    get: { coordinator.currentStep == .personalInformation },
                    set: { _ in coordinator.goToProfile() } // Go back when dismissed
                )) {
                    PersonalInformationView(connectedUser: $connetctedUser)
                        .toolbarBackground(.visible, for: .navigationBar)
                }
                       
        }
        .tint(.primary)
    }
}

#Preview {
    ProfileContainerView(connetctedUser: .constant(nil))
}
