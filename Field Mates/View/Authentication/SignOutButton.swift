//
//  SignOutButton.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 31.01.2025.
//

import SwiftUI

struct SignOutButton: View {
    
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        Button {
            UserDefaults.standard.appleUserID = ""
            UserDefaults.standard.seenOnboarding = false
            UserDefaults.standard.isLoggedIn = false
            coordinator.onboardingCoordinator.goToWelcome()
            coordinator.start()
        } label: {
            Image(systemName: "door.right.hand.open")
                .resizable()
                .frame(width: 32, height: 32)
                .foregroundColor(.secondary)
                .padding()
        }
    }
}

#Preview {
    SignOutButton()
}
