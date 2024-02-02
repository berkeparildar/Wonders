//
//  ContentView.swift
//  Wonders
//
//  Created by Berke Parıldar on 1.02.2024.
//

import SwiftUI
struct CountrySitesView: View {
    @StateObject var countrySiteController: CountrySiteController
    var body: some View {
        NavigationStack {
            if countrySiteController.countrySites.isEmpty {
                ProgressView("Loading...")
            }
            else {
                List(countrySiteController.countrySites) { countrySite in
                    Text(countrySite.image)
                    countrySiteController.siteImages[countrySite.id - 1]
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                }
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
}
