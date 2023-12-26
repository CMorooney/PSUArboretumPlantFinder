//
//  FeatureDetailView.swift
//  PSUArboretum
//
//  Created by calvin on 12/26/23.
//

import SwiftUI

struct FeatureDetailView: View {
    let feature: ArboretumFeature?
    let height = UIScreen.main.bounds.height / 2
    
    var body: some View {
        ScrollView {
            VStack (
                alignment: .leading,
                spacing: 8
            )
            {
                if let feature {
                    if let photoUrl = feature.getScrapedImage() {
                        AsyncImage(url: URL(string: photoUrl))
                            .frame(width: UIScreen.main.bounds.width, height: 150)
                            .padding(.top, 20)
                    }
                    Text("**commonName:** \(feature.commonName)").padding([.leading, .top], 20)
                    Text("**family:** \(feature.family)").padding(.leading, 20)
                    Text("**genus:** \(feature.genus)").padding(.leading, 20)
                    Text("**taxonName:** \(feature.taxonName)").padding(.leading, 20)
                    Text("**lifeForm:** \(feature.lifeForm)").padding(.leading, 20)
                    Text("**condition:** \(feature.condition)").padding(.leading, 20)
                    Text("**location:** \(feature.location)").padding(.leading, 20)
                    Text("**taxonDist:** \(feature.taxonDist)").padding(.leading, 20)
                    Text("**states:** \(feature.states)").padding(.leading, 20)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: height)
        .ignoresSafeArea(edges: [.bottom])
        .background(Color.black.opacity(0.75))
        .foregroundColor(Color.white)
        .clipShape(
            .rect(
                topLeadingRadius: 10,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 10
            )
        )
        .transition(.move(edge: .bottom))
        .offset(y: feature != nil ? 0 : height)
    }
}

#Preview {
    FeatureDetailView(feature: nil)
}
