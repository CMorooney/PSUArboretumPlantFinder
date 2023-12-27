//
//  PSUArboretumApp.swift
//  PSUArboretum
//
//  Created by calvin on 9/16/23.
//

import SwiftUI
import ComposableArchitecture
import RealmSwift

@main
struct PSUArboretumApp: SwiftUI.App {
    static let store = Store(initialState: AppReducer.State()) {
        AppReducer()
    }
    var body: some Scene {
        WindowGroup {
            AppView(store: PSUArboretumApp.store)
        }
    }
}

