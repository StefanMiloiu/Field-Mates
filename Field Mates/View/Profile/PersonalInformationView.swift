//
//  PersonalInformationView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 03.02.2025.
//

import SwiftUI

struct PersonalInformationView: View {
    @Binding var connectedUser: User?
    
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    PersonalInformationView(connectedUser: .constant(nil))
}
