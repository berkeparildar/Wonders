//
//  CountrySiteTile.swift
//  Wonders
//
//  Created by Berke Parıldar on 2.02.2024.
//

import SwiftUI

struct CountrySiteTile: View {
    var siteName: String
    var siteImage: Image
    var siteType: SiteType
    var width: CGFloat
    var height: CGFloat
    var body: some View {
        HStack {
            siteImage
                .resizable()
                .scaledToFit()
                .clipShape(.rect(cornerRadius: 10))
                .frame(maxWidth: 130)
                .shadow(color: .white, radius: 1)
                .foregroundStyle(.black)
                .padding(5)
            VStack (alignment: .leading, content: {
                Text(siteName)
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                Text(siteType.name)
                    .font(.subheadline)
                    .padding(5)
                    .background(siteType.backgroundColor)
                    .clipShape(.capsule)
            })
            Spacer()
            Image(systemName: "arrow.right")
                .foregroundStyle(.gray)
        }
        .frame(width: width, height: height, alignment: .leading)
        //.background(.regularMaterial)
        .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    CountrySiteTile(siteName: "SiteName", siteImage: Image(systemName: "globe"), siteType: .castle, width: 200, height: 100)
        .preferredColorScheme(.dark)
}
