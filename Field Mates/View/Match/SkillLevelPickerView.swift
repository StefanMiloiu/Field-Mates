//
//  SkillLevelPickerView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 09.02.2025.
//

import SwiftUI

struct SkillLevelPickerView: View {
    @Binding var selectedPickerValue: String
    
    var body: some View {
        HStack {
            Text("Minimum skill level")
                .foregroundStyle(.gray)
                .fontWeight(.bold)
            Picker("Skill Level", selection: $selectedPickerValue) {
                Text("None").tag("None")
                Text("Beginner").tag("Beginner")
                Text("Intermediate").tag("Intermediate")
                Text("Advanced").tag("Advanced")
                Text("Professional").tag( "Professional")
            }
            .tint(.appDarkGreen)
        }
        .frame(width: UIScreen.main.bounds.width - 40, height: 50)
        .background(.white.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 45))
        .padding()
    }
}

#Preview {
    SkillLevelPickerView(selectedPickerValue: .constant("None"))
}
