//
//  CountrySiteController.swift
//  Wonders
//
//  Created by Berke Parıldar on 1.02.2024.
//

import Foundation
import SwiftUI
import Combine

class CountrySiteController: ObservableObject {
    var hasFetchedData: Bool = false
    var hasFetchedImages: Bool = false
    var hasFetchedCountryImages: Bool = false
    var countrySites: [CountrySite] = []
    var countrySitesModifiable: [CountrySite] = []
    
    @Published var siteImages: [Image] = [
        Image(systemName: "globe"),
        Image(systemName: "globe"),
        Image(systemName: "globe"),
        Image(systemName: "globe"),
        Image(systemName: "globe"),
        Image(systemName: "globe"),
        Image(systemName: "globe"),
        Image(systemName: "globe"),
        Image(systemName: "globe"),
        Image(systemName: "globe")
    ]
    
    @Published var countryImages: [Image] = [
        Image(systemName: "globe"),
        Image(systemName: "globe"),
        Image(systemName: "globe"),
        Image(systemName: "globe"),
        Image(systemName: "globe"),
        Image(systemName: "globe"),
    ]
    let countries: [String] = [
        "japan",
        "turkey",
        "italy",
        "france",
        "korea",
        "england"
    ]
    var modifiedCountries: [String] = [
        "japan",
        "turkey",
        "italy",
        "france",
        "korea",
        "england"
    ]
    private var cancellables: Set<AnyCancellable> = []
    
    
    func fetchCountrySites (country countryName: String) {
            guard let url = URL(string: "http://localhost:5274/api/countries/\(countryName.lowercased())")
            else {
                return
            }
            URLSession.shared.dataTask(with: url) { [self] data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        self.countrySites = try decoder.decode([CountrySite].self, from: data)
                        fetchCountrySiteImages(countryName: countryName)
                        hasFetchedData = true
                        countrySitesModifiable = countrySites
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                } else if let error = error {
                    print("Network request error: \(error.localizedDescription)")
                }
            }.resume()
        }
    
    func searchCountrySites(for searchTerm: String) -> [CountrySite] {
        if searchTerm.isEmpty {
            return countrySitesModifiable
        }
        else {
            return countrySitesModifiable.filter { site in
                site.name.localizedCaseInsensitiveContains(searchTerm)
            }
        }
    }
    
    func searchCountry(for searchTerm: String) -> [String] {
        if searchTerm.isEmpty {
            return modifiedCountries
        }
        else {
            return modifiedCountries.filter { country in
                country.localizedCaseInsensitiveContains(searchTerm)
            }
        }
    }
    
    func resetData() {
        countrySites.removeAll()
        countrySitesModifiable.removeAll()
        hasFetchedData = false
        hasFetchedImages = false
    }
    
    func fetchCountrySiteImages (countryName: String) {
        modifiedCountries = countries
        for index in countrySites.indices {
            guard let url = URL(string: "http://localhost:5274/api/image/\(countryName)-\(countrySites[index].image)")
            else {
                return
            }
            URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .receive(on: DispatchQueue.main) // Switch to the main thread for UI updates
                .sink { completion in
                    switch completion {
                    case .finished :
                        if index == self.countrySites.count - 1 {
                            self.hasFetchedImages = true
                        }
                    case .failure(_):
                        print("error:")
                    }
                } receiveValue: { [weak self] data in
                    if let uiImage = UIImage(data: data) {
                        self?.siteImages[index] = Image(uiImage: uiImage)
                        self?.hasFetchedImages = true
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    func fetchCountryImages () {
        for index in countries.indices {
            guard let url = URL(string: "http://localhost:5274/api/image/countries-\(countries[index])")
            else {
                return
            }
            URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        if index == self.countries.count - 1 {
                            self.hasFetchedCountryImages = true
                        }
                    case .failure(_):
                        print("error")
                    }
                } receiveValue: { [weak self] data in
                    if let uiImage = UIImage(data: data) {
                        self?.countryImages[index] = Image(uiImage: uiImage)
                    }
                }
                .store(in: &cancellables)
            
        }
    }
    
    func sortCountrySites(by alphabetical: Bool) {
        countrySitesModifiable.sort { site1, site2 in
            if alphabetical {
                site1.name < site2.name
            }
            else {
                site1.id < site2.id
            }
        }
    }
    
    func sortCountry (by alphabetical: Bool) {
        if alphabetical {
            modifiedCountries.sort { country1, country2 in
                country1 < country2
            }
        }
        else {
            modifiedCountries = countries
        }
    }
    
    func filterCountrySites(by type: SiteType) {
        if type == .all {
            countrySitesModifiable = countrySites
        }
        else {
            countrySitesModifiable = countrySites.filter { site in
                site.type == type
            }
        }
    }
    
    func isOpenNow(site: CountrySite) -> Bool {
        if site.openHours.start.lowercased() == "open" && site.openHours.end.lowercased() == "open" {
            return true
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let currentTimeString = dateFormatter.string(from: Date())
        let startTimeString = site.openHours.start
        let endTimeString = site.openHours.end
        if let currentTime = dateFormatter.date(from: currentTimeString),
           let startTime = dateFormatter.date(from: startTimeString),
           let endTime = dateFormatter.date(from: endTimeString) {
            return currentTime >= startTime && currentTime <= endTime
        }
        return false
    }
}
