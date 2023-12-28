//
//  FeatureDetailReducer.swift
//  PSUArboretum
//
//  Created by calvin on 12/28/23.
//

import Foundation
import ComposableArchitecture
import _MapKit_SwiftUI
import SwiftUI
import RealmSwift

@Reducer
struct FeatureDetailReducer {
    struct State: Equatable {
        var selectedFeature: ArboretumFeature? = nil
    }
    
    enum Action: Equatable {
        case featureSelected(ArboretumFeature)
        case close
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .featureSelected(let feature):
                    state.selectedFeature = feature
                    return .none
                case .close:
                    print("close")
                    return .none
            }
        }
    }
}
