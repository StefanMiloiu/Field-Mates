//
//  ProfileView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 02.02.2025.
//

import SwiftUI

struct ProfileView: View {
    // MARK: - Environment Objects
    @EnvironmentObject var coordinator: AppCoordinator // Coordinator to manage navigation
    @EnvironmentObject var userViewModel: UserViewModel // ViewModel for user-related data
    @Environment(\.colorScheme) var colorScheme // Detect the current color scheme
    
    // MARK: - State Variables
    @State private var skillLevel: String = "Not Defined" // Skill level placeholder
    
    // MARK: - Computed Properties
    /// Retrieves the user's profile picture URL from CloudKit
    private var profilePicURL: URL? {
        guard let profilePicture = userViewModel.user?.profilePicture else { return nil }
        do {
            return try Data.fileURL(for: profilePicture)
        } catch {
            print("Error generating file URL for profile picture: \(error)")
            return nil
        }
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // MARK: - Background
            Color.grayBackground.opacity(1)
                .ignoresSafeArea(.all) // Sets the background for the entire view
            
            VStack {
                // MARK: - Profile Card Section
                Section {
                    CustomProfileCardView(
                        profilePictureURL: profilePicURL,
                        email: userViewModel.user?.email ?? "Could not retrieve email\n",
                        lastName: userViewModel.user?.lastName ?? "Could not retrieve last name\n",
                        firstName: userViewModel.user?.firstName ?? "Could not retrieve first name\n"
                    )
                }
                
                // MARK: - Profile List
                List {
                    // MARK: Profile Section
                    Section {
                        // Skill Level Button
                        Button(action: {
                            coordinator.mainCoordinator.profileCoordinator.goToSkillLevel()
                        }) {
                            CustomListRow(
                                rowLabel: "\(userViewModel.user?.skillLevel?.localizedDescription() ?? "Not Specified")",
                                rowContent: "Skill Level",
                                rowTintColor: .appLightGreen,
                                rowIcon: "soccerball"
                            )
                        }
                        .listRowBackground(colorScheme == .dark ? Color.appDarkGreen.opacity(0.35) : Color.white)
                        
                        // Player Position Button
                        Button(action: {
                            coordinator.mainCoordinator.profileCoordinator.goToPosition()
                        }) {
                            CustomListRow(
                                rowLabel: "\(userViewModel.user?.preferredPosition?.localizedDescription() ?? "Not Specified")",
                                rowContent: "Player position",
                                rowTintColor: .appLightGreen,
                                rowIcon: "figure.australian.football"
                            )
                        }
                        .listRowBackground(colorScheme == .dark ? Color.appDarkGreen.opacity(0.35) : Color.white)
                        
                        // Personal Information Button
                        Button(action: {
                            coordinator.mainCoordinator.profileCoordinator.goToPersonalInformation()
                        }) {
                            CustomListRow(
                                rowLabel: "Personal Information",
                                rowContent: "Matches",
                                rowTintColor: .appDarkGray,
                                rowIcon: "person.crop.circle.fill"
                            )
                        }
                        .listRowBackground(colorScheme == .dark ? Color.appMediumGray.opacity(0.45) : Color.white)
                    } header: {
                        Text("Profile")
                            .font(.subheadline)
                            .foregroundStyle(colorScheme == .dark ? Color.black : .primary)
                            .bold()
                    }
                    
                    // MARK: Account Settings Section
                    Section {
                        // Edit Account Button
                        Button(action: {
                            coordinator.mainCoordinator.profileCoordinator.goToEditAccount()
                        }) {
                            CustomListRow(
                                rowLabel: "Edit account",
                                rowContent: "",
                                rowTintColor: .gray,
                                rowIcon: "gear"
                            )
                        }
                        .listRowBackground(colorScheme == .dark ? Color.appMediumGray.opacity(0.45) : Color.white)
                        
                        // Log Out Button
                        Button(action: {
                            UserDefaults.standard.appleUserID = ""
                            UserDefaults.standard.seenOnboarding = false
                            UserDefaults.standard.isLoggedIn = false
                            coordinator.onboardingCoordinator.goToWelcome()
                            coordinator.start()
                        }) {
                            CustomListRow(
                                rowLabel: "Log out",
                                rowContent: "",
                                rowTintColor: .gray,
                                rowIcon: "door.left.hand.open"
                            )
                        }
                        .listRowBackground(colorScheme == .dark ? Color.appMediumGray.opacity(0.45) : Color.white)
                    } header: {
                        HStack {
                            Text("Account Settings")
                                .font(.subheadline)
                                .foregroundStyle(colorScheme == .dark ? Color.black : .primary)
                                .bold()
                        }
                    }
                }
                .scrollContentBackground(.hidden) // Removes the default List background
                .background(Color.clear) // Custom background for the List
                .cornerRadius(20) // Adds rounded corners to the List
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(UserViewModel())
}
