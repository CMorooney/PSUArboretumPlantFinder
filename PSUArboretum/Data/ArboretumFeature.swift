//
//  ArboretumFeature.swift
//  PSUArboretum
//
//  Created by calvin on 9/16/23.
//

import Foundation
import RealmSwift

struct ArboretumFeature: Codable, Identifiable, Equatable {
    enum CodingKeys: String, CodingKey {
        case commonName = "Common_Nam"
        case states = "Status"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case lifeForm = "Life_Form"
        case picture = "Picture"
        case family = "Family"
        case genus = "Genus"
        case objectId = "OBJECTID"
        case location = "Location"
    }
    
    var id: Int { objectId }
    
    var commonName: String
    var states: String
    var latitude: Double
    var longitude: Double
    var lifeForm: String
    var picture: String
    var family: String
    var genus: String
    var objectId: Int
    var location: String
    
    init(_ feature: RealmArboretumFeature) {
        objectId = feature.id
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
