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
        VStack (
            alignment: .leading
        )
        {
            if let feature {
                Text("commonName: \(feature.commonName)")
                Text("family: \(feature.family)")
                Text("genus: \(feature.genus)")
                Text("taxonName: \(feature.taxonName)")
                Text("lifeForm: \(feature.lifeForm)")
                Text("condition: \(feature.condition)")
                Text("location: \(feature.location)")
                Text("taxonDist: \(feature.taxonDist)")
                Text("states: \(feature.states)")
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: height)
        .background(Color.white)
        .transition(.move(edge: .bottom))
        .offset(y: feature != nil ? 0 : height)
    }
}

#Preview {
    FeatureDetailView(feature: nil)
}
