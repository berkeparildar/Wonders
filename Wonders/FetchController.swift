//
//  FetchController.swift
//  Wonders
//
//  Created by Berke Parıldar on 17.02.2024.
//

import Foundation


struct FetchController {
    
    
    enum NetworkError: Error {
        case badURL, badResponse
    }
    
    private let baseURL = URL(string: "http://localhost:5274/api")!
    
    func fetchCountries() async throws -> [CountryModel] {
        let countriesURL = baseURL.appending(path: "countries")
        let countryURLComponents = URLComponents(url: countriesURL, resolvingAgainstBaseURL: true)
        guard let fetchURL = countryURLComponents?.url else {
            throw NetworkError.badURL
        }
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        let countries = try JSONDecoder().decode([CountryModel].self, from: data)
        return countries
    }
    
    func fetchSites(countryName: String) async throws -> [SiteModel] {
        let sitesURL = baseURL.appending(path: "sites/\(countryName)")
        let siteURLComponents = URLComponents(url: sitesURL, resolvingAgainstBaseURL: true)
        print(sitesURL)
        guard let fetchURL = siteURLComponents?.url else {
            throw NetworkError.badURL
        }
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let sites = try decoder.decode([SiteModel].self, from: data)
        return sites
    }
}


