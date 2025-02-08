//
//  LocationSearchViewModel.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 07.02.2025.
//
import Foundation
import MapKit
import Combine

class SearchViewModel: ObservableObject {
    @Published var citySuggestions: [String] = []
    @Published var countrySuggestions: [String] = []

    private var allCountries: [String] = []

    init() {
        allCountries = Locale.current.countryNames
    }

    /// Use Apple's MapKit to search for cities
    func searchCities(query: String) {
        guard !query.isEmpty else {
            citySuggestions = []
            return
        }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .address

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                self.citySuggestions = []
                return
            }

            // Extract unique city names from results
            let cities = response.mapItems.compactMap { $0.placemark.locality }
            self.citySuggestions = Array(Set(cities)).sorted()
        }
    }

    /// Search for countries locally
    func searchCountries(query: String) {
        guard !query.isEmpty else {
            countrySuggestions = []
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            let filteredCountries = self.allCountries.filter {
                $0.lowercased().hasPrefix(query.lowercased())
            }
            DispatchQueue.main.async {
                self.countrySuggestions = filteredCountries
            }
        }
    }
}
