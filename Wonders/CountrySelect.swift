//
//  CountrySelect.swift
//  Wonders
//
//  Created by Berke Parıldar on 2.02.2024.
//

import SwiftUI

struct CountrySelect: View {
    @StateObject var countrySiteController = CountrySiteController()
    @State var searchText: String = ""
    @State var alphabetical: Bool = false
    var filteredCountries: [String] {
        countrySiteController.sortCountry(by: alphabetical)
        return countrySiteController.searchCountry(for: searchText)
    }
    var body: some View {
        NavigationStack {
            if !countrySiteController.hasFetchedCountryImages {
                VStack {
                    ProgressView("Loading...")
                }
                .onAppear(perform: {
                    if !countrySiteController.hasFetchedCountryImages {
                        countrySiteController.fetchCountryImages()
                    }
                })
            }
            else {
                ScrollView {
                    VStack (alignment: .leading) {
                        Text("Countries")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(20)
                        LazyVGrid(columns: [GridItem(), GridItem()], alignment: .center, spacing: 10, content: {
                            ForEach(filteredCountries, id: \.self) {country in
                                CountryIcon(countryName: country,
                                            countryImage: countrySiteController.countryImages[
                                                countrySiteController.countries.firstIndex(of: country)!
                                            ],
                                            countrySiteController: countrySiteController)
                            }
                        })
                        .padding()
                    }
                    .onAppear(perform: {
                        countrySiteController.resetData()
                    })
                    
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("Wonders")
                    .searchable(text: $searchText)
                    .animation(.default, value: searchText)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack {
                                Text("Wonders")
                                Image(systemName: "building.columns")
                            }
                        }
                    }
                    
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    CountrySelect()
}
