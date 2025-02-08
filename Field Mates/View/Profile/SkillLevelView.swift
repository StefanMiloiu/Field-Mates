//
//  SkillLevelView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 03.02.2025.
//

import SwiftUI

struct SkillLevelView: View {
    @State private var selectedIndex: Int = 4
    @EnvironmentObject var userViewModel: UserViewModel

    let skillLevels = ["Beginner", "Intermediate", "Advanced", "Professional", "Unknown"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Aproprite Skill Level")
                .font(.headline)
                .padding()
            
            SemicircleSlider(selectedIndex: $selectedIndex, labels: skillLevels)
                .frame(height: 250)
            
            Spacer(minLength: 50) // Reserve space for the description to prevent layout shifts
            
            Text("\(skillLevels[selectedIndex])")
                .font(.title)
                .padding()
            
            if selectedIndex == 0 {
                Text("Choose this skill level if you’re new to the game or still developing your abilities. This level is perfect for those who want to learn the basics, improve their understanding of the game, and gain confidence while playing")
                    .font(.subheadline)
                    .padding()
                    .multilineTextAlignment(.center)
            } else if selectedIndex == 1 {
                Text("Choose this level if you have a solid understanding of the game and can play at a moderate level. You are comfortable with the basics, can contribute to a team, and are looking to refine your skills and decision-making on the field")
                    .font(.subheadline)
                    .padding()
                    .multilineTextAlignment(.center)
            } else if selectedIndex == 2 {
                Text("Choose this level if you are highly skilled and have a strong understanding of the game. You can play at a competitive level, demonstrate excellent ball control and decision-making, and contribute significantly to a team. You have experience playing in structured matches and can adapt to different game situations with confidence")
                    .font(.subheadline)
                    .padding()
                    .multilineTextAlignment(.center)
            } else if selectedIndex == 3 {
                Text("Choose this level if you are an elite player with exceptional football skills and deep game knowledge. You consistently perform at a high level, understand advanced tactics, and can lead a team effectively. You play frequently, maintain top-level fitness, and are experienced in competitive environments")
                    .font(.subheadline)
                    .padding()
                    .multilineTextAlignment(.center)
            }
        }
        .onChange(of: selectedIndex) {
            guard selectedIndex != 4 else {
                userViewModel.user?.skillLevel = nil
                userViewModel.updateUser(userViewModel.user!)
                return
            }
            guard userViewModel.user != nil,
                  userViewModel.user?.skillLevel != SkillLevel.allCases[selectedIndex]
            else { return }
            var connectedUserCopy = userViewModel.user
            connectedUserCopy?.skillLevel = SkillLevel.allCases[selectedIndex]
            userViewModel.user = nil
            userViewModel.user = connectedUserCopy
            userViewModel.updateUser(userViewModel.user!)
        }
        .onAppear {
            if userViewModel.user?.skillLevel != nil {
                selectedIndex = Int((userViewModel.user?.skillLevel!)!.rawValue)
            }
        }
        .navigationBarTitle("Skill Level", displayMode: .inline)
    }
}

#Preview {
    SkillLevelView()
}
