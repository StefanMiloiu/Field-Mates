//
//  ProfileView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 02.02.2025.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var cloudKitManager = GenericCloudKitManager()
    @State private var profilePicURL: URL?
    @Binding var connetctedUser: User?
    
    var body: some View {
        VStack {
            //MARK: - Profile
            Section {
                CustomProfileCardView(profilePictureURL: profilePicURL,
                                      connectedUser: $connetctedUser,
                                      email: connetctedUser?.email ?? "Could not retrieve email\n",
                                      lastName: connetctedUser?.lastName ?? "Could not retrieve last name\n",
                                      firstName: connetctedUser?.firstName ?? "Could not retrieve first name\n")
            } header: {
                Text("\(connetctedUser?.username ?? "")")
                    .fontWeight(.medium)
            }
            .onAppear {
                if connetctedUser != nil,
                   let profileURL = connetctedUser?.profilePicture {
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
                            CustomListRow(rowLabel: "\(connetctedUser?.skillToString() ?? "Not Specified")",
                                          rowContent: "Skill Level",
                                          rowTintColor: .green,
                                          rowIcon: "soccerball")
                        }
                        
                        Button(action: {
                            
                        }) {
                            CustomListRow(rowLabel: "\(connetctedUser?.preferredPositionToString() ?? "Not Specified")",
                                          rowContent: "Player position",
                                          rowTintColor: .green,
                                          rowIcon: "figure.australian.football")
                        }
                        
                        Button(action: {
                            // ...
                        }) {
                            CustomListRow(
                                rowLabel: "Log out",
                                rowContent: "",
                                rowTintColor: .gray,
                                rowIcon: "door.left.hand.open"
                            )
                        }
                    }
                //MARK: - Account settings
                Section(header: Text("Account Settings")
                    .font(.subheadline)
                    .foregroundColor(.primary)) {
                        Button(action: {
                            
                        }) {
                            CustomListRow(rowLabel: "Edit account",
                                          rowContent: "",
                                          rowTintColor: .gray,
                                          rowIcon: "gear")
                        }
                        
                        Button(action: {
                            // ...
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
    ProfileView(connetctedUser: .constant(nil))
}
