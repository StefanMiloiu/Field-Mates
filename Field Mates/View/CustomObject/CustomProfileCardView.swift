//
//  CustomProfileCardView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 31.01.2025.
//

import SwiftUI

struct CustomProfileCardView: View {
    
    let profilePictureURL: URL?
    let email: String
    let lastName: String
    let firstName: String
    
    var body: some View {
        ZStack {
            // 1) Background
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.gray.opacity(0.15))
            
            // 2) Centered text
            VStack(spacing: 8) {
                    Text(email)
                        .font(.headline)
                
                    Text("\(firstName) \(lastName)")
                        .font(.subheadline)
            }
        }
        // 3) Bottom-left overlay (the "Ball" image)
        .overlay(alignment: .bottomLeading) {
            Image("Ball")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .padding(8) // small padding from corner
        }
        // 4) Top-right overlay (profile picture or placeholder)
        .overlay(alignment: .topTrailing) {
            if let url = profilePictureURL {
                // If you’re on iOS 16+ and want a local/remote image:
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure(_):
                        placeholderImage
                    @unknown default:
                        placeholderImage
                    }
                }
                .frame(width: 65, height: 65)
                .clipShape(Circle())
                .padding(8)
                
            } else {
                // No URL -> Placeholder
                placeholderImage
                    .padding(8)
            }
        }
        .frame(height: 150)
        .padding()
    }
    
    /// A simple fallback image (could be your own placeholder asset).
    private var placeholderImage: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 65, height: 65)
            .clipShape(Circle())
    }
}

#Preview {
    CustomProfileCardView(
        profilePictureURL: nil,
        email: "miloius@yahoo.com",
        lastName: "Miloiu",
        firstName: "Stefan"
    )
}
