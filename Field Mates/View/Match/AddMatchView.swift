//
//  AddMatchView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 06.02.2025.
//


//
//  AddMatchView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 06.02.2025.
//

import SwiftUI
import MapKit

struct AddMatchView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var matchViewModel = MatchViewModel()
    
    // MARK: - Match Input Fields
    @State private var location: String = ""
    @State private var matchDate: Date = Date()
    @State private var maxPlayers: Int = 10
    @State private var skillLevel: SkillLevel = .beginner
    @State private var organizerID: String = UserDefaults.standard.appleUserID ?? "UnknownOrganizer"

    // Map region
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 44.4268, longitude: 26.1025),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    // MARK: - Alert State
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        NavigationView {
            Form {
                // MARK: - Match Details Section
                Section(header: Text("Match Details")) {
                    TextField("Location (optional)", text: $location)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.words)
                    
                    DatePicker("Match Date", selection: $matchDate, displayedComponents: [.date, .hourAndMinute])
                    
                    Stepper(value: $maxPlayers, in: 2...50) {
                        Text("Maximum Players: \(maxPlayers)")
                    }
                }
                
                // MARK: - Skill Level Section
                Section(header: Text("Minimum Skill Level")) {
                    Picker("Select Skill Level", selection: $skillLevel) {
                        ForEach(SkillLevel.allCases, id: \.self) { level in
                            Text(level.localizedDescription())
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // MARK: - Map Section
                Section(header: Text("Pick Location")) {
                    // Wrap the center in an Identifiable struct
//                    let annotation = CoordinateItem(coordinate: region.center)
//                    
//                    Map(
//                        coordinateRegion: $region,
//                        annotationItems: [annotation]       // an array of 1 item
//                    ) { item in
//                        MapMarker(coordinate: item.coordinate)
//                    }
//                    .frame(height: 300)

                    // Show coordinates for feedback
                    Text("Latitude: \(region.center.latitude), Longitude: \(region.center.longitude)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                // MARK: - Action Buttons
                Section {
                    Button(action: createMatch) {
                        Text("Create Match")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
            }
            .navigationTitle("Add Match")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    // MARK: - Create Match
    private func createMatch() {
        // Input Validation
        guard !location.isEmpty else {
            showAlert(with: "Location is required.")
            return
        }
        
        // Coordinates come from the map
        let latitudeValue = region.center.latitude
        let longitudeValue = region.center.longitude
        
        // Create a new match object
        let newMatch = Match(
            id: UUID().uuidString,
            matchDate: matchDate,
            location: location,
            latitude: latitudeValue,
            longitude: longitudeValue,
            maxPlayers: maxPlayers,
            skillLevel: skillLevel,
            organizerID: organizerID,
            participants: []
        )
        
        // Call ViewModel to create match
        matchViewModel.createMatch(newMatch)
        
        // Dismiss the view
        dismiss()
    }
    
    // MARK: - Show Alert Helper
    private func showAlert(with message: String) {
        alertMessage = message
        showAlert = true
    }
    
    struct CoordinateItem: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }
}

#Preview {
    AddMatchView()
}
