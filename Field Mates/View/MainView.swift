//
//  MainView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 31.01.2025.
//

import SwiftUI

struct MainView: View {
    
    var body: some View {
        TabView {
            Text("Hello, World!")
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            Text("Sign Out")
                .tabItem {
                    SignOutButton()
                }
            profile
                .tabItem {
                    Image(systemName: "gear")
                }
        }
    }
    
    var profile: some View {
        ProfileView()
    }
    
}

#Preview {
    MainView()
}
