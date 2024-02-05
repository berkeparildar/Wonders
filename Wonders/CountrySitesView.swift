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
        countrySiteController.filterCountrySites(by: currentSelection)
        countrySiteController.sortCountrySites(by: alphabetical)
        return countrySiteController.searchCountrySites(for: searchText)
    }
    
    var countryName: String
    var body: some View {
        VStack {
            if !countrySiteController.hasFetchedData && !countrySiteController.hasFetchedImages {
                VStack {
                    ProgressView("Loading...")
                }
            }
            else {
                GeometryReader { geo in
                    ScrollView {
                        VStack {
                            ForEach(filteredSites) { countrySite in
                                Divider()
                                NavigationLink {
                                    SiteDetail(site: countrySite, isOpen: countrySiteController.isOpenNow(site: countrySite), position: .camera(MapCamera(centerCoordinate: countrySite.location, distance: 30000)), siteImage: countrySiteController.siteImages[countrySite.id - 1])
                                } label: {
                                    CountrySiteTile(siteName: countrySite.name, siteImage: countrySiteController.siteImages[countrySite.id - 1], siteType: countrySite.type,
                                                    width: geo.size.width * 0.9, height: 100
                                    )
                                }
                                .padding(5)
                            }
                        }
                        .frame(width: geo.size.width * 0.95)
                        .background(.regularMaterial)
                        .clipShape(.rect(cornerRadius: 10))
                        .animation(.default, value: searchText)
                    }
                    .frame(width: geo.size.width)
                }
                .navigationTitle("\(countryName.capitalized) Sites")
                .searchable(text: $searchText)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing, content: {
                        Button {
                            withAnimation {
                                alphabetical.toggle()
                            }
                        } label: {
                            if alphabetical {
                                Image(systemName: "textformat")
                                    .symbolEffect(.bounce, value: alphabetical)
                                    .foregroundStyle(.blue)
                            }
                            else {
                                Image(systemName: "textformat")
                                    .symbolEffect(.bounce, value: alphabetical)
                            }
                        }
                        
                    })
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Picker("Filter", selection: $currentSelection.animation()) {
                                ForEach(SiteType.allCases) { type in
                                    Label(type.name.capitalized, systemImage: "\(type.icon)")
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
                print("called for \(countryName)")
                countrySiteController.fetchCountrySites(country: countryName)
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
