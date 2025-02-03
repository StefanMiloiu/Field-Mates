//
//  SkillLevelView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 03.02.2025.
//

import SwiftUI

struct SkillLevelView: View {
    @Binding var connectedUser: User?
    @State private var selectedIndex: Int = 0
    private let cloudKitManager = GenericCloudKitManager()

    let skillLevels = ["Beginner", "Intermediate", "Advanced", "Professional", "Unknown"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Aproprite Skill Level")
                .font(.headline)
                .padding()
            
            SemicircleSlider(selectedIndex: $selectedIndex, labels: skillLevels, connectedUser: connectedUser)
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
                connectedUser?.skillLevel = nil
                cloudKitManager.update(connectedUser!) { result in
                    switch result {
                    case .success(_):
                        print("Succesfuly removed skill")
                    case .failure(_):
                        print("Failure removing skill")
                    }
                }
                return
            }
            var connectedUserCopy = connectedUser
            connectedUserCopy?.skillLevel = SkillLevel.allCases[selectedIndex]
            connectedUser = nil
            connectedUser = connectedUserCopy
            guard connectedUser != nil else { return }
            cloudKitManager.update(connectedUser!) { result in
                switch result {
                case .success(_):
                    print("Succesfully updated skill")
                case .failure(_):
                    print("Failure updating skill")
                }
            }
        }
        .onAppear {
            if connectedUser?.skillLevel != nil {
                selectedIndex = Int((connectedUser?.skillLevel!)!.rawValue)
            }
        }
        .navigationBarTitle("Skill Level", displayMode: .inline)
    }
}

#Preview {
    SkillLevelView(connectedUser: .constant(nil))
}
