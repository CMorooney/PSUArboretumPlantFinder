//
//  App.swift
//  PSUArboretum
//
//  Created by calvin on 12/27/23.
//

import Foundation
import RealmSwift
import ComposableArchitecture

@Reducer
struct AppReducer {
    struct State: Equatable {
        var loadingMapData: Bool = false
        var selectedTab = Tab.map
        
        var mapState = MapReducer.State()
        var settingsState = SettingsReducer.State()
    }
    
    enum Action {
        case none
        case tabSelected(Tab)
        case map(MapReducer.Action)
        case settings(SettingsReducer.Action)
        
        case loadData
        
        case loadMapData
        case mapDataLoadBegan
        case mapDataLoadFailed
        case mapDataLoadSucceeded([ArboretumFeature])
    }
    
    struct Environment {
        let realm: Realm
        let scheduler: AnySchedulerOf<DispatchQueue>
        
        init(_ scheduler: AnySchedulerOf<DispatchQueue> = AnyScheduler.main) {
            let config = Realm.Configuration(schemaVersion: 2)
            Realm.Configuration.defaultConfiguration = config
            self.realm = try! Realm()
            self.scheduler = scheduler
        }
    }
    
    enum Tab: Equatable {
        case map
        case about
        case settings
    }
    
    let environment = Environment()
    
    var body: some Reducer<State, Action> {
        Scope(state: \.mapState, action: /AppReducer.Action.map) {
            MapReducer()
        }
        Scope(state: \.settingsState, action: /AppReducer.Action.settings) {
            SettingsReducer()
        }
        Reduce { state, action in
            switch action {
                case .none, .settings, .map:
                    return .none
                case .tabSelected(let tab):
                    state.selectedTab = tab
                    return .none
                    
                case .loadData:
                    // this will all happen serially for now
                    // i.e, the end of the loadMapData Action logic
                    // should invoke loading user settings
                    return .send(.loadMapData)
                    
                case .loadMapData:
                    return .run { send in
                        await send(.mapDataLoadBegan)
                        let data = DataReader.loadData();
                        await send(.mapDataLoadSucceeded(data))
                    }
                case .mapDataLoadBegan:
                    state.loadingMapData = true
                    return .none
                case .mapDataLoadFailed:
                    state.loadingMapData = false
                    return .none
                case .mapDataLoadSucceeded(let newFeatures):
                    state.loadingMapData = false
                    
                    let asRealmData = newFeatures.map { f in RealmArboretumFeature(f) }
                    return environment.realm.save(asRealmData).map { signal in
                        return .none
                    }
            }
        }
    }
}
