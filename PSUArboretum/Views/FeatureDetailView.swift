//
//  FeatureDetailView.swift
//  PSUArboretum
//
//  Created by calvin on 12/26/23.
//

import SwiftUI
import ComposableArchitecture

struct FeatureDetailView: View {
    let store: StoreOf<FeatureDetailReducer>
    
    let height = UIScreen.main.bounds.height / 2
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                if let feature = viewStore.selectedFeature {
                    HStack (
                        alignment: .center
                    )
                    {
                        Text("**\(feature.commonName.capitalized)**")
                            .font(.system(size: 20))
                        Spacer()
                        Button {
                            viewStore.send(.close)
                        } label: {
                            Image(systemName: "xmark.square")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                        }
                        .buttonStyle(ArboOutlineButtonStyle())
                    }
                    .padding([.all], 15)
                    .frame(width: UIScreen.main.bounds.width, height: 50)
                    .background(Colors.mediumGreen)
                }
                
                ScrollView {
                    VStack (
                        alignment: .leading,
                        spacing: 8
                    )
                    {
                        if let feature = viewStore.selectedFeature {
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
            .foregroundColor(Colors.offWhite)
            .transition(.move(edge: .bottom))
            .offset(y: viewStore.selectedFeature != nil ? 0 : height)
        }
    }
}

struct FeatureDetailPreview: PreviewProvider {
    static var previews: some View {
        FeatureDetailView(
            store: Store(initialState: FeatureDetailReducer.State()) {
                FeatureDetailReducer()
            }
        )
    }
}

