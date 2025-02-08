//
//  PlayerPositionView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 03.02.2025.
//

import SwiftUI

struct PlayerPositionView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var selectedIndex: Int = 4

    let allPositions = ["Goalkeeper", "Defender", "Midfielder", "Forward", "Unknown"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Favourite Position")
                .font(.headline)
                .padding()
            
            SemicircleSlider(selectedIndex: $selectedIndex, labels: allPositions)
                .frame(height: 250)
                .padding(.bottom, 50)

            Text("\(allPositions[selectedIndex])")
                .font(.title)
                .fontWeight(.heavy)
                .padding(.bottom)
            
            
            Text("The position is a crucial aspect of football, as it influences a player's role, responsibilities, and performance on the field.")
                .font(.subheadline)
                .padding()
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .background(Color.appLightGray.opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
            Text("Be aware the this only means that this position is you FAVOURITE position, not that you will be assigned to this position in the future in any game.")
                .font(.subheadline)
                .padding()
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .background(Color.appLightGray.opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
            
        }
        .onChange(of: selectedIndex) {
            guard selectedIndex != 4 else {
                userViewModel.user?.preferredPosition = nil
                userViewModel.updateUser(userViewModel.user!)
                return
            }
            guard userViewModel.user != nil,
                  userViewModel.user?.preferredPosition != Position.allCases[selectedIndex] else { return }
            var connectedUserCopy = userViewModel.user
            connectedUserCopy?.preferredPosition = Position.allCases[selectedIndex]
            userViewModel.user = nil
            userViewModel.user = connectedUserCopy
            userViewModel.updateUser(userViewModel.user!)
        }
        .onAppear {
            if userViewModel.user?.preferredPosition != nil {
                let unwrappedPreferredPosition = userViewModel.user?.preferredPosition!
                selectedIndex = Position.allCases.firstIndex(of: unwrappedPreferredPosition!)!
            }
        }
        .navigationBarTitle("Position", displayMode: .inline)
    }
}

#Preview {
    PlayerPositionView()
        .environmentObject(UserViewModel())
}
