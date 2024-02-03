//
//  CountrySelect.swift
//  Wonders
//
//  Created by Berke Parıldar on 2.02.2024.
//

import SwiftUI

struct CountrySelect: View {
    let countrySiteContoller = CountrySiteController()
    
    var body: some View {
        NavigationStack {
            LazyVGrid(columns: [GridItem(), GridItem(), GridItem()], alignment: .center, spacing: 20, content: {
                CountryIcon(countryName: "japan", countrySiteController: countrySiteContoller)
                CountryIcon(countryName: "turkey", countrySiteController: countrySiteContoller)
                CountryIcon(countryName: "italy", countrySiteController: countrySiteContoller)
                CountryIcon(countryName: "korea", countrySiteController: countrySiteContoller)
                CountryIcon(countryName: "france", countrySiteController: countrySiteContoller)
                CountryIcon(countryName: "us", countrySiteController: countrySiteContoller)
                
            })
            .padding()
        }
        .onAppear(perform: {
            countrySiteContoller.resetData()
        })
        .preferredColorScheme(.dark)
    }
}

#Preview {
    CountrySelect()
}
