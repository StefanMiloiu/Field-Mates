//
//  MainView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 31.01.2025.
//

import SwiftUI

/// The main view of the app, providing tab-based navigation.
struct MainView: View {
    
    /// Manages navigation within the profile section.
    @EnvironmentObject var profileCoordinator: ProfileCoordinator
    
    /// Handles user-related data and CloudKit interactions.
    @EnvironmentObject var userViewModel: UserViewModel

    var body: some View {
        TabView {
            feedTab
                .tabItem {
                    Image(systemName: "house")
                    Text("Feed")
                }
            chatTab
                .tabItem {
                    Image(systemName: "message")
                    Text("Chat")
                }
            profileTab
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Player")
                }
        }
        .onAppear {
            userViewModel.fetchUserByID() // Fetch user data when MainView appears.
        }
    }
    
    /// The main feed tab.
    private var feedTab: some View {
        Text("Hello, World!") // Replace with actual feed content.
    }
    
    /// The active chats tab.
    private var chatTab: some View {
        Text("Chats") // Replace with an actual chat view.
    }
    
    /// The profile tab containing the user's profile details.
    private var profileTab: some View {
        ProfileContainerView()
            .environmentObject(profileCoordinator)
    }
}

#Preview {
    MainView()
        .environmentObject(ProfileCoordinator())
        .environmentObject(UserViewModel())
}
