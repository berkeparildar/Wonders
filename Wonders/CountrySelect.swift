//
//  CountrySelect.swift
//  Wonders
//
//  Created by Berke Parıldar on 2.02.2024.
//

import SwiftUI

struct CountrySelect: View {
    @StateObject var countrySiteContoller = CountrySiteController()
    @State var searchText: String = ""
    @State var alphabetical: Bool = false
    var filteredCountries: [String] {
        countrySiteContoller.sortCountry(by: alphabetical)
        return countrySiteContoller.searchCountry(for: searchText)
    }
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (alignment: .leading) {
                    Text("Countries")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(20)
                    LazyVGrid(columns: [GridItem(), GridItem()], alignment: .center, spacing: 20, content: {
                        ForEach(filteredCountries, id: \.self) {country in
                            CountryIcon(countryName: country,
                                        countryImage: countrySiteContoller.countryImages[
                                            countrySiteContoller.countries.firstIndex(of: country)!
                                        ],
                                        countrySiteController: countrySiteContoller)
                        }
                    })
                    .padding()
                }
                .navigationTitle("Wonders")
                .navigationBarTitleDisplayMode(.inline)
                .searchable(text: $searchText)
            }
        }
        .onAppear(perform: {
            countrySiteContoller.fetchCountryImages()
            countrySiteContoller.resetData()
        })
        .preferredColorScheme(.dark)
    }
}

#Preview {
    CountrySelect()
}
