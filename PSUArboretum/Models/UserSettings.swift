//
//  UserSettings.swift
//  PSUArboretum
//
//  Created by calvin on 12/29/23.
//

import Foundation
import RealmSwift

struct UserSettings: Equatable {
    var defaultLocationSetting: DefaultLocationOption
    
    // prefer to use `createDefault` extension
    fileprivate init(with locationSetting: DefaultLocationOption = .lastSelected) {
        defaultLocationSetting = locationSetting
    }
    
    init(from realmSettings: RealmUserSettings) {
        defaultLocationSetting = realmSettings.defaultLocationOption
    }
}

extension UserSettings {
    static func createDefault() -> UserSettings {
        UserSettings()
    }
}

enum DefaultLocationOption: CustomPersistable, Equatable {
    static let lastSelectedIdentifier = "lastSelected"
    
    var displayString: String {
        switch self {
            case .lastSelected:
                return String(localized: LocalizedStringResource("last selected"))
            case .specific(let v):
                return v
        }
    }
    
    init(persistedValue: String) {
        if persistedValue == DefaultLocationOption.lastSelectedIdentifier {
            self = .lastSelected
        } else {
            self = .specific(persistedValue)
        }
    }
    
    var persistableValue: String {
        switch self {
            case .lastSelected:
                return DefaultLocationOption.lastSelectedIdentifier
            case .specific(let name):
                return name
        }
    }
    
    typealias PersistedType = String
    
    case lastSelected
    case specific(String)
}

