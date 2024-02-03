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
    var countrySitesMain: [CountrySite] = []
    var countrySitesMainTwo: [CountrySite] = []
    
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
                    fetchImageData()
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
    
    func resetData() {
        countrySites.removeAll()
        hasFetchedData = false
    }
    
    func fetchImageData () {
        for index in countrySites.indices {
            guard let url = URL(string: "http://localhost:5274/api/image/\(countrySites[index].image)")
            else {
                return
            }
            URLSession.shared.dataTask(with: url) { [self] data, response, error in
                if let data = data {
                    if let uiImage = UIImage(data: data) {
                        self.siteImages[index] = Image(uiImage: uiImage)
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
    
    func getCountryFlag(country: String) -> String {
        var returnString = ""
        switch country {
        case "japan":
            returnString = "🇯🇵"
        case "turkey":
            returnString = "🇹🇷"
        case "us":
            returnString = "🇺🇸"
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
