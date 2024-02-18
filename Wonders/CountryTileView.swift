//
//  CountryIcon.swift
//  Wonders
//
//  Created by Berke Parıldar on 3.02.2024.
//

import SwiftUI

struct CountryTileView: View {
    let country: CountryModel
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                AsyncImage(
                    url: country.image,
                    content: {image in
                        image
                            .resizable()
                            .scaledToFit()
                    },
                    placeholder: {
                        ProgressView()
                    })
            }
            
            VStack (alignment: .trailing) {
                Spacer()
                Text(country.name)
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

#Preview {
    CountryTileView(country: CountryModel(id: 1, name: "Yolo", image:URL(string: "a")! , sites: URL(string: "a")!))
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
