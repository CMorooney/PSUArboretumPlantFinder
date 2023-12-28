//
//  MapReducer.swift
//  PSUArboretum
//
//  Created by calvin on 9/16/23.
//

import Foundation
import ComposableArchitecture
import _MapKit_SwiftUI
import SwiftUI
import RealmSwift


@Reducer
struct MapReducer {
    let environment = Environment()
    
    struct State: Equatable {
        var features: [ArboretumFeature] = []
        
        var loading: Bool = false
        
        var selectedFeatureId: Int? = nil
        @PresentationState var selectedFeature: ArboretumFeature? = nil
        
        static func == (lhs: MapReducer.State, rhs: MapReducer.State) -> Bool {
            return lhs.features == rhs.features &&
            lhs.selectedFeature == rhs.selectedFeature
        }
    }
    
    enum Action: Equatable {
        case none
        case didAppear
        case localDataBeganLoad
        case localDataLoaded([ArboretumFeature])
        case featureSelected(Int?)
        case deselectFeature
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
                case .none:
                    return .none
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
                    state.features = domainModels
                    return .none
                case .deselectFeature:
                    state.selectedFeatureId = nil
                    state.selectedFeature = nil
                    return .none
                case .featureSelected(let selectedFeatureId):
                    if let fId = selectedFeatureId {
                        state.selectedFeature = state.features.first(where: { f in f.id == fId })
                    }
                    return .none
            }
        }
    }
}
