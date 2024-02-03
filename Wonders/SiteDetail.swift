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
                    NavigationLink{
                        SiteMap(site: site, position: .camera(MapCamera(centerCoordinate: site.location, distance: 1000, heading: 250, pitch: 80)))
                    } label: {
                        Map(position: $position) {
                            Annotation(site.name, coordinate: site.location)
                            {
                                Image(systemName: "mappin")
                                    .font(.largeTitle)
                                    .imageScale(.large)
                                    .symbolEffect(.pulse)
                                    .foregroundStyle(.red)
                            }
                            .annotationTitles(.hidden)
                        }
                        .frame(height: 125)
                        .overlay(alignment: .trailing, content: {
                            Image(systemName: "greaterthan")
                                .imageScale(.large)
                                .font(.title3)
                                .padding(.trailing, 5)
                        })
                        .overlay(alignment: .topLeading, content: {
                            Text("\(site.name) Location")
                                .padding([.leading, .bottom], 5)
                                .padding(.trailing, 8)
                                .background(.black.opacity(0.7))
                                .clipShape(.rect(bottomTrailingRadius: 15))
                        })
                        .clipShape(.rect(cornerRadius: 15))
                        .padding(.bottom, 10)
                    }
                    Text(site.description)
                        .padding(5)
                }
                .padding()
                .frame(width: geo.size.width, alignment: .leading)
            }
            .ignoresSafeArea()
            .toolbarBackground(.automatic)
        }
    }
}

#Preview {
    SiteDetail(site: CountrySite(id: 1, name: "Country Site", image: "asd", type: .castle, latitude: 35.0394, longitude: 135.7292, openHours: CountrySite.OpenHours(start: "a", end: "b"), description: "Description"), position: .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 35.0394, longitude: 135.7292), distance: 30000)), siteImage: Image(systemName: "globe"))
        .preferredColorScheme(.dark)
}
