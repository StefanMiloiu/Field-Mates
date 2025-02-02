//
//  CustomProfileCardView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 31.01.2025.
//

import SwiftUI
import PhotosUI

struct CustomProfileCardView: View {
    
    let profilePictureURL: URL?
    @Binding var connectedUser: User?
    let email: String
    let lastName: String
    let firstName: String
    private let cloudKitManager = GenericCloudKitManager()
    
    // MARK: - State pentru Photo Picker
    @State private var isShowingPhotoPicker = false
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil  // imaginea încărcată local
    
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
            
            // Dacă deja am selectat o imagine prin PhotosPicker, o afișăm
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .onTapGesture {
                        isShowingPhotoPicker = true
                    }
                    .padding(8)
                
            // Dacă NU am selectat încă local, dar avem un URL -> AsyncImage
            } else if let url = profilePictureURL {
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
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .onTapGesture {
                    isShowingPhotoPicker = true
                }
                .padding(8)
                
            // Niciun URL, niciun selectedImage -> placeholder
            } else {
                placeholderImage
                    .onTapGesture {
                        isShowingPhotoPicker = true
                    }
                    .padding(8)
            }
        }
        .frame(height: 150)
        .padding()
        
        // 5) PhotosPicker. Când isShowingPhotoPicker == true, apare interfața
        .photosPicker(
            isPresented: $isShowingPhotoPicker,
            selection: $selectedPhotoItem,
            matching: .images
        )
        // 6) Când se schimbă `selectedPhotoItem`, încărcăm datele și convertim la UIImage
        .onChange(of: selectedPhotoItem) {
            Task {
                // Încearcă să încarci datele din item
                if let selectedPhotoItem,
                   let data = try? await selectedPhotoItem.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    
                    // Aici ai `uiImage`. Poți să-l salvezi local, trimite la CloudKit etc.
                    guard var connectedUser = connectedUser else { return }
                    selectedImage = uiImage
                    connectedUser.setProfilePicture(data)
                    cloudKitManager.update(connectedUser) { result in
                        switch result {
                        case .success(_):
                            print("Succed")
                        case .failure(_):
                            print("Insucces")
                        }
                    }
                }
            }
        }
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
        connectedUser: .constant(nil),
        email: "miloius@yahoo.com",
        lastName: "Miloiu",
        firstName: "Stefan"
    )
}
