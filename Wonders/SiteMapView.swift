//
//  SiteMap.swift
//  Wonders
//
//  Created by Berke Parıldar on 2.02.2024.
//

import SwiftUI
import MapKit

struct SiteMapView: View {
    let site: SiteModel
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
