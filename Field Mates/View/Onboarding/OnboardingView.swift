//
//  FirstPage.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 31.01.2025.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        VStack(spacing: 20) {
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
                    VStack(alignment: .center, spacing: 20) {
                        if page.pageNr == 1 {
                            Text("Field Mates")
                                .padding(.top)
                                .font(.largeTitle.bold())
                                .shadow(color: .white, radius: 15)
                        }
                        
                        HStack {
                            Text(page.title)
                                .font(.title.bold())
                                .multilineTextAlignment(.center)
                            
                            Image(page.image ?? "questionmark.app.dashed")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding()
                        }
                        
                        ForEach(Array(page.content.split(separator: "\n").enumerated()), id: \.element) { index, content in
                            let backgroundColor: Color = {
                                    if index == 0 {
                                        return Color.white.opacity(0.1)
                                    } else if index == 1 {
                                        return Color.appDarkGreen.opacity(0.25)
                                    } else {
                                        return Color.appDarkGreen.opacity(0.5)
                                    }
                                }()
                            Text("\(content)") // Example: Add index before content
                                .font(.body)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .padding(10)
                                .background(backgroundColor)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                        }
                        
                        if page.pageNr == pages.count {
                            Spacer()
                            SignInWithAppleView()
                                .environmentObject(coordinator)
                                .buttonStyle(.borderedProminent)
                                .foregroundStyle(.primary)
                                .tint(.secondary)
                                .padding(.bottom, 15)
                        }
                        
                        Spacer() // Pushes the content up
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .tag(page.pageNr - 1)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .animation(.easeInOut, value: currentPage)
            .onAppear {
                UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.appDarkGreen.withAlphaComponent(0.4)
                UIPageControl.appearance().pageIndicatorTintColor = .gray
            }
        }
        .background(
            LinearGradient(
                colors: [Color.appDarkGreen.opacity(1), Color.gray.opacity(0.1)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppCoordinator())
}
