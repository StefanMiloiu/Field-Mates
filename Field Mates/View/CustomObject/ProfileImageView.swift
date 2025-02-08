//
//  ProfileImageView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 08.02.2025.
//


import SwiftUI

struct ProfileImageView: View {
    /// URL for the user's profile picture (optional)
    let profilePictureURL: URL?
    
    var body: some View {
        ZStack {
            if let url = profilePictureURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        placeholderImage
                    @unknown default:
                        placeholderImage
                    }
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            } else {
                placeholderImage
            }
        }
        .frame(width: 60, height: 60) // Ensures consistent size
        .padding(8)
    }
    
    // MARK: - Placeholder Image
    private var placeholderImage: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .foregroundColor(.gray.opacity(0.6))
    }
}

#Preview {
    ProfileImageView(profilePictureURL: nil)
}
