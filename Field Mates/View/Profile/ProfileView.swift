//
//  ProfileView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 02.02.2025.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var profilePicURL: URL?
    @State private var skillLevel: String = "Not Defined"
    
    var body: some View {
        VStack {
            //MARK: - Profile
            Section {
                CustomProfileCardView(profilePictureURL: profilePicURL,
                                      email: userViewModel.user?.email ?? "Could not retrieve email\n",
                                      lastName: userViewModel.user?.lastName ?? "Could not retrieve last name\n",
                                      firstName: userViewModel.user?.firstName ?? "Could not retrieve first name\n")
            }
            .onAppear {
                if userViewModel.user != nil,
                   let profileURL = userViewModel.user?.profilePicture {
                    do {
                        profilePicURL = try Data.fileURL(for: profileURL)
                    } catch {
                        print("Fatal error")
                    }
                }
            }
            
            //MARK: - Profile
            List {
                Section(header: Text("Profile")
                    .font(.subheadline)
                    .foregroundColor(.primary)) {
                        Button(action: {
                            coordinator.profileCoordinator.goToSkillLevel()
                        }) {
                            CustomListRow(rowLabel: "\(userViewModel.user?.skillLevel?.localizedDescription() ?? "Not Specified")",
                                          rowContent: "Skill Level",
                                          rowTintColor: .red,
                                          rowIcon: "soccerball")
                        }
                        
                        Button(action: {
                            coordinator.profileCoordinator.goToPosition()
                        }) {
                            CustomListRow(rowLabel: "\(userViewModel.user?.preferredPosition?.localizedDescription() ?? "Not Specified")",
                                          rowContent: "Player position",
                                          rowTintColor: .red,
                                          rowIcon: "figure.australian.football")
                        }
                        
                        Button(action: {
                            coordinator.profileCoordinator.goToPersonalInformation()
                        }) {
                            CustomListRow(
                                rowLabel: "Personal Information",
                                rowContent: "Matches",
                                rowTintColor: .gray,
                                rowIcon: "person.crop.circle.fill"
                            )
                        }
                    }
                //MARK: - Account settings
                Section(header: Text("Account Settings")
                    .font(.subheadline)
                    .foregroundColor(.primary)) {
                        Button(action: {
                            coordinator.profileCoordinator.goToEditAccount()
                        }) {
                            CustomListRow(rowLabel: "Edit account",
                                          rowContent: "",
                                          rowTintColor: .gray,
                                          rowIcon: "gear")
                        }
                        
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
                    }
            }
        }
    }
}

#Preview {
    ProfileView()
}
