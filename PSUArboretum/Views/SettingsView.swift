//
//  SettingsView.swift
//  PSUArboretum
//
//  Created by calvin on 12/28/23.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct SettingsView: View {
    let store: StoreOf<SettingsReducer>
    
    var body: some View {
        WithViewStore(self.store,
                      observe: { ( userSettings: $0.userSettings,
                                   locations: $0.locations,
                                   selectedLocation: $0.selectedLocation ) },
                      removeDuplicates: ==
        ) { viewStore in
            ScrollView {
                VStack(
                    alignment: .leading,
                    spacing: 15
                ) {
                    SimpleHeader(localizationKey: "settings", imageName: "gearshape.2.fill", separatorColor: Colors.brownOrange)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Colors.brownOrange)
                            .frame(maxWidth: .infinity, minHeight: 50)
                        
                        VStack(alignment: .leading) {
                            Text("**default location:**")
                            
                            HStack {
                                Toggle(
                                    isOn: viewStore.binding(
                                        get: { $0.userSettings.defaultLocationSetting == .lastSelected },
                                        send: SettingsReducer.Action.lastSelectedToggled
                                    ),
                                    label: {
                                        Text("last selected")
                                    }
                                )
                            }
                            
                            // if viewStore.defaultLocationSetting != .lastSelected {
                            // these will be unique for sure
                            if viewStore.userSettings.defaultLocationSetting != .lastSelected {
                                ForEach(viewStore.locations.sorted(), id: \.self) { loc in
                                    VStack {
                                        HStack {
                                            Text(loc)
                                            Spacer()
                                            if viewStore.selectedLocation == loc {
                                                Circle()
                                                    .fill(Colors.paleOrange)
                                                    .frame(width: 20, height: 20)
                                            }
                                        }
                                        Divider()
                                            .overlay(Colors.paleYellow)
                                    }
                                    .background(Colors.brownOrange)
                                    .frame(maxWidth: .infinity, maxHeight: 50)
                                    .onTapGesture {
                                        viewStore.send(.locationSelected(loc))
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding([.all], 15)
                        .foregroundColor(Colors.offWhite)
                    }
                    .frame(maxWidth: .infinity)
                }
                .foregroundColor(Colors.brownOrange)
                .padding([.leading, .trailing], 28)
                .padding([.top], 40)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                
            }
            .onAppear() {
                viewStore.send(.loadLocations)
            }
        }
        .background(Colors.paleYellow)
    }
}

struct SettingsViewPreview: PreviewProvider {
    static var previews: some View {
        SettingsView(
            store: Store(initialState: SettingsReducer.State(userSettings: UserSettings.createDefault())) {
                SettingsReducer()
            }
        )
    }
}

