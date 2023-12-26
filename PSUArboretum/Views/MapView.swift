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
    
    @State private var region = MapCameraBounds(
        centerCoordinateBounds: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 40.8123343, longitude: -77.8771519),
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        ),
        minimumDistance: 5,
        maximumDistance: 30
    )
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack(alignment: .bottom) {
                if viewStore.loading {
                   ProgressView()
                } else {
                    Map(bounds: region, interactionModes: .all, selection: viewStore.$selectedFeatureId) {
                        ForEach(viewStore.features, id: \.id) { feature in
                            Marker(feature.commonName,
                                   coordinate: CLLocationCoordinate2D(latitude: feature.latitude,
                                                                      longitude: feature.longitude))
                            .tag(feature.id)
                        }
                    }
                    .mapStyle(.hybrid(elevation: .realistic))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear() {
                        viewStore.send(.loadData)
                    }
                    FeatureDetailView(feature: viewStore.selectedFeature, closeRequested: {
                        viewStore.send(.deselectFeature)
                    })
                }
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
