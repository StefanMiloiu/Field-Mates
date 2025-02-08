//
//  CreateAccountView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 01.02.2025.
//

import SwiftUI
import CloudKit
import _PhotosUI_SwiftUI

struct CreateAccountView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject var userViewModel: UserViewModel
    // MARK: - State for the User Input Fields
    @State private var userRecordID: CKRecord.ID? = nil
    @State private var username: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    
    @State private var phoneNumber: String = ""
    @State private var bio: String = ""
    @State private var dateOfBirth: Date = Date() // You might want to use a default or optional value
    @State private var city: String = ""
    @State private var country: String = ""
    @State private var skillLevel: SkillLevel? = nil
    @State private var preferedPosition: Position? = nil
    @State private var profilePicture: Data? = nil
    
    @State private var isUsernameTaken: Bool = false
    @State private var isAlreadyRegistered: Bool = false
    @State var isActivated: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    // If you plan on adding a profile picture picker, you'll need extra state for that
    @State private var usernameError: String? = nil
    @State private var firstNameError: String? = nil
    @State private var lastNameError: String? = nil
    private let cloudKitManager = GenericCloudKitManager()
    @StateObject private var searchSuggestions = SearchViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                profilePictureView
                    .listRowBackground(Color.clear)
                // MARK: - Required Information Section
                Section(header: Text("Required Information *")
                    .font(.headline)
                    .foregroundColor(.primary)
                ) {
                    TextField("Username", text: $username)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    if let usernameError = usernameError {
                        Text(usernameError)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    TextField("First Name", text: $firstName)
                        .autocorrectionDisabled()
                    if let firstNameError = firstNameError {
                        Text(firstNameError)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    TextField("Last Name", text: $lastName)
                        .autocorrectionDisabled()
                    if let lastNameError = lastNameError {
                        Text(lastNameError)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                // MARK: - Optional Information Section
                Section(header: Text("Optional Information")
                    .font(.headline)
                    .foregroundColor(.secondary)) {
                        
                        TextField("Phone Number", text: $phoneNumber)
                            .keyboardType(.phonePad)
                        
                        TextField("Bio", text: $bio)
                            .autocorrectionDisabled()
                        
                        DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                        
                        TextField("City", text: $city)
                            .onChange(of: city) {
                                searchSuggestions.searchCities(query: city)
                            }
                        
                        if !searchSuggestions.citySuggestions.isEmpty {
                            List(searchSuggestions.citySuggestions, id: \.self) { suggestion in
                                Text(suggestion)
                                    .onTapGesture {
                                        city = suggestion
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            searchSuggestions.citySuggestions.removeAll() // Hide suggestionscitySuggestions
                                        }
                                    }
                            }
                            .frame(height: 25)
                            .listRowBackground(
                                Color.appLightGray.clipShape(RoundedRectangle(cornerRadius: 10))
                            )
                        }
                        
                        TextField("Country", text: $country)
                            .onChange(of: country) {
                                searchSuggestions.searchCountries(query: country)
                            }
                        
                        if !searchSuggestions.countrySuggestions.isEmpty {
                            List(searchSuggestions.countrySuggestions, id: \.self) { suggestion in
                                Text(suggestion)
                                    .onTapGesture {
                                        country = suggestion
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            searchSuggestions.countrySuggestions.removeAll() // Hide suggestions
                                        }
                                    }
                            }
                            .frame(height: 25)
                            .listRowBackground(
                                Color.appLightGray.clipShape(RoundedRectangle(cornerRadius: 10))
                            )
                        }
                        
                        // Optionally, you could add a button to select a profile picture:
                        // Button("Select Profile Picture") { ... }
                    }
                    .listRowBackground(Color.clear)
                
                // MARK: - Create Account Button
                SlideToUnlockView(isUnlocked: $isActivated)
                    .listRowBackground(
                        Color.clear
                    )
                    .padding(.horizontal)
                    .listRowSeparator(.hidden)
            }
            .navigationTitle(isAlreadyRegistered ? "Modify Account" : "Create Account")
        }
        .onAppear {
            userViewModel.fetchUserByID()
            guard let user = userViewModel.user else {
                self.isAlreadyRegistered = false
                return
            }
            // Now user is definitely available, so update local state
            self.isAlreadyRegistered = true
            self.userRecordID = user.recordID
            self.username = user.username
            self.firstName = user.firstName
            self.lastName = user.lastName
            self.phoneNumber = user.phoneNumber ?? ""
            self.bio = user.bio ?? ""
            self.dateOfBirth = user.dateOfBirth ?? Date()
            self.city = user.city ?? ""
            self.country = user.country ?? ""
            self.skillLevel = user.skillLevel
            self.preferedPosition = user.preferredPosition
            self.profilePicture = user.profilePicture
        }
        .onChange(of: userViewModel.user) {
            guard let user = userViewModel.user else {
                self.isAlreadyRegistered = false
                return
            }
            // Now user is definitely available, so update local state
            self.isAlreadyRegistered = true
            self.userRecordID = user.recordID
            self.username = user.username
            self.firstName = user.firstName
            self.lastName = user.lastName
            self.phoneNumber = user.phoneNumber ?? ""
            self.bio = user.bio ?? ""
            self.dateOfBirth = user.dateOfBirth ?? Date()
            self.city = user.city ?? ""
            self.country = user.country ?? ""
            self.skillLevel = user.skillLevel
            self.preferedPosition = user.preferredPosition
            self.profilePicture = user.profilePicture
        }
        .onChange(of: isActivated) {
            guard validateFields() else {
                isActivated = false
                return
            }
            // Check if the username is taken and validate required fields
            let predicate = NSPredicate(format: "username == %@ AND uuid != %@", username, UserDefaults.standard.appleUserID ?? "1")
            cloudKitManager.fetchAll(ofType: User.self, predicate: predicate) { result in
                switch result {
                case .success(let users):
                    if users.isEmpty {
                        isUsernameTaken = false
                        print("Username is available.")
                    } else {
                        isUsernameTaken = true
                        print("Username is already taken.")
                    }
                case .failure(let error):
                    print("Error fetching users: \(error.localizedDescription)")
                }
            }
            
            guard validateFields() else {
                guard validateFields() else {
                    return
                }
                return
            }
            
            guard !isUsernameTaken,
                  !firstName.isEmpty,
                  !lastName.isEmpty,
                  !username.isEmpty else { return }
            
            // Construct the user object for update or creation.
            // Notice we pass the userRecordID if available.
            let createdUser = User(
                id: UserDefaults.standard.appleUserID!, // or you might want to create a UUID based on some logic
                recordID: isAlreadyRegistered ? userRecordID : nil,
                email: UserDefaults.standard.email ?? "Could not retrieve email",
                phoneNumber: phoneNumber,
                username: username,
                firstName: firstName,
                lastName: lastName,
                bio: bio,
                profilePicture: profilePicture, // set if you have one
                dateOfBirth: dateOfBirth,
                skillLevel: skillLevel,
                preferredPosition: preferedPosition,
                signupDate: nil,
                city: city,
                country: country
            )
            
            if isAlreadyRegistered {
                userViewModel.updateUser(createdUser)
                userViewModel.user = createdUser
            } else {
                cloudKitManager.create(createdUser) { result in
                    switch result {
                    case .success(let user):
                        userViewModel.user = user
                        print("Created user: \(user)")
                    case .failure(let error):
                        print("Creation error: \(error)")
                    }
                }
            }
            coordinator.didFinishOnboarding()
            coordinator.mainCoordinator.profileCoordinator.goToProfile()
        }
        // Use a stack style for iPhone to avoid side-by-side split view in landscape on iPad, for example.
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var profilePictureView: some View {
        HStack {
            Spacer()
            if let data = userViewModel.user?.profilePicture {
                // Compute the URL outside the ViewBuilder
                let url: URL? = {
                    do {
                        return try Data.fileURL(for: data)
                    } catch {
                        print("Error generating URL for profile picture: \(error)")
                        return nil
                    }
                }()
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    case .failure(_):
                        placeholderImage
                    @unknown default:
                        placeholderImage
                    }
                }
            } else {
                placeholderImage
            }
            Spacer()
        }
        .frame(height: 100)
        .padding(.vertical)
    }
    
    func validateFields() -> Bool {
        var isValid = true
        
        // Validate username
        if username.isEmpty {
            usernameError = "Username is required."
            isValid = false
        } else {
            usernameError = nil
        }
        
        // Validate first name
        if firstName.isEmpty {
            firstNameError = "First name is required."
            isValid = false
        } else {
            firstNameError = nil
        }
        
        // Validate last name
        if lastName.isEmpty {
            lastNameError = "Last name is required."
            isValid = false
        } else {
            lastNameError = nil
        }
        
        return isValid
    }
    
    // MARK: - Placeholder Image
    /// A fallback image displayed when no profile picture is available
    private var placeholderImage: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 85, height: 85)
            .clipShape(Circle())
    }
}

#Preview {
    CreateAccountView()
        .environmentObject(AppCoordinator())
        .environmentObject(UserViewModel())
}
