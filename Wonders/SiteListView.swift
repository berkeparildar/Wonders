//
//  ContentView.swift
//  Wonders
//
//  Created by Berke Parıldar on 1.02.2024.
//

import SwiftUI
import MapKit

struct SiteListView: View {
    @StateObject var viewModel: SiteViewModel = SiteViewModel(controller: FetchController())
    let country: CountryModel
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                switch viewModel.siteStatus {
                case .fetching:
                    VStack {
                        ProgressView("Loading...")
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                case .success:
                    
                    VStack {
                        ForEach(viewModel.getModifiedSites()) { countrySite in
                            Divider()
                            NavigationLink {
                                SiteView(site: countrySite, isOpen: viewModel.isOpenNow(site: countrySite), position: .camera(MapCamera(centerCoordinate: countrySite.location, distance: 30000)))
                            } label: {
                                SiteTileView(site: countrySite, width: geo.size.width * 0.95, height: 100)
                            }
                        }
                    }
                    .frame(width: geo.size.width * 0.95)
                    .background(.regularMaterial)
                    .clipShape(.rect(cornerRadius: 10))
                    
                default:
                    EmptyView()
                }
            }
            .frame(width: geo.size.width)
        }
        .onAppear(perform: {
            if viewModel.siteStatus == .notStarted {
                Task {
                    await viewModel.getSites(for: country.name.lowercased())
                }
            }
            print(viewModel.siteStatus)
        })
        .animation(.default, value: viewModel.searchText)
        .animation(.default, value: viewModel.siteStatus)
        .navigationTitle("Sites")
        .searchable(text: $viewModel.searchText)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button {
                    withAnimation {
                        viewModel.alphabetical.toggle()
                    }
                } label: {
                    if viewModel.alphabetical {
                        Image(systemName: "textformat")
                            .symbolEffect(.bounce, value: viewModel.alphabetical)
                            .foregroundStyle(.blue)
                    }
                    else {
                        Image(systemName: "textformat")
                            .symbolEffect(.bounce, value: viewModel.alphabetical)
                    }
                }
                
            })
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Picker("Filter", selection: $viewModel.currentSelection.animation()) {
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
