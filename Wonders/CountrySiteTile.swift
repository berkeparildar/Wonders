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
                Text(siteType.name)
                    .font(.subheadline)
                    .padding(5)
                    .background(siteType.backgroundColor)
                    .clipShape(.capsule)
            })
        }
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CountrySiteTile(siteName: "SiteName", siteImage: Image(systemName: "globe"), siteType: .castle)
}
