//
//  CountrySelect.swift
//  Wonders
//
//  Created by Berke Parıldar on 2.02.2024.
//

import SwiftUI

struct CountryListView: View {
    @StateObject var viewModel = CountryViewModel(controller: FetchController())
    var body: some View {
        NavigationStack {
            switch viewModel.countryStatus {
            case .fetching:
                VStack {
                    ProgressView("Loading...")
                }
            case .success:
                ScrollView {
                    VStack (alignment: .leading) {
                        LazyVGrid(columns: [GridItem(), GridItem()], alignment: .center, spacing: 10, content: {
                            ForEach(viewModel.getCountries()) { country in
                                NavigationLink {
                                    SiteListView(country: country)
                                } label: {
                                    CountryTileView(country: country)
                                }
                            }
                        })
                        .padding(.horizontal)
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .searchable(text: $viewModel.searchText)
                    .animation(.default, value: viewModel.searchText)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack {
                                Text("Wonders")
                                Image(systemName: "building.columns")
                            }
                        }
                    }
                }
            default:
                EmptyView()
            }
        }
        .onAppear(perform: {
            if viewModel.countryStatus == .notStarted {
                Task {
                    await viewModel.getCountryData()
                }
            }
        })
    }
}

#Preview {
    CountryListView()
        .preferredColorScheme(.dark)
}
