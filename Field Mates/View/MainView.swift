//
//  MainView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 31.01.2025.
//
//
//  MainView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 31.01.2025.
//
import SwiftUI

/// The main view of the app, providing tab-based navigation.
struct MainView: View {
    
    /// Manages navigation within the profile section.
    @EnvironmentObject var coordinator: AppCoordinator
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    /// Handles user-related data and CloudKit interactions.
    @EnvironmentObject var userViewModel: UserViewModel
    
    // Computed property for the profile picture URL
    @State private var profilePicURL: URL?
    
    // State to control the visibility of the popup
    @State private var isPopupVisible: Bool = false
    
    @State var selectedNumber: Int = 4 // Default selection
    @State var selectedPickerValue: String = "Beginner"
    
    @State var date: Date = Date()
    @State var time: Date = Date()
    @State var fullDate: Date = Date()
    @State var isButtonActivated: Bool = false
    @State var isUnlocked: Bool = false
    
    var body: some View {
        ZStack(alignment: .center) {
            // Background
            Color.grayBackground.edgesIgnoringSafeArea(.all)
            
            // Popup view
            if isPopupVisible {
                VStack {
                    ArrowPopupView(isVisible: $isPopupVisible, selectedNumber: $selectedNumber, selectedPickerValue: $selectedPickerValue,
                                   date: $date, time: $time, fullDate: $fullDate,
                                   isButtonActivated: $isButtonActivated,
                                   isUnlocked: $isUnlocked)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(), value: isPopupVisible)
                    .offset(y: UIScreen.main.bounds.height > 700 ? -UIScreen.main.bounds.height / 11 : 0)
                }
            }
            // Overlays (profile and grid buttons) are separated from the popup
            VStack {
                Spacer()
            }
        }
        .onAppear {
            updateProfilePicURL()
        }
        .onChange(of: userViewModel.user) {
            updateProfilePicURL()
        }
        .onChange(of: isUnlocked) {
            if isUnlocked {
                coordinator.mainCoordinator.goToAddMatchSheet()
                isUnlocked = false
            }
        }
        .overlay(alignment: .topTrailing, content: {
            Button(action: {
                coordinator.mainCoordinator.goToProfile()
            }, label: {
                ProfileImageView(profilePictureURL: profilePicURL)
            })
            .padding(.trailing, 5)
        })
        .overlay(alignment: .topLeading, content : {
            Button(action: {
                // Toggle popup visibility
                withAnimation {
                    isPopupVisible.toggle()
                }
            }, label: {
                Image(systemName: "circle.grid.3x3.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.appDarkGreen.opacity(1))
                    .frame(width: 40, height: 40)
            })
            .frame(width: 60, height: 60)
            .padding(8)
            .padding(.leading, 5)
        })
        .overlay(alignment: .top, content : {
            if isPopupVisible {
                Text("Host Match")
                    .font(.title)
                    .fontWeight(.heavy)
                    .padding(.top, 20)
                    .foregroundStyle(.appDarkGreen)
            } else {
                Text("Field Mates")
                    .font(.title)
                    .fontWeight(.heavy)
                    .padding(.top, 20)
                    .foregroundStyle(.appDarkGray)
            }
        })
    }
    
    private func updateProfilePicURL() {
        guard let profilePicture = userViewModel.user?.profilePicture else {
            profilePicURL = nil
            return
        }
        do {
            profilePicURL = try Data.fileURL(for: profilePicture)
        } catch {
            print("Error generating file URL for profile picture: \(error)")
        }
    }
}

// Popup View with Arrow
struct ArrowPopupView: View {
    @Binding var isVisible: Bool
    @Binding var selectedNumber: Int
    @Binding var selectedPickerValue: String
    
    @Binding var date: Date
    @Binding var time: Date
    @Binding var fullDate: Date
    @Binding var isButtonActivated: Bool
    @Binding var isUnlocked: Bool
    var body: some View {
        VStack(spacing: 5) {
            HorizontalNumberPicker(selectedNumber: $selectedNumber)
                .padding(.top)
            
            SkillLevelPickerView(selectedPickerValue: $selectedPickerValue)
            
            DateAndTimePicker(date: $date, time: $time, fullDate: $fullDate)
            Spacer()
            SlideToUnlockView(isUnlocked: $isUnlocked, isForMatch: true)
        }
        .frame(maxHeight: UIScreen.main.bounds.height > 700 ? UIScreen.main.bounds.height / 2 : UIScreen.main.bounds.height / 1.5)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.appDarkGray.opacity(0.1))
                .shadow(color: .appDarkGreen, radius: 5)
                .padding(.horizontal, 5)
        )
        .overlay(
            ArrowShape()
                .fill(Color.appDarkGreen.opacity(1))
                .frame(width: 40, height: 40)
                .rotationEffect(.degrees(0))
                .offset(x: 8, y: -40),
            alignment: .topLeading
        )
        .padding(.horizontal, 15)
    }
}

// Custom Shape for the Arrow
struct ArrowShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY)) // Top center
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY)) // Bottom right
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY)) // Bottom left
            path.closeSubpath()
        }
    }
}

#Preview {
    MainView()
        .environmentObject(ProfileCoordinator())
        .environmentObject(UserViewModel())
}
