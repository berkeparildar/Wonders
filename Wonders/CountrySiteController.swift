//
//  CountrySiteController.swift
//  Wonders
//
//  Created by Berke Parıldar on 1.02.2024.
//

import Foundation
import SwiftUI

class CountrySiteController: ObservableObject {
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
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else if let error = error {
                print("Network request error: \(error.localizedDescription)")
            }
        }.resume()
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
}
