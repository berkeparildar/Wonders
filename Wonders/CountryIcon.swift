//
//  CountryIcon.swift
//  Wonders
//
//  Created by Berke Parıldar on 3.02.2024.
//

import SwiftUI

struct CountryIcon: View {
    let countryName: String
    let countrySiteController: CountrySiteController
    var body: some View {
        NavigationLink {
            CountrySitesView(countrySiteController: countrySiteController, countryName: countryName)
        } label: {
                VStack {
                    Text(countrySiteController.getCountryFlag(country: countryName))
                        .font(.system(size: 50))
                    Text(countryName.capitalized)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
                .foregroundStyle(.white)
                .padding(5)
            .frame(width: 100, height: 100)
            .background(.regularMaterial)
            .clipShape(.rect(cornerRadius: 10))
        }
    }
}

#Preview {
    CountryIcon(countryName: "japan", countrySiteController: CountrySiteController())
}
