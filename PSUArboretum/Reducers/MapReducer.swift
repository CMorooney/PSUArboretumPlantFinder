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

struct MapReducer: Reducer {
    struct State: Equatable {
        var features: [ArboretumFeature] = []
        @Binding var selectedFeature: MapFeature?
        var loading: Bool = false
        
        static func == (lhs: MapReducer.State, rhs: MapReducer.State) -> Bool {
            return
                lhs.loading == rhs.loading &&
                lhs.features == rhs.features &&
                lhs.selectedFeature == rhs.selectedFeature
        }
    }
    
    enum Action: Equatable {
        case loadData
        case dataLoadBegan
        case dataLoadFailed
        case dataLoadSucceeded([ArboretumFeature])
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
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
        }
    }
}
