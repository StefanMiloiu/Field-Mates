//
//  CreateAccountView.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 01.02.2025.
//

import SwiftUI
import CloudKit

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
    // If you plan on adding a profile picture picker, you'll need extra state for that
    
    private let cloudKitManager = GenericCloudKitManager()
    
    var body: some View {
        NavigationView {
            Form {
                // MARK: - Required Information Section
                Section(header: Text("Required Information *")
                    .font(.headline)
                    .foregroundColor(.primary)) {
                        TextField("Username", text: $username)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                        
                        TextField("First Name", text: $firstName)
                            .autocorrectionDisabled()
                        
                        TextField("Last Name", text: $lastName)
                            .autocorrectionDisabled()
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
                            .autocorrectionDisabled()
                        
                        TextField("Country", text: $country)
                            .autocorrectionDisabled()
                        
                        // Optionally, you could add a button to select a profile picture:
                        // Button("Select Profile Picture") { ... }
                    }
                
                // MARK: - Create Account Button
                SlideToUnlockView(isUnlocked: $isActivated)
                    .listRowBackground(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.green.opacity(0.25), Color.green.opacity(0.5), Color.gray.opacity(0.5), Color.gray.opacity(1.0)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    )
            }
            .navigationTitle(isAlreadyRegistered ? "Modify Account" : "Create Account")
        }
        .onAppear {
            let predicate = NSPredicate(format: "uuid == %@", UserDefaults.standard.appleUserID!)
            cloudKitManager.fetchAll(ofType: User.self, predicate: predicate) { result in
                switch result {
                case .success(let users):
                    if let user = users.first {
                        DispatchQueue.main.async {
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
                    } else {
                        DispatchQueue.main.async {
                            self.isAlreadyRegistered = false
                        }
                    }
                case .failure(let error):
                    print("Error fetching user: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.isAlreadyRegistered = false
                    }
                }
            }
        }
        .onChange(of: isActivated) {
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
                cloudKitManager.update(createdUser) { result in
                    switch result {
                    case .success(let user):
                        userViewModel.user = user
                        print("Updated user: \(user)")
                    case .failure(let error):
                        print("Update error: \(error)")
                    }
                }
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
        }
        // Use a stack style for iPhone to avoid side-by-side split view in landscape on iPad, for example.
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    CreateAccountView()
        .environmentObject(AppCoordinator())
}
