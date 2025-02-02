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
        VStack {
            switch coordinator.currentStep {
            case .profile:
                ProfileView(connetctedUser: $connetctedUser)
            case .skillLevel:
                SkillLevelView(connectedUser: $connetctedUser)
                    .toolbar {
                        // Add a custom back button
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                coordinator.goToProfile()
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
            }
        }
        // Optionally, wrap the entire container in a NavigationView if you want the navigation bar
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ProfileContainerView(connetctedUser: .constant(nil))
}
