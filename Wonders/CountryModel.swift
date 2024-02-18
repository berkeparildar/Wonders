//
//  Country.swift
//  Wonders
//
//  Created by Berke Parıldar on 17.02.2024.
//

import Foundation

struct CountryModel: Decodable, Identifiable {
    let id: Int
    let name: String
    let image: URL
    let sites: URL
}
