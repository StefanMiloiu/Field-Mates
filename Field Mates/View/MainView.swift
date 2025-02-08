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
    
    /// Handles user-related data and CloudKit interactions.
    @EnvironmentObject var userViewModel: UserViewModel

    // Computed property for the profile picture URL
    @State private var profilePicURL: URL?
    
    // State to control the visibility of the popup
    @State private var isPopupVisible: Bool = false
    
    var body: some View {
        ZStack {
            Color.grayBackground.edgesIgnoringSafeArea(.all).opacity(0.8)
            
            // Popup view
            if isPopupVisible {
                VStack {
                    ArrowPopupView(isVisible: $isPopupVisible)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.spring(), value: isPopupVisible)
                        .offset(x: -20)
                    Spacer()
                }
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
        .onAppear {
            updateProfilePicURL()
        }
        .onChange(of: userViewModel.user) {
            updateProfilePicURL()
        }
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
    
    var body: some View {
        HStack(spacing: 0) {
            // Arrow
            ArrowShape()
                .fill(Color.appDarkGreen.opacity(1))
                .frame(width: 40, height: 40)
                .rotationEffect(.degrees(-90))
                .offset(y: -10)
            
            // Popup content
            VStack(spacing: 20) {
                Text("Create a Match")
                    .font(.headline)
                
                Button("Close") {
                    withAnimation {
                        isVisible = false
                    }
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.appDarkGray.opacity(0.1))
                    .shadow(color: .appDarkGreen, radius: 5)
            )
        }
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
