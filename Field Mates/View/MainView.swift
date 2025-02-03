//
//  MainView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 31.01.2025.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var profileCoodrinator: ProfileCoordinator
    @State var connetctedUser: User? = nil
    private let cloudKitManager = GenericCloudKitManager()

    var body: some View {
        TabView {
            Text("Hello, World!")
                .tabItem {
                    Image(systemName: "house")
                    Text("Feed")
                }
            activeChats
                .tabItem {
                    Image(systemName: "message")
                    Text("Chat")
                }
            profile
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Player")
                }
        }
        .onAppear {
            let predicate = NSPredicate(format: "uuid == %@", UserDefaults.standard.appleUserID ?? "User ID")
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
    
    var profile: some View {
        ProfileContainerView(connetctedUser: $connetctedUser)
    }
    
    var activeChats: some View {
        Text("Chats")
    }
    
}

#Preview {
    MainView()
        .environmentObject(ProfileCoordinator())
}
