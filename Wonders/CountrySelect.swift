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
            NavigationLink {
                CountrySitesView(countrySiteController: countrySiteContoller)
            } label: {
               Text("Show Japan")
                    .foregroundStyle(.white)
                    .padding()
                    .background(.blue)
                    .clipShape(.rect(cornerRadius: 10))
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    CountrySelect()
}
