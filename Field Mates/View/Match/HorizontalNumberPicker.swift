//
//  HorizontalNumberPicker.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 09.02.2025.
//
import SwiftUI

struct HorizontalNumberPicker: View {
    @Binding var selectedNumber: Int // Default selection
    
    let numbers = Array(1...20) // Array of numbers from 1 to 20
    
    var body: some View {
        VStack(spacing: 10) {
            // Selected Number Display
            Text("Maximum number of players")
                .foregroundStyle(.gray)
                .fontWeight(.bold)
            
            // Horizontal ScrollView with Center Alignment
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(numbers, id: \.self) { number in
                        Text("\(number)")
                            .font(.title2)
                            .fontWeight(number == selectedNumber ? .bold : .regular) // Highlight the selected number
                            .foregroundColor(number == selectedNumber ? .appDarkGreen : .gray)
                            .padding(.horizontal)
                            .background(
                                Circle()
                                    .fill(number == selectedNumber ? Color.appDarkGreen.opacity(0.2) : Color.clear)
                                    .frame(width: 40, height: 40)
                            )
                            .onTapGesture {
                                withAnimation {
                                    selectedNumber = number
                                }
                            }
                            .scrollTransition() { content, phase in
                                content.opacity(phase.isIdentity ? 1.0 : 0.0)
                                        .scaleEffect(x: phase.isIdentity ? 1.0 : 0.3,
                                                    y: phase.isIdentity ? 1.0 : 0.3)
                                        .offset(y: phase.isIdentity ? 0 : -20)
                            }
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(10, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            .padding(.horizontal, 25)
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 40, height: 100)
        .background(.white.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 40))
    }
}

#Preview {
    HorizontalNumberPicker(selectedNumber: .constant(1))
}
