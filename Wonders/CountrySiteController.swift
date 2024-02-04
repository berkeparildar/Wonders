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
    @Published var countrySites: [CountrySite] = []
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
    
    var countrySitesMain: [CountrySite] = []
    var countrySitesMainTwo: [CountrySite] = []
    var modifiedCountries: [String] = [
        "japan",
        "turkey",
        "italy",
        "france",
        "korea",
        "england"
    ]
    
    func fetchCountryData (country countryName: String) {
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
                    fetchImageData(countryName: countryName)
                    hasFetchedData = true
                    countrySitesMain = countrySites
                    countrySitesMainTwo = countrySites
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else if let error = error {
                print("Network request error: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func search(for searchTerm: String) -> [CountrySite] {
        if searchTerm.isEmpty {
            return countrySitesMainTwo
        }
        else {
            return countrySitesMainTwo.filter { site in
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
        hasFetchedData = false
    }
    
    func fetchImageData (countryName: String) {
        modifiedCountries = countries
        for index in countrySites.indices {
            guard let url = URL(string: "http://localhost:5274/api/image/\(countryName)-\(countrySites[index].image)")
            else {
                return
            }
            URLSession.shared.dataTask(with: url) { [self] data, response, error in
                if let data = data {
                    if let uiImage = UIImage(data: data) {
                        self.siteImages[index] = Image(uiImage: uiImage)
                        hasFetchedImages = true
                    }
                }
                else if let error = error {
                    print("Network request error: \(error.localizedDescription)")
                }
            }.resume()
        }
    }
    
    func fetchCountryImages () {
        for index in countries.indices {
            guard let url = URL(string: "http://localhost:5274/api/image/countries-\(countries[index])")
            else {
                return
            }
            URLSession.shared.dataTask(with: url) { [self] data, response, error in
                if let data = data {
                    if let uiImage = UIImage(data: data) {
                        self.countryImages[index] = Image(uiImage: uiImage)
                    }
                }
                else if let error = error {
                    print("Network request error: \(error.localizedDescription)")
                }
            }.resume()
        }
    }
    
    func sort(by alphabetical: Bool) {
        countrySitesMainTwo.sort { site1, site2 in
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
    
    func filter(by type: SiteType) {
        if type == .all {
            countrySitesMainTwo = countrySites
        }
        else {
            countrySitesMainTwo = countrySitesMain.filter { site in
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
    
    func getCountryFlag(country: String) -> String {
        var returnString = ""
        switch country {
        case "japan":
            returnString = "🇯🇵"
        case "turkey":
            returnString = "🇹🇷"
        case "england":
            returnString = "🏴󠁧󠁢󠁥󠁮󠁧󠁿"
        case "france":
            returnString = "🇫🇷"
        case "italy":
            returnString = "🇮🇹"
        case "korea":
            returnString = "🇰🇷"
        default:
            returnString = ""
        }
        return returnString
    }
}
