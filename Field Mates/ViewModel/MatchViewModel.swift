//
//  MatchViewModel.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 06.02.2025.
//

import Foundation
import Combine

/// A view model responsible for managing match-related data and interactions with CloudKit.
class MatchViewModel: ObservableObject {
    
    // MARK: - Published Properties
    /// The list of matches fetched from CloudKit.
    @Published var matches: [Match] = []
    
    /// The selected match for details or operations.
    @Published var selectedMatch: Match? = nil
    
    /// Tracks the loading state.
    @Published var isLoading: Bool = false
    
    /// Tracks error messages for the UI.
    @Published var errorMessage: String? = nil
    
    // MARK: - Private Properties
    private let matchService = MatchService()
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Fetch All Matches
    /// Fetches all matches from CloudKit.
    func fetchAllMatches() {
        isLoading = true
        errorMessage = nil
        
        matchService.fetchAllMatches { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let matches):
                    self.matches = matches
                case .failure(let error):
                    self.errorMessage = "Failed to fetch matches: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // MARK: - Fetch Match by ID
    /// Fetches a specific match by ID.
    /// - Parameter matchID: The UUID of the match to fetch.
    func fetchMatch(by matchID: String) {
        isLoading = true
        errorMessage = nil
        
        matchService.fetchMatch(by: matchID) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let match):
                    self.selectedMatch = match
                case .failure(let error):
                    self.errorMessage = "Failed to fetch match: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // MARK: - Create Match
    /// Creates a new match.
    /// - Parameter match: The `Match` object to create.
    func createMatch(_ match: Match) {
        isLoading = true
        errorMessage = nil
        
        matchService.createMatch(match) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let createdMatch):
                    self.matches.append(createdMatch)
                case .failure(let error):
                    self.errorMessage = "Failed to create match: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // MARK: - Update Match
    /// Updates an existing match.
    /// - Parameter match: The `Match` object to update.
    func updateMatch(_ match: Match) {
        isLoading = true
        errorMessage = nil
        
        matchService.updateMatch(match) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success:
                    if let index = self.matches.firstIndex(where: { $0.id == match.id }) {
                        self.matches[index] = match
                    }
                case .failure(let error):
                    self.errorMessage = "Failed to update match: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // MARK: - Delete Match
    /// Deletes a match.
    /// - Parameter match: The `Match` object to delete.
    func deleteMatch(_ match: Match) {
        isLoading = true
        errorMessage = nil
        
        matchService.deleteMatch(match) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success:
                    self.matches.removeAll { $0.id == match.id }
                case .failure(let error):
                    self.errorMessage = "Failed to delete match: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // MARK: - Add Participant
    /// Adds a participant to a match.
    /// - Parameters:
    ///   - match: The `Match` object to update.
    ///   - userID: The ID of the user to add.
    func addParticipant(to match: Match, userID: String) {
        isLoading = true
        errorMessage = nil
        
        matchService.addParticipant(to: match, userID: userID) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success:
                    if let index = self.matches.firstIndex(where: { $0.id == match.id }) {
                        var updatedMatch = self.matches[index]
                        updatedMatch.addParticipant(userID)
                        self.matches[index] = updatedMatch
                    }
                case .failure(let error):
                    self.errorMessage = "Failed to add participant: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // MARK: - Remove Participant
    /// Removes a participant from a match.
    /// - Parameters:
    ///   - match: The `Match` object to update.
    ///   - userID: The ID of the user to remove.
    func removeParticipant(from match: Match, userID: String) {
        isLoading = true
        errorMessage = nil
        
        matchService.removeParticipant(from: match, userID: userID) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success:
                    if let index = self.matches.firstIndex(where: { $0.id == match.id }) {
                        var updatedMatch = self.matches[index]
                        updatedMatch.removeParticipant(userID)
                        self.matches[index] = updatedMatch
                    }
                case .failure(let error):
                    self.errorMessage = "Failed to remove participant: \(error.localizedDescription)"
                }
            }
        }
    }
}
