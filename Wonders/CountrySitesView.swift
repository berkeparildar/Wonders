//
//  ContentView.swift
//  Wonders
//
//  Created by Berke Parıldar on 1.02.2024.
//

import SwiftUI
import MapKit

struct CountrySitesView: View {
    @StateObject var countrySiteController: CountrySiteController
    @State var alphabetical: Bool = false
    @State var searchText: String = ""
    @State var currentSelection = SiteType.all
    var filteredSites: [CountrySite] {
        countrySiteController.filter(by: currentSelection)
        countrySiteController.sort(by: alphabetical)
        return countrySiteController.search(for: searchText)
    }
    
    var countryName: String
    var body: some View {
        VStack {
            if !countrySiteController.hasFetchedData {
                ProgressView("Loading...")
            }
            else {
                List(filteredSites) { countrySite in
                    NavigationLink {
                        SiteDetail(site: countrySite, position: .camera(MapCamera(centerCoordinate: countrySite.location, distance: 30000)), siteImage: countrySiteController.siteImages[countrySite.id - 1])
                    } label: {
                        CountrySiteTile(siteName: countrySite.name, siteImage: countrySiteController.siteImages[countrySite.id - 1], siteType: countrySite.type)
                            .frame(height: 100)
                    }
                }
                .navigationTitle("Japan Sites")
                .searchable(text: $searchText)
                .autocorrectionDisabled()
                .animation(.default, value: searchText)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading, content: {
                        Button {
                            withAnimation {
                                alphabetical.toggle()
                            }
                        } label: {
                            Image(systemName: alphabetical ? "textformat" : "film")
                                .symbolEffect(.bounce, value: alphabetical)
                        }
                    })
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Picker("Filter", selection: $currentSelection.animation()) {
                                ForEach(SiteType.allCases) { type in
                                    Label(type.name.capitalized, systemImage: "globe")
                                }
                            }
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                        }
                    }
                }
            }
        }
        .onAppear(perform: {
            if !countrySiteController.hasFetchedData {
                print("called")
                countrySiteController.fetchCountryData(country: countryName)
            }
        })
    }
}

#Preview {
    NavigationStack {
        CountrySitesView(countrySiteController: CountrySiteController(), countryName: "japan")
    }
    .preferredColorScheme(.dark)
}
