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
    let closeRequested: () -> Void
    
    var body: some View {
        VStack {
            if let feature {
                HStack (
                    alignment: .center
                )
                {
                    Text("**\(feature.commonName.capitalized)**")
                        .font(.system(size: 20))
                    Spacer()
                    Button {
                        closeRequested()
                    } label: {
                        Image(systemName: "xmark.square")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                    }
                    .buttonStyle(ArboOutlineButtonStyle())
                }
                .padding([.leading, .trailing], 15)
                .frame(width: UIScreen.main.bounds.width, height: 50)
                .background(Colors.mediumGreen)
            }
            
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
                        Text("**family:** \(feature.family.capitalized)").padding([.leading, .top], 20)
                        Text("**genus:** \(feature.genus.capitalized)").padding(.leading, 20)
                        Text("**lifeForm:** \(feature.lifeForm.capitalized)").padding(.leading, 20)
                        Text("**states:** \(feature.states.capitalized)").padding(.leading, 20)
                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: height)
        .background(Colors.blackish.opacity(0.75))
        .foregroundColor(Colors.offWhite)
        .transition(.move(edge: .bottom))
        .offset(y: feature != nil ? 0 : height)
        
    }
}

#Preview {
    FeatureDetailView(feature: nil, closeRequested: {})
}
