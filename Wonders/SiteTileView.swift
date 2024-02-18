//
//  CountrySiteTile.swift
//  Wonders
//
//  Created by Berke Parıldar on 2.02.2024.
//

import SwiftUI

struct SiteTileView: View {
    let site: SiteModel
    var width: CGFloat
    var height: CGFloat
    var body: some View {
        HStack {
            AsyncImage(
                url: site.image,
                content: { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(.rect(cornerRadius: 10))
                        .frame(maxWidth: 130)
                        .shadow(color: .white, radius: 1)
                        .foregroundStyle(.black)
                        .padding(5)
                },
                placeholder: {
                    ProgressView()
                        .frame(width: 130)
                        .padding(5)
                }
            )
            VStack (alignment: .leading, content: {
                Text(site.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                Text(site.type.name)
                    .font(.subheadline)
                    .padding(5)
                    .background(site.type.backgroundColor)
                    .clipShape(.capsule)
            })
            Spacer()
            Image(systemName: "arrow.right")
                .foregroundStyle(.gray)
                .padding()
        }
        .frame(width: width, height: height, alignment: .leading)
        .background(.clear)
        .clipShape(.rect(cornerRadius: 10))
    }
}
