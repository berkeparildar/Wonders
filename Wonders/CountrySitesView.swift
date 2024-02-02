//
//  ContentView.swift
//  Wonders
//
//  Created by Berke Parıldar on 1.02.2024.
//

import SwiftUI
struct CountrySitesView: View {
    @StateObject var countrySiteController: CountrySiteController
    @State var searchText: String = ""
    var body: some View {
        NavigationStack {
            if countrySiteController.countrySites.isEmpty {
                ProgressView("Loading...")
            }
            else {
                List(countrySiteController.countrySites) { countrySite in
                    CountrySiteTile(siteName: countrySite.name, siteImage: countrySiteController.siteImages[countrySite.id - 1], siteType: countrySite.type)
                        .frame(height: 100)
                }
                .navigationTitle("Japan Sites")
                .searchable(text: $searchText)
                .autocorrectionDisabled()
                .animation(.default, value: searchText)
                
            }
        }
        .onAppear(perform: {
            countrySiteController.fetchCountryData(country: "japan")
        })
    }
}

#Preview {
    NavigationStack {
        CountrySitesView(countrySiteController: CountrySiteController())
    }
    .preferredColorScheme(.dark)
}
