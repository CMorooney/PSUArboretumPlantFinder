//
//  ContentView.swift
//  PSUArboretum
//
//  Created by calvin on 9/16/23.
//

import SwiftUI
import MapKit
import ComposableArchitecture

struct MapView: View {
    let store: StoreOf<MapReducer>
    
    var body: some View {
        WithViewStore(self.store,
                      observe: { ( mapFeatures: $0.displayedMapFeatures,
                                   selectedLocation: $0.selectedLocation,
                                   selectedFeatureId: $0.selectedFeatureId,
                                   mapCamPos: $0.mapCamPos )
                      },
                      removeDuplicates: ==
        ) { viewStore in
            ZStack(alignment: .top) {
                Map(position: viewStore.binding(
                        get: \.mapCamPos,
                        send: MapReducer.Action.mapCamSet),
                    selection: viewStore.binding(
                        get: \.selectedFeatureId,
                        send: MapReducer.Action.featureSelected)
                ) {
                    ForEach(viewStore.mapFeatures) { feature in
                        Annotation(feature.commonName,
                                   coordinate: CLLocationCoordinate2D(latitude: feature.latitude,
                                                                      longitude: feature.longitude),
                                   anchor: .bottom) {
                            Circle()
                                .foregroundColor(Colors.brightGreen)
                                .frame(width: 10, height: 10)
                        }
                    }
                }
                .mapStyle(.imagery)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                if let l = viewStore.selectedLocation {
                    ZStack(alignment: .center) {
                        Rectangle()
                            .fill(Colors.offWhite)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .ignoresSafeArea()
                        HStack(alignment: .center) {
                            Text("**\(l)**")
                            Image(systemName: "chevron.up.chevron.down")
                        }
                        .onTapGesture(perform: {
                            viewStore.send(.locationTapped)
                        })
                    }
                    .frame(width: UIScreen.main.bounds.width, height: 65)
                }
            }
            .onAppear() {
                viewStore.send(.didAppear)
            }
            .sheet(
                store: self.store.scope(state: \.$featureDetailState, action: MapReducer.Action.featureDetail)
            ) { store in
                FeatureDetailView(store: store)
                    .presentationDetents([.medium])
                    .presentationBackground(Colors.blackish.opacity(0.85))
                
            }
            .sheet(
                store: self.store.scope(state: \.$locationSelectorState, action: MapReducer.Action.locationSelector)
            ) { store in
                LocationSelectorView(store: store)
                    .presentationDetents([.medium])
                    .presentationBackground(Colors.blackish.opacity(0.85))
                
            }
        }
    }
}

struct MapPreview: PreviewProvider {
    static var previews: some View {
        MapView(
            store: Store(initialState: MapReducer.State(selectedFeature: nil)) {
                MapReducer()
            }
        )
    }
}
