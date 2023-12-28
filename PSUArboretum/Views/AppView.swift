//
//  AppView.swift
//  PSUArboretum
//
//  Created by calvin on 12/27/23.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: StoreOf<AppReducer>
    
    var body: some View {
        WithViewStore(self.store,
                      observe: \.selectedTab,
                      removeDuplicates: ==
        ){ viewStore in
            TabView(
                selection: viewStore.binding(
                    send: { AppReducer.Action.tabSelected($0) }
                )
            ) {
                MapView(store: self.store.scope(state: \.mapState, action: AppReducer.Action.map))
                    .tabItem {
                        Label("map", systemImage: "map.circle")
                    }
            }
            .onAppear {
                viewStore.send(.loadData)
            }
        }
    }
}

struct AppPreview: PreviewProvider {
    static var previews: some View {
        AppView(
            store: Store(initialState: AppReducer.State()) {
                AppReducer()
            }
        )
    }
}
