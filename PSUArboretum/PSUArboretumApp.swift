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
    static let store = Store(initialState: MapReducer.State(selectedFeature: nil)) {
        MapReducer()
    }
    var body: some Scene {
        WindowGroup {
            MapView(store: PSUArboretumApp.store)
        }
    }
}
