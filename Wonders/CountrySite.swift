//
//  CountrySite.swift
//  Wonders
//
//  Created by Berke Parıldar on 1.02.2024.
//

import Foundation
import SwiftUI
import MapKit

struct CountrySite: Decodable, Identifiable {
    let id: Int
    let name: String
    let image: String
    let type : SiteType
    let latitude: Double
    let longitude: Double
    let openHours: OpenHours
    let description: String
    
    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    struct OpenHours: Decodable {
        let start: String
        let end: String
    }
}

enum SiteType: String, Decodable, CaseIterable, Identifiable {
    case historicSite
    case religiousSite
    case castle
    case walkingArea
    case museum
    case all
    
    var id: SiteType {
        self
    }
    
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
        case .all:
            "All"
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
                .cyan
        case .all:
                .black
        }
    }
    
    var icon: String {
        switch self {
        case .historicSite:
            "fossil.shell.fill"
        case .religiousSite:
            "swirl.circle.righthalf.filled"
        case .castle:
            "house.lodge.fill"
        case .walkingArea:
            "figure.walk"
        case .museum:
            "photo.artframe"
        case .all:
            "square.stack.3d.up.fill"
        }
    }
}
