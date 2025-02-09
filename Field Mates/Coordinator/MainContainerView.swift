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
                .sheet(
                    isPresented: Binding(
                        get: { mainCoordinator.currentStep == .addMatchSheet },
                        set: { isPresented in
                            // When sheet is dismissed, go back to .home or some other step
                            if !isPresented {
                                mainCoordinator.goToHome()
                            }
                        }
                    )
                ) {
                    // The content of your sheet
                    AddMatchView()
                        .presentationDetents([.large]) // or .height(400), etc., if you want
                }

        }
    }
}

#Preview {
    MainContainerView()
}
