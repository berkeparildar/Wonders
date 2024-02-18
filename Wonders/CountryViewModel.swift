//
//  ViewModel.swift
//  Wonders
//
//  Created by Berke Parıldar on 17.02.2024.
//

import Foundation

@MainActor
class CountryViewModel: ObservableObject {
    
    enum CountryStatus {
        case notStarted
        case fetching
        case success
        case failed
    }

    @Published private(set) var countryStatus: CountryStatus = .notStarted
    @Published var searchText: String = ""
    @Published var countries : [CountryModel] = []
    private let controller: FetchController
    
    init(controller: FetchController) {
        self.controller = controller
    }
    
    func getCountryData() async {
        countryStatus = .fetching
        do {
            countries = try await controller.fetchCountries()
            countryStatus = .success
        } catch {
            countryStatus = .failed
        }
    }
    
    func getCountries() -> [CountryModel] {
        if searchText.isEmpty {
            return countries
        }
        else {
            return countries.filter { country in
                country.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}
