//
//  SiteDetail.swift
//  Wonders
//
//  Created by Berke Parıldar on 2.02.2024.
//

import SwiftUI
import MapKit

struct SiteDetail: View {
    let site: CountrySite
    @State var position: MapCameraPosition
    let siteImage: Image
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                siteImage
                    .resizable()
                    .scaledToFit()
                    .overlay {
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: .clear, location: 0.8),
                                Gradient.Stop(color: .black, location: 1)
                            ], startPoint: .top, endPoint: .bottom
                        )
                    }
                VStack (alignment: .leading) {
                    Text(site.name)
                        .font(.largeTitle)
                    Text(site.description)
                }
            }
        }
    }
}

#Preview {
    SiteDetail(site: CountrySite(id: 1, name: "Country Site", image: "asd", type: .castle, latitude: 35.0394, longitude: 135.7292, openHours: CountrySite.OpenHours(start: "a", end: "b"), description: "Description"), position: .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 35.0394, longitude: 135.7292), distance: 30000)), siteImage: Image(systemName: "globe"))
        .preferredColorScheme(.dark)
}
