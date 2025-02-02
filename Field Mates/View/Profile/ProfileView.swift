//
//  ProfileView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 02.02.2025.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var cloudKitManager = GenericCloudKitManager()
    @State private var connetctedUser: User? = nil
    
    var body: some View {
        ScrollView {
            Section {
                CustomProfileCardView(profilePictureURL: nil,
                                      email: connetctedUser?.email ?? "Could not retrieve email",
                                      lastName: connetctedUser?.lastName ?? "Could not retrieve last name",
                                      firstName: connetctedUser?.firstName ?? "Could not retrieve first name")
            } header: {
                Text("Your Profile")
                    .fontWeight(.medium)
            }
            
            Section {
                List {
                    Label(title: { Text("Change Password") }) {
                        
                    }
                }
            } header: {
                Text("Account Settings")
                    .fontWeight(.medium)
            }
            .listRowBackground(Color.clear)
        }
        .onAppear {
            let predicate = NSPredicate(format: "uuid == %@", UserDefaults.standard.appleUserID!)
            cloudKitManager.fetchAll(ofType: User.self, predicate: predicate) { result in
                switch result {
                case .success(let users):
                    if let currentUser = users.first {
                        self.connetctedUser = currentUser
                    }
                case .failure(let error):
                    print("No user found: \(error)")
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
