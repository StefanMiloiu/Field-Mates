//
//  AccountExistsView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 02.02.2025.
//


import SwiftUI

struct AccountExistsView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    var email: String
    
    var body: some View {
        ZStack {
            // Dimmed background overlay with a slight blur effect
            LinearGradient(
                colors: [Color.appDarkGreen.opacity(1), Color.gray.opacity(0.1)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .transition(.opacity)
            
            // Main alert card
            VStack(spacing: 24) {
                // Icon with gradient fill
                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.primary, Color.secondary]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .padding(.top, 20)
                
                // Title text
                Text("Account Already Exists")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                // Informative message with email
                Text("""
                    An account is already registered with\n\(email)
                    \n 
                    """)
                .font(.body)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                
                Spacer()
                
                // Buttons for login and cancel actions
                HStack(spacing: 16) {
                    // Cancel button with a light background
                    Button(action: {
                        coordinator.onboardingCoordinator.goToCreateAccount()
                    }) {
                        Text("Modify")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundStyle(.black)
                    }
                    
                    // Login button with a horizontal gradient background
                    Button(action: {
                        coordinator.didFinishOnboarding()
                        coordinator.mainCoordinator.goToHome()
                    }) {
                        Text("Continue")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.appDarkGreen.opacity(0.50),
                                                                Color.appDarkGreen.opacity(0.50),
                                                                Color.appDarkGreen.opacity(0.50),
                                                                Color.appDarkGreen.opacity(0.50)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(10)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
            .frame(width: 320, height: 400)
            .background(
                // Card background with ultra-thin material effect and a shadow
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
            )
            .padding()
            .transition(.scale)
            .animation(.spring(), value: UUID())
        }
    }
}

struct AccountExistsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountExistsView(
            email: "user@example.com"
        )
        .environmentObject(AppCoordinator())
        .preferredColorScheme(.light)
    }
}
