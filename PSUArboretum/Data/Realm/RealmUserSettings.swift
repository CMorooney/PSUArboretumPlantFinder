//
//  RealmUserSettings.swift
//  PSUArboretum
//
//  Created by calvin on 12/29/23.
//

import Foundation
import RealmSwift

class RealmUserSettings: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var defaultLocationOption: DefaultLocationOption = .lastSelected
    
    convenience init(defaultLocationOption: DefaultLocationOption = .lastSelected) {
        self.init()
        self.id = ObjectId.generate()
        self.defaultLocationOption = defaultLocationOption
    }
    
    convenience init(defaultLocationOption: DefaultLocationOption = .lastSelected, id: ObjectId) {
        self.init()
        self.id = id
        self.defaultLocationOption = defaultLocationOption
    }
}
