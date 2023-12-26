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

@Reducer
struct MapReducer {
    struct State: Equatable {
        var features: [ArboretumFeature] = []
        
        @BindingState var selectedFeatureId: Int? = nil
        var selectedFeature: ArboretumFeature? = nil
        
        var loading: Bool = false
        
        static func == (lhs: MapReducer.State, rhs: MapReducer.State) -> Bool {
            return lhs.loading == rhs.loading &&
                   lhs.features == rhs.features &&
                   lhs.selectedFeature == rhs.selectedFeature
        }
    }
    
    enum Action: BindableAction, Equatable {
        case loadData
        case dataLoadBegan
        case dataLoadFailed
        case dataLoadSucceeded([ArboretumFeature])
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
                case .loadData:
                    return .run { send in
                        await send(.dataLoadBegan)
                        let data = DataReader.loadData();
                        await send(.dataLoadSucceeded(data))
                    }
                case .dataLoadBegan:
                    state.loading = true
                    return .none
                case .dataLoadFailed:
                    state.loading = true
                    return .none
                case .dataLoadSucceeded(let newFeatures):
                    state.loading = false
                    state.features = newFeatures
                    return .none
                case .binding(\.$selectedFeatureId):
                    if let fId = state.selectedFeatureId {
                        state.selectedFeature = state.features.first(where: { f in f.id == fId })
                    } else {
                        state.selectedFeature = nil
                    }
                    return .none
                case .binding:
                    return .none
            }
        }
    }
}
