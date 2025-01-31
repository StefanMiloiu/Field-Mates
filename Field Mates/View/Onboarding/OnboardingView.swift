//
//  FirstPage.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 31.01.2025.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 3
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        VStack {
            HStack {
                if currentPage > 0 {
                    Button("Back") {
                        currentPage -= 1
                    }
                    .buttonStyle(.bordered)
                    .foregroundStyle(.black)
                    .tint(.secondary)
                }

                Spacer()

                if currentPage < pages.count - 1 {
                    Button("Next") {
                            currentPage += 1
                    }
                    .buttonStyle(.borderedProminent)
                    .foregroundStyle(.black)
                    .tint(.secondary)
                } 
            }
            .padding(.horizontal, 25)
            
            TabView(selection: $currentPage) {
                ForEach(pages, id: \.pageNr) { page in
                    VStack(spacing: 20) {
                        
                        Text(page.title)
                            .font(.title.bold())
                            .multilineTextAlignment(.center)
                        
                        Image(page.image ?? "questionmark.app.dashed") // Use SF Symbol if needed
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding()

                        Text(page.content)
                            .font(.body)
                            .multilineTextAlignment(.center) // Center-align the text
                            .frame(maxWidth: .infinity) // Make it take the full width available
                            .padding(.horizontal, 20) // Add horizontal padding for better readability

                        if page.pageNr == pages.count {
                            SignInWithAppleView()
                            .buttonStyle(.borderedProminent)
                            .foregroundStyle(.primary)
                            .tint(
                                .secondary
                            )
                            .padding(.bottom, 15)
                        }
                    }
                    .tag(page.pageNr - 1)
                }
            }
            .onAppear {
                UIPageControl.appearance().currentPageIndicatorTintColor = .green.withAlphaComponent(0.4)
                UIPageControl.appearance().pageIndicatorTintColor = .gray
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .animation(.easeInOut, value: currentPage)
        }
        .background(
            LinearGradient(
                colors: [Color.green.opacity(1), Color.gray.opacity(0.1)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }   
}

#Preview {
    OnboardingView()
}
