//
//  SiteMap.swift
//  Wonders
//
//  Created by Berke Parıldar on 2.02.2024.
//

import SwiftUI
import MapKit

struct SiteMap: View {
    let site: CountrySite
    @State var position: MapCameraPosition
    var body: some View {
        Map(position: $position) {
            Annotation(site.name, coordinate: site.location, content: {
                Image(systemName: "mappin")
                    .font(.largeTitle)
                    .foregroundStyle(.red)
            })
        }
        .toolbarBackground(.automatic)
    }
}

#Preview {
    SiteMap(site: CountrySite(id: 1, name: "Country Site", image: "asd", type: .castle, latitude: 35.0394, longitude: 135.7292, openHours: CountrySite.OpenHours(start: "a", end: "b"), description: "Description"), position: .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 35.0394, longitude: 135.7292), distance: 30000)))
        .preferredColorScheme(.dark)
}
