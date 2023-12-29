//
//  RealmLastSessionValues.swift
//  PSUArboretum
//
//  Created by calvin on 12/29/23.
//

import Foundation
import RealmSwift

class RealmLastSessionValues: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var lastSelectedLocation: String?
    
    convenience init(id: ObjectId, lastSelectedLocation: String?) {
        self.init()
        self.id = id;
        self.lastSelectedLocation = lastSelectedLocation
    }
    convenience init(lastSelectedLocation: String?) {
        self.init()
        self.id = ObjectId.generate()
        self.lastSelectedLocation = lastSelectedLocation
    }
}

