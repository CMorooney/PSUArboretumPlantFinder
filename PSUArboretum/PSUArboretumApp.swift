//
//  PSUArboretumApp.swift
//  PSUArboretum
//
//  Created by calvin on 9/16/23.
//

import SwiftUI
import ComposableArchitecture

@main
struct PSUArboretumApp: App {
    static let store = Store(initialState: MapReducer.State(selectedFeature: Binding.constant(nil))) {
        MapReducer()
        ._printChanges()
    }
    var body: some Scene {
        WindowGroup {
            MapView(store: PSUArboretumApp.store)
        }
    }
}
