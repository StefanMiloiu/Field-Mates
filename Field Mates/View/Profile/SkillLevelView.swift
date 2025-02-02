//
//  SkillLevelView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 03.02.2025.
//

import SwiftUI

struct SkillLevelView: View {
    @Binding var connectedUser: User?
    @EnvironmentObject var coordinator: ProfileCoordinator
    
    var body: some View {
        NavigationView {
            VStack {
                // Your SkillLevelView content
                Text("Skill Level Content")
                // …
            }
            .navigationBarTitle("Skill Level", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Custom back action:
                        coordinator.goToProfile()  // Navigate back to Profile
                    }) {
                        Image(systemName: "chevron.left")
                    }
                }
            }
        }
    }
}

#Preview {
    SkillLevelView(connectedUser: .constant(nil))
}
