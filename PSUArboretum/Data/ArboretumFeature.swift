//
//  ArboretumFeature.swift
//  PSUArboretum
//
//  Created by calvin on 9/16/23.
//

import Foundation

struct ArboretumFeature: Codable, Identifiable, Equatable {
    enum CodingKeys: String, CodingKey {
        case accession = "Accession"
        case taxonName = "Taxon_Name"
        case commonName = "Common_Nam"
        case states = "Status"
        case condition = "Condition"
        case numberOf = "Number_of"
        case location = "Location"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case taxonDist = "Taxon_Dist"
        case lifeForm = "Life_Form"
        case picture = "Picture"
        case picture2 = "Picture2"
        case picture3 = "Picture3"
        case picture4 = "Picture4"
        case picture5 = "Picture5"
        case accYear = "AccYear"
        case accNo = "AccNo"
        case itemNo = "ItemNo"
        case itemCoordX = "ItemCoordX"
        case itemCoordY = "ItemCoordY"
        case accNoFull = "AccNoFull"
        case itemAccNoF = "ItemAccNoF"
        case itemLocation = "ItemLocati"
        case itemSpecCo = "ItemSpecCo"
        case taxonDistr = "TaxonDistr"
        case itemCondition = "ItemCondit"
        case itemStatus = "ItemStatus"
        case itemCoordinate1 = "ItemCoor_1"
        case itemCoordinate2 = "ItemCoor_2"
        case family = "Family"
        case genus = "Genus"
        case objectId = "OBJECTID"
        case f14 = "F14"
    }
    
    var id: Int { objectId }
    
    var accession: String
    var taxonName: String
    var commonName: String
    var states: String
    var condition: String
    var numberOf: String
    var location: String
    var latitude: Double
    var longitude: Double
    var taxonDist: String
    var lifeForm: String
    var picture: String
    var picture2: String
    var picture3: String
    var picture4: String
    var picture5: String
    var accYear: String
    var accNo: String
    var itemNo: String
    var itemCoordX: Double
    var itemCoordY: Double
    var accNoFull: String
    var itemAccNoF: String
    var itemLocation: String
    var itemSpecCo: String
    var taxonDistr: String
    var itemCondition: String
    var itemStatus: String
    var itemCoordinate1: Double
    var itemCoordinate2: Double
    var family: String
    var genus: String
    var objectId: Int
    var f14: String
}
