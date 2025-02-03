//
//  PlayerPositionView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 03.02.2025.
//

import SwiftUI

struct PlayerPositionView: View {
    @Binding var connectedUser: User?
    @State private var selectedIndex: Int = 4
    private let cloudKitManager = GenericCloudKitManager()

    let allPositions = ["Goalkeeper", "Defender", "Midfielder", "Forward", "Unknown"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Favourite Position")
                .font(.headline)
                .padding()
            
            SemicircleSlider(selectedIndex: $selectedIndex, labels: allPositions, connectedUser: connectedUser)
                .frame(height: 250)
            
            Spacer(minLength: 50) // Reserve space for the description to prevent layout shifts
            
            Text("The position is a crucial aspect of football, as it influences a player's role, responsibilities, and performance on the field.\n Be aware the this only means that this position is you FAVOURITE position, not that you will be assigned to this position in the future in any game.")
                .font(.subheadline)
                .padding()
                .multilineTextAlignment(.center)
            
            Text("\(allPositions[selectedIndex])")
                .font(.title)
                .padding()

        }
        .onChange(of: selectedIndex) {
            guard connectedUser != nil else { return }
            guard selectedIndex != 4 else {
                connectedUser?.preferredPosition = nil
                cloudKitManager.update(connectedUser!) { result in
                    switch result {
                    case .success(_):
                        print("Succesfuly removed position")
                    case .failure(_):
                        print("Failure removing position")
                    }
                }
                return
            }
            var connectedUserCopy = connectedUser
            connectedUserCopy?.preferredPosition = Position.allCases[selectedIndex]
            connectedUser = nil
            connectedUser = connectedUserCopy
            guard connectedUser != nil else { return }
            cloudKitManager.update(connectedUser!) { result in
                switch result {
                case .success(_):
                    print("Succesfully updated position")
                case .failure(_):
                    print("Failure updating position")
                }
            }
        }
        .onAppear {
            if connectedUser?.preferredPosition != nil {
                selectedIndex = Int((connectedUser?.preferredPosition!)!.rawValue) ??  1
            }
        }
        .navigationBarTitle("Position", displayMode: .inline)
    }
}

#Preview {
    PlayerPositionView(connectedUser: .constant(nil))
}
