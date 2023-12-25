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
    var body: some Scene {
        WindowGroup {
            MapView(store: Store(initialState: MapReducer.State(selectedFeature: Binding.constant(nil))) {
                MapReducer()
            })
        }
    }
}
