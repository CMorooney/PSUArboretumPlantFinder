//
//  LocationSelectorReducer.swift
//  PSUArboretum
//
//  Created by calvin on 12/28/23.
//

import Foundation
import ComposableArchitecture
import SwiftUI
import RealmSwift

@Reducer
struct LocationSelectorReducer {
    struct State: Equatable {
        var selectedLocation: String?
        var allLocations: [String]
    }
    
    enum Action: Equatable {
        case locationSelected(String?)
        case close
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .locationSelected(let location):
                    if let location {
                        state.selectedLocation = location
                    }
                    return .none
                case .close:
                    return .none
            }
        }
    }
}
