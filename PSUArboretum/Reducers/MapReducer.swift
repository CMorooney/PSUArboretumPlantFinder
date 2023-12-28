//
//  MapReducer.swift
//  PSUArboretum
//
//  Created by calvin on 9/16/23.
//

import Foundation
import ComposableArchitecture
import MapKit
import SwiftUI
import RealmSwift

@Reducer
struct MapReducer {
    let environment = Environment()
    
    struct State: Equatable {
        var loading: Bool = false
        
        var mapCamPos = MapCameraPosition.region(
            MKCoordinateRegion(
                // children's garden which happens to be the alphabetical default to selected location
                // which is also not saved x-session atm
                center: CLLocationCoordinate2D(latitude: 40.8059902, longitude: -77.8694468),
                // Deltas are in lat/lng degrees.... one lat degree is ~111,000 meters soooooo yeah
                span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
            )
        )
        
        var allMapFeatures: [ArboretumFeature] = []
        var displayedMapFeatures: [ArboretumFeature] = []
        
        @PresentationState var locationSelectorState: LocationSelectorReducer.State?
        var featureLocations: [String] = []
        var selectedLocation: String?
        
        @PresentationState var featureDetailState: FeatureDetailReducer.State?
        var selectedFeatureId: Int? = nil
        var selectedFeature: ArboretumFeature? = nil
    }
    
    enum Action: Equatable {
        case didAppear
        case localDataBeganLoad
        case localDataLoaded([ArboretumFeature])
        case locationSelected(String?)
        case featureSelected(Int?)
        case deselectFeature
        case locationTapped
        case mapCamSet(MapCameraPosition)
        case locationSelector(PresentationAction<LocationSelectorReducer.Action>)
        case featureDetail(PresentationAction<FeatureDetailReducer.Action>)
    }
    
    struct Environment {
        let realm: Realm
        
        init() {
            self.realm = try! Realm()
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .locationSelected(let newLocation):
                    state.selectedLocation = newLocation
                    state.displayedMapFeatures = state.allMapFeatures.filter { $0.location == newLocation }
                    state.mapCamPos = MapCameraPosition.region(
                        MKCoordinateRegion(MKMapRect(arboretumFeatures: state.displayedMapFeatures))
                    )
                    
                    return .none
                case .locationTapped:
                    if let loc = state.selectedLocation {
                        state.locationSelectorState = LocationSelectorReducer.State(
                            selectedLocation: loc,
                            allLocations: state.featureLocations
                        )
                    }
                    return .none
                case .locationSelector(let lAction):
                    switch lAction {
                        case .presented(let action):
                            switch action {
                                case .locationSelected(let location):
                                    if let location {
                                        state.locationSelectorState = nil
                                        return .send(.locationSelected(location))
                                    }
                                case .close:
                                    state.locationSelectorState = nil
                            }
                            return .none
                        default:
                            return .none
                    }
                case .featureDetail(let pAction):
                    switch pAction {
                        case .presented(let action):
                            if action == FeatureDetailReducer.Action.close {
                                state.featureDetailState = nil
                            }
                            return .none
                        default:
                            return .none
                    }
                case .didAppear:
                    return environment.realm
                        .fetch(
                            RealmArboretumFeature.self
                        )
                        .map { objects -> Action in
                            return .localDataLoaded(Array(objects.map { f in ArboretumFeature(f) }))
                        }
                case .localDataBeganLoad:
                    state.loading = true
                    return .none
                case .localDataLoaded(let domainModels):
                    state.allMapFeatures = domainModels
                    state.featureLocations = Set(state.allMapFeatures.map { $0.location }).filter { !$0.isBlank }
                    // todo: load last location
                    return .send(.locationSelected(state.allMapFeatures.first?.location))
                case .deselectFeature:
                    state.selectedFeatureId = nil
                    state.selectedFeature = nil
                    return .none
                case .featureSelected(let selectedFeatureId):
                    if let fId = selectedFeatureId,
                       let selectedFeature = state.allMapFeatures.first(where: { f in f.id == fId }) {
                        
                        state.selectedFeature = selectedFeature
                        state.featureDetailState = FeatureDetailReducer.State(selectedFeature: selectedFeature)
                        
                        state.mapCamPos = MapCameraPosition.region(
                            MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: selectedFeature.latitude, longitude: selectedFeature.longitude),
                                // Deltas are in lat/lng degrees.... one lat degree is ~111,000 meters soooooo yeah
                                span: MKCoordinateSpan(latitudeDelta: 0.000001, longitudeDelta: 0.000001)
                            )
                        )
                    }
                    return .none
                case .mapCamSet(_):
                    // nothing to do here
                    // but the compiler was complaining about the binding being too complex to understand
                    // in MapView until I gave it something to `send`
                    return .none
            }
        }
        .ifLet(\.$featureDetailState, action: /Action.featureDetail) {
            FeatureDetailReducer()
        }
        .ifLet(\.$locationSelectorState, action: /Action.locationSelector) {
            LocationSelectorReducer()
        }
    }
}
