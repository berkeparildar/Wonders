//
//  CountryIcon.swift
//  Wonders
//
//  Created by Berke Parıldar on 3.02.2024.
//

import SwiftUI

struct CountryIcon: View {
    let countryName: String
    let countryImage: Image
    let countrySiteController: CountrySiteController
    var body: some View {
        NavigationLink {
            CountrySitesView(countrySiteController: countrySiteController, countryName: countryName)
        } label: {
            ZStack(alignment: .bottomTrailing) {
                countryImage
                    .resizable()
                    .scaledToFit()
                VStack (alignment: .trailing) {
                    Spacer()
                    Text(countryName.capitalized)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(4)
                        .background(.regularMaterial)
                        .clipShape(.capsule)
                }
                .foregroundStyle(.white)
                .padding(5)
            }
            .clipShape(.rect(cornerRadius: 10))
        }
    }
}

#Preview {
    CountryIcon(countryName: "japan", countryImage: Image(systemName: "globe"), countrySiteController: CountrySiteController())
        .preferredColorScheme(.dark)
}
