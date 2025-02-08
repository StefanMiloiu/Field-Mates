//
//  MainContainerView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 08.02.2025.
//

import SwiftUI

struct MainContainerView: View {
    
    @EnvironmentObject var mainCoordinator: MainCoordinator
    @EnvironmentObject var profileCoordinator: ProfileCoordinator
    var body: some View {
        NavigationStack {
            MainView()
                .navigationDestination(
                    isPresented: Binding(
                        get: { mainCoordinator.currentStep == .profile },
                        set: { _ in mainCoordinator.goToHome() }
                    )
                ) {
                    ProfileContainerView()
                        .environmentObject(mainCoordinator.profileCoordinator)
                        .toolbarBackground(.visible, for: .navigationBar)
                        .tint(.red)
                        .toolbarBackground(
                            Color.appLightGreen,
                            for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                }
        }
        .tint(.black)
    }
}

#Preview {
    MainContainerView()
}
