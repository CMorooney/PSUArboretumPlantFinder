//
//  LocationSelectorView.swift
//  PSUArboretum
//
//  Created by calvin on 12/28/23.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct LocationSelectorView: View {
    let store: StoreOf<LocationSelectorReducer>
    
    var body: some View {
        WithViewStore(self.store,
                      observe: { ( allLocations: $0.allLocations, selectedLocation: $0.selectedLocation ) },
                      removeDuplicates: ==
        ) { viewStore in
            // these will be unique for sure
            List(viewStore.allLocations.sorted(),
                 id: \.self,
                 selection: viewStore.binding(
                    get: \.selectedLocation,
                    send: LocationSelectorReducer.Action.locationSelected
                 )
            ) { location in
                HStack {
                    Text(location)
                        .foregroundStyle(Colors.blackish)
                    if viewStore.selectedLocation == location {
                        Spacer()
                        Circle()
                            .fill(Colors.paleOrange)
                            .frame(width: 20, height: 20)
                    }
                }
            }
            .listRowBackground(Color(UIColor.clear))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
