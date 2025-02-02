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
                    Text("Home")
                }
            SignOutButton()
                .tabItem {
                    Text("Sign Out")
                }
            profile
                .tabItem {
                    Image(systemName: "gear")
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
    
}

#Preview {
    MainView()
}
