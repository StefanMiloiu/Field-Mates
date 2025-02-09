//
//  DateAndTimePicker.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 09.02.2025.
//

import SwiftUI

struct DateAndTimePicker: View {
    
    @Binding var date: Date
    @Binding var time: Date
    @Binding var fullDate: Date
    
    var body: some View {
        HStack(spacing: 16) {
            Spacer()
            // Date Picker
            VStack(alignment: .leading, spacing: 8) {
                Text("Date")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                
                DatePicker("", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .tint(.appDarkGreen)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color.white.opacity(0.6))
            )
            Spacer()
            // Time Picker
            VStack(alignment: .leading, spacing: 8) {
                Text("Time")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                
                DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .tint(.appDarkGreen)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color.white.opacity(0.6))
            )
            
            Spacer()
        }
        .padding()
        .onChange(of: date) {
            updateFullDate()
        }
        .onChange(of: time) {
            updateFullDate()
        }
        .frame(maxWidth: UIScreen.main.bounds.width - 40)
    }
    
    private func updateFullDate() {
        // Merge date and time
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        
        if let combinedDate = calendar.date(from: DateComponents(
            year: dateComponents.year,
            month: dateComponents.month,
            day: dateComponents.day,
            hour: timeComponents.hour,
            minute: timeComponents.minute
        )) {
            fullDate = combinedDate
        }
    }
}

#Preview {
    DateAndTimePicker(date: .constant(Date()), time: .constant(Date()), fullDate: .constant(Date()))
}
