//
//  SettingsReducer.swift
//  PSUArboretum
//
//  Created by calvin on 12/29/23.
//

import Foundation
import ComposableArchitecture
import SwiftUI
import RealmSwift

@Reducer
struct SettingsReducer {
    let environment = Environment()
    
    struct State: Equatable {
        var userSettings: UserSettings = UserSettings.createDefault()
        var realmSettingsId: ObjectId?
        var locations: Set<String> = Set()
        var selectedLocation: String?
    }
    
    enum Action: Equatable {
        case none
        case loadLocations
        case locationsLoaded(Set<String>)
        
        case loadUserSettings
        case userSettingsLoaded(RealmUserSettings?)
        
        case lastSelectedToggled(Bool)
        case locationSelected(String?)
    }
    
    struct Environment {
        let realm: Realm
        
        init() {
            self.realm = try! Realm()
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .none: return .none
                    
                case .loadLocations:
                    return environment.realm
                        .fetch(
                            RealmArboretumFeature.self
                        )
                        .map { objects -> Action in
                            return .locationsLoaded(Set(objects.map { $0.location }))
                        }
                    
                case .locationsLoaded(let locations):
                    state.locations = locations
                    state.selectedLocation = state.locations.first
                    return .send(.loadUserSettings)
                    
                case .loadUserSettings:
                    return environment.realm
                        .fetch(
                            RealmUserSettings.self
                        ).map { objects -> Action in
                            return .userSettingsLoaded(objects.first)
                        }
                    
                case .userSettingsLoaded(let settings):
                    if let settings {
                        state.realmSettingsId = settings.id
                        state.userSettings = UserSettings(from: settings)
                        switch state.userSettings.defaultLocationSetting {
                            case .lastSelected:
                                state.selectedLocation = state.locations.first
                                break;
                            case .specific(let s):
                                if state.locations.contains(s) {
                                    state.selectedLocation = s
                                }
                        }
                    }
                    return .none
                    
                case .lastSelectedToggled(let on):
                    if on {
                        state.userSettings.defaultLocationSetting = .lastSelected
                    } else if let s = state.selectedLocation, state.locations.contains(s) {
                        state.userSettings.defaultLocationSetting = .specific(s)
                    }
                    
                    if let realmId = state.realmSettingsId {
                        return environment.realm.save(RealmUserSettings(
                            defaultLocationOption: state.userSettings.defaultLocationSetting,
                            id: realmId))
                        .map { signal in
                            return .none
                        }
                    } else {
                        return environment.realm.save(
                            RealmUserSettings(defaultLocationOption: state.userSettings.defaultLocationSetting))
                        .map { signal in
                            return .none
                        }
                    }
                    
                case .locationSelected(let newSelection):
                    state.selectedLocation = newSelection
                    
                    if let selection = newSelection, state.locations.contains(selection) {
                        state.userSettings.defaultLocationSetting = .specific(selection)
                    } else {
                        state.userSettings.defaultLocationSetting = .lastSelected
                    }
                    
                    if let realmId = state.realmSettingsId {
                        return environment.realm.save(RealmUserSettings(
                            defaultLocationOption: state.userSettings.defaultLocationSetting,
                            id: realmId))
                        .map { signal in
                            return .none
                        }
                    } else {
                        return environment.realm.save(
                            RealmUserSettings(defaultLocationOption: state.userSettings.defaultLocationSetting))
                        .map { signal in
                            return .none
                        }
                    }
            }
        }
    }
}
