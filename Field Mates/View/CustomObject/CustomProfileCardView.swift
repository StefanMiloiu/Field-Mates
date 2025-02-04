//
//  CustomProfileCardView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 31.01.2025.
//

import SwiftUI
import PhotosUI

struct CustomProfileCardView: View {
    
    // MARK: - Properties
    @EnvironmentObject var userViewModel: UserViewModel
    /// URL for the user's profile picture (fetched from local storage or the cloud)
    let profilePictureURL: URL?
    
    /// User's email address
    let email: String
    
    /// User's last name
    let lastName: String
    
    /// User's first name
    let firstName: String
    
    /// Generic CloudKit manager for updating user data
    private let cloudKitManager = GenericCloudKitManager()
    
    // MARK: - State Variables
    
    /// Controls the visibility of the photo picker
    @State private var isShowingPhotoPicker = false
    
    /// The selected photo item from the photo picker
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    
    /// Controls the visibility of the action sheet
    @State private var isShowingActionSheet: Bool = false
    
    /// Stores the selected image as a `UIImage`
    @State private var selectedImage: UIImage? = nil
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // MARK: - Background
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.gray.opacity(0.15))
            
            // MARK: - Centered User Info
            VStack(spacing: 8) {
                Text(email)
                    .font(.headline)
                
                Text(userViewModel.user?.username ?? "Username")
                    .font(.headline)
                
                Text("\(firstName) \(lastName)")
                    .font(.subheadline)
            }
        }
        // MARK: - Bottom-Left Overlay (Icon)
        .overlay(alignment: .topLeading) {
            Image("Ball")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 75, height: 75)
                .padding(-12) // Slight negative padding to position closer to the corner
        }
        // MARK: - Top-Right Overlay (Profile Picture or Placeholder)
        .overlay(alignment: .topTrailing) {
            if let selectedImage = selectedImage {
                // Show the locally selected image
                Image(uiImage: selectedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .onTapGesture {
                        isShowingActionSheet = true // Show action sheet on tap
                    }
                    .actionSheet(isPresented: $isShowingActionSheet) {
                        // Action sheet for selecting or removing the image
                        ActionSheet(
                            title: Text("Profile Picture"),
                            message: Text("Choose an action"),
                            buttons: [
                                .default(Text("Select New Image")) {
                                    isShowingPhotoPicker = true // Show the photo picker
                                },
                                .destructive(Text("Remove Image")) {
                                    // Clear the selected image
                                    self.selectedImage = nil
                                    
                                    // Clear the connected user's profile picture
                                    if var connectedUser = userViewModel.user {
                                        connectedUser.profilePicture = nil
                                        // Update in CloudKit
                                        userViewModel.update(connectedUser)
                                    }
                                },
                                .cancel()
                            ]
                        )
                    }
                    .padding(8)
            } else if let url = profilePictureURL {
                // Show the profile picture from the URL
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView() // Show a loading indicator
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure(_):
                        placeholderImage // Fallback to placeholder
                    @unknown default:
                        placeholderImage
                    }
                }
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .onTapGesture {
                    isShowingActionSheet = true // Show action sheet on tap
                }
                .actionSheet(isPresented: $isShowingActionSheet) {
                    // Action sheet for selecting or removing the image
                    ActionSheet(
                        title: Text("Profile Picture"),
                        message: Text("Choose an action"),
                        buttons: [
                            .default(Text("Select New Image")) {
                                isShowingPhotoPicker = true
                            },
                            .destructive(Text("Remove Image")) {
                                selectedImage = nil
                                
                                // Clear the connected user's profile picture
                                if var connectedUser = userViewModel.user {
                                    connectedUser.profilePicture = nil
                                    
                                    // Update in CloudKit
                                    userViewModel.update(connectedUser)
                                }
                            },
                            .cancel()
                        ]
                    )
                }
                .padding(8)
            } else {
                // Show the placeholder image if no image is selected
                placeholderImage
                    .onTapGesture {
                        isShowingPhotoPicker = true
                    }
                    .padding(8)
            }
        }
        .frame(height: 150)
        .padding()
        
        // MARK: - Photo Picker
        .photosPicker(
            isPresented: $isShowingPhotoPicker,
            selection: $selectedPhotoItem,
            matching: .images
        )
        // MARK: - Handle Selected Photo
        .onChange(of: selectedPhotoItem) {
            Task {
                if let selectedPhotoItem,
                   let data = try? await selectedPhotoItem.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    
                    // Update the connected user's profile picture
                    guard var connectedUser = userViewModel.user else { return }
                    selectedImage = uiImage
                    connectedUser.setProfilePicture(data)
                    userViewModel.user?.setProfilePicture(data)
                    userViewModel.update(connectedUser)
                }
            }
        }
    }
    
    // MARK: - Placeholder Image
    /// A fallback image displayed when no profile picture is available
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
