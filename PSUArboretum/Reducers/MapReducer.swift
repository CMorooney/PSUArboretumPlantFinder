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
        var userSettingsLoading: Bool = false
        
        var loading: Bool {
            userSettingsLoading
        }
        
        var mapCamPos = MapCameraPosition.region(
            MKCoordinateRegion(
                // children's garden which happens to be the alphabetical default to selected location
                // which is also not saved x-session atm
                center: CLLocationCoordinate2D(latitude: 40.8059902, longitude: -77.8694468),
                // Deltas are in lat/lng degrees.... one lat degree is ~111,000 meters soooooo yeah
                span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
            )
        )
        
        var lastSessionData: RealmLastSessionValues?
        
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
        case none
        
        case loadMapData
        case mapDataLoaded([ArboretumFeature])
        
        case loadUserSettings
        case userSettingsLoaded(UserSettings)
        
        case locationTapped
        case locationSelected(String?)
        
        case featureSelected(Int?)
        case deselectFeature
        
        case loadPreviousSessionData
        case previousSessionDataLoaded(RealmLastSessionValues?)
        
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
                case .none: return .none
                    
                case .locationSelected(let newLocation):
                    // fallback to Event Lawn if it exists...
                    // the proper alphabetical "first" is kind of underwhelming content-wise
                    let loc = newLocation ??
                    state.featureLocations.sorted().first(where: { $0 == "Event Lawn" }) ??
                    state.featureLocations.sorted().first
                    
                    if loc == nil {
                        return .none
                    }
                    state.selectedLocation = loc
                    state.displayedMapFeatures = state.allMapFeatures.filter { $0.location == loc }
                    state.mapCamPos = MapCameraPosition.region(
                        MKCoordinateRegion(MKMapRect(arboretumFeatures: state.displayedMapFeatures))
                    )
                    
                    if state.lastSessionData == nil {
                        state.lastSessionData=RealmLastSessionValues(lastSelectedLocation: loc)
                    }
                    
                    return environment.realm.save(RealmLastSessionValues(id: state.lastSessionData!.id,
                                                                         lastSelectedLocation: loc)).map { signal in
                        return .none
                    }
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
                    
                case .loadMapData:
                    return environment.realm
                        .fetch(
                            RealmArboretumFeature.self
                        )
                        .map { objects -> Action in
                            return .mapDataLoaded(Array(objects.map { f in ArboretumFeature(f) }))
                        }
                case .mapDataLoaded(let domainModels):
                    state.allMapFeatures = domainModels
                    state.featureLocations = Set(state.allMapFeatures.map { $0.location }).filter { !$0.isBlank }
                    return .send(.loadUserSettings)
                    
                case .loadUserSettings:
                    state.userSettingsLoading = true
                    return environment.realm
                        .fetch(RealmUserSettings.self)
                        .map { objects -> Action in
                            if let s = objects.first {
                                return .userSettingsLoaded(UserSettings(from: s))
                            } else {
                                return .userSettingsLoaded(UserSettings.createDefault())
                            }
                        }
                    
                case .userSettingsLoaded(let uSettings):
                    state.userSettingsLoading = false
                    switch uSettings.defaultLocationSetting {
                        case .lastSelected:
                            return .send(.loadPreviousSessionData)
                        case .specific(let s):
                            return .send(.locationSelected(s))
                    }
                    
                case .loadPreviousSessionData:
                    return environment.realm
                        .fetch(RealmLastSessionValues.self)
                        .map { objects -> Action in
                            return .previousSessionDataLoaded(objects.first)
                        }
                    
                case .previousSessionDataLoaded(let sessionData):
                    state.lastSessionData = sessionData
                    return .send(.locationSelected(state.lastSessionData?.lastSelectedLocation))
                    
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
