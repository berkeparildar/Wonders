//
//  CountrySite.swift
//  Wonders
//
//  Created by Berke Parıldar on 1.02.2024.
//

import Foundation
import SwiftUI

struct CountrySite: Decodable, Identifiable {
    let id: Int
    let name: String
    let image: String
    let type : SiteType
    let latitude: Double
    let longitude: Double
    let openHours: OpenHours
    let description: String
    
    struct OpenHours: Decodable {
        let start: String
        let end: String
    }
    
    enum SiteType: String, Decodable {
        case historicSite
        case religiousSite
        case castle
        case walkingArea
        case museum
        
        var name: String {
            switch self {
            case .historicSite:
                "Historic Site"
            case .religiousSite:
                "Religious Site"
            case .castle:
                "Castle"
            case .walkingArea:
                "Walking Area"
            case .museum:
                "Museum"
            }
        }
        
        var backgroundColor : Color {
            switch self {
                
            case .historicSite:
                    .blue
            case .religiousSite:
                    .red
            case .castle:
                    .brown
            case .walkingArea:
                    .green
            case .museum:
                    .white
            }
        }
    }
}

