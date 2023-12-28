//
//  RealmArboretumFeature.swift
//  PSUArboretum
//
//  Created by calvin on 12/27/23.
//

import Foundation
import RealmSwift

class RealmArboretumFeature: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var latitude: Double = 0.0
    @Persisted var longitude: Double = 0.0
    @Persisted var commonName: String = ""
    @Persisted var family: String = ""
    @Persisted var genus: String = ""
    @Persisted var lifeForm: String = ""
    @Persisted var states: String = ""
    @Persisted var picture: String = ""
    @Persisted var location: String = ""
    
    convenience init(_ feature: ArboretumFeature) {
        self.init()
        id = feature.id
        latitude = feature.latitude
        longitude = feature.longitude
        commonName = feature.commonName
        family = feature.family
        genus = feature.genus
        lifeForm = feature.lifeForm
        states = feature.states
        picture = feature.picture
        location = feature.location
    }
    
    /// the `picture` field is HTML link tag wrapped around an image tag,
    /// call this to get just the URL referenced by the `<img>` tag within  `picture`
    func getScrapedImage() -> String? {
        let regex = /<img[^>]src="([^"]+)"[^>l]*>/
        if let match = picture.firstMatch(of: regex) {
            return String(match.1)
        }
        return nil
    }
}
