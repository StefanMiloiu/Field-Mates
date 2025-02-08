//
//  MatchService.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 06.02.2025.
//

import Foundation
import CloudKit

/// A service class responsible for managing match-related operations in CloudKit.
class MatchService {
    // MARK: - Properties
    private let cloudKitManager = GenericCloudKitManager()
    
    // MARK: - Create Match
    /// Creates a new match record in CloudKit.
    /// - Parameters:
    ///   - match: The `Match` object to be created.
    ///   - completion: A closure that returns the created `Match` or an error.
    func createMatch(_ match: Match, completion: @escaping (Result<Match, Error>) -> Void) {
        cloudKitManager.create(match) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let createdMatch):
                    completion(.success(createdMatch))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Fetch Match by ID
    /// Fetches a match from CloudKit based on the given UUID.
    /// - Parameters:
    ///   - matchID: The UUID of the match to fetch.
    ///   - completion: A closure that returns the `Match` or an error.
    func fetchMatch(by matchID: String, completion: @escaping (Result<Match, Error>) -> Void) {
        let predicate = NSPredicate(format: "uuid == %@", matchID)
        cloudKitManager.fetchAll(ofType: Match.self, predicate: predicate) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let matches):
                    if let match = matches.first {
                        completion(.success(match))
                    } else {
                        completion(.failure(NSError(domain: "MatchService", code: 404, userInfo: [NSLocalizedDescriptionKey: "No matching match found."])))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Update Match
    /// Updates an existing match record in CloudKit.
    /// - Parameters:
    ///   - match: The `Match` object to be updated.
    ///   - completion: A closure that indicates success or failure.
    func updateMatch(_ match: Match, completion: @escaping (Result<Void, Error>) -> Void) {
        cloudKitManager.update(match) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Delete Match
    /// Deletes a match record from CloudKit.
    /// - Parameters:
    ///   - match: The `Match` object to be deleted.
    ///   - completion: A closure that indicates success or failure.
    func deleteMatch(_ match: Match, completion: @escaping (Result<Void, Error>) -> Void) {
        cloudKitManager.delete(match) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Fetch All Matches
    /// Fetches all matches from CloudKit.
    /// - Parameter completion: A closure that returns an array of `Match` objects or an error.
    func fetchAllMatches(completion: @escaping (Result<[Match], Error>) -> Void) {
        cloudKitManager.fetchAll(ofType: Match.self, predicate: NSPredicate(value: true)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let matches):
                    completion(.success(matches))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Add Participant
    /// Adds a participant to a match.
    /// - Parameters:
    ///   - match: The `Match` object to update.
    ///   - userID: The ID of the user to add.
    ///   - completion: A closure that indicates success or failure.
    func addParticipant(to match: Match, userID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        var updatedMatch = match
        updatedMatch.addParticipant(userID)
        updateMatch(updatedMatch, completion: completion)
    }
    
    // MARK: - Remove Participant
    /// Removes a participant from a match.
    /// - Parameters:
    ///   - match: The `Match` object to update.
    ///   - userID: The ID of the user to remove.
    ///   - completion: A closure that indicates success or failure.
    func removeParticipant(from match: Match, userID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        var updatedMatch = match
        updatedMatch.removeParticipant(userID)
        updateMatch(updatedMatch, completion: completion)
    }
}
