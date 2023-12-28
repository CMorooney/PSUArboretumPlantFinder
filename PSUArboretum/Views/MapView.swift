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
            center: CLLocationCoordinate2D(latitude: 40.805597, longitude: -77.869007),
            // Deltas are in lat/lng degrees.... one lat degree is ~111,000 meters soooooo yeah
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ),
        minimumDistance: 1,
        maximumDistance: 1500
    )
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack(alignment: .bottom) {
                Map(bounds: region,
                    interactionModes: .all,
                    selection: viewStore.binding(
                        get: \.selectedFeatureId,
                        send: MapReducer.Action.featureSelected)
                ) {
                    ForEach(viewStore.features, id: \.id) { feature in
                        Annotation(feature.commonName,
                                   coordinate: CLLocationCoordinate2D(latitude: feature.latitude,
                                                                      longitude: feature.longitude),
                                   anchor: .bottom) {
                            Circle()
                                .foregroundColor(Colors.brightGreen)
                                .frame(width: 10, height: 10)
                        }
                                   .tag(feature.id)
                    }
                }
                .mapStyle(.hybrid(elevation: .realistic))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear() {
                    viewStore.send(.didAppear)
                }
                .sheet(
                    store: self.store.scope(state: \.$featureDetailState, action: MapReducer.Action.featureDetail)
                ) { store in
                    FeatureDetailView(store: store)
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
