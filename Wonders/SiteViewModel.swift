//
//  SiteViewModel.swift
//  Wonders
//
//  Created by Berke Parıldar on 18.02.2024.
//

import Foundation

@MainActor
class SiteViewModel: ObservableObject {
    
    enum SiteStatus {
        case notStarted
        case fetching
        case success
        case failed
    }
    
    @Published var siteStatus: SiteStatus = .notStarted
    @Published var alphabetical: Bool = false
    @Published var searchText: String = ""
    @Published var currentSelection = SiteType.all
    
    private var sites: [SiteModel] = []
    var modifiedSites: [SiteModel] = []
    private let controller: FetchController

    init(controller: FetchController) {
        self.controller = controller
    }
    
    func getSites(for country: String) async {
        siteStatus = .fetching
        do {
            sites = try await controller.fetchSites(countryName: country)
            modifiedSites = sites
            siteStatus = .success
        } catch {
            siteStatus = .failed
        }
    }
    
    func filterSitesByType() {
        if currentSelection == .all {
            modifiedSites = sites
        }
        else {
            modifiedSites = sites.filter { site in
                site.type == currentSelection
            }
        }
    }
    
    func sortSitesAlphabetically() {
        modifiedSites.sort { site1, site2 in
            if alphabetical {
                site1.name < site2.name
            }
            else {
                site1.id < site2.id
            }
        }
    }
    
    func searchSitesByName() -> [SiteModel] {
        if searchText.isEmpty {
            return modifiedSites
        }
        else {
            return modifiedSites.filter { site in
                site.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func getModifiedSites() -> [SiteModel] {
        filterSitesByType()
        sortSitesAlphabetically()
        return searchSitesByName()
    }
    
    func isOpenNow(site: SiteModel) -> Bool {
        if site.openHours.start.lowercased() == "open" && site.openHours.end.lowercased() == "open" {
            return true
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let currentTimeString = dateFormatter.string(from: Date())
        let startTimeString = site.openHours.start
        let endTimeString = site.openHours.end
        if let currentTime = dateFormatter.date(from: currentTimeString),
           let startTime = dateFormatter.date(from: startTimeString),
           let endTime = dateFormatter.date(from: endTimeString) {
            return currentTime >= startTime && currentTime <= endTime
        }
        return false
    }
}
