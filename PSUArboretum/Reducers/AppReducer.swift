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
        var loadingESRIData: Bool = false
        var selectedTab = Tab.map
        
        var mapState = MapReducer.State()
    }
    
    enum Action {
        case none
        case tabSelected(Tab)
        case map(MapReducer.Action)
        case loadData
        case dataLoadBegan
        case dataLoadFailed
        case dataLoadSucceeded([ArboretumFeature])
    }
    
    struct Environment {
        let realm: Realm
        let scheduler: AnySchedulerOf<DispatchQueue>
        
        init(_ scheduler: AnySchedulerOf<DispatchQueue> = AnyScheduler.main) {
            self.realm = try! Realm()
            self.scheduler = scheduler
        }
    }
    
    enum Tab {
        case map
    }
    
    let environment = Environment()
    
    var body: some Reducer<State, Action> {
        Scope(state: \.mapState, action: /AppReducer.Action.map) {
            MapReducer()
        }
        Reduce { state, action in
            switch action {
                case .none, .map:
                    return .none
                case .tabSelected(let tab):
                    state.selectedTab = tab
                    return .none
                case .loadData:
                    return .run { send in
                        await send(.dataLoadBegan)
                        let data = DataReader.loadData();
                        await send(.dataLoadSucceeded(data))
                    }
                case .dataLoadBegan:
                    state.loadingESRIData = true
                    return .none
                case .dataLoadFailed:
                    state.loadingESRIData = true
                    return .none
                case .dataLoadSucceeded(let newFeatures):
                    state.loadingESRIData = false
                    let asRealmData = newFeatures.map { f in RealmArboretumFeature(f) }
                    return environment.realm.save(asRealmData).map { signal in
                        switch signal {
                            case .success:
                                return .none
                            case .failure(_):
                                // todo: log or alert
                                return .none
                        }
                    }
            }
        }
    }
}
