//
//  ArboEsriData.swift
//  PSUArboretum
//
//  Created by calvin on 9/16/23.
//

import Foundation

struct ArboEsriData: Codable, Equatable {
    enum CodeingKeys: String, CodingKey {
        case objectIdFieldName
        case globalIdFieldName
        case geometryType
        case spatialReference
        case fields
        case features
    }
    
    var objectIdFieldName: String
    var globalIdFieldName: String
    var geometryType: String
    var spatialReference: SpatialReference;
    var fields: [Field]
    var features: [Feature]
}

struct SpatialReference: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case wkid
        case latestWkid
    }
    
    var wkid: Int
    var latestWkid: Int
}

struct Field: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case name
        case alias
        case type
        case length
    }
    
    var name: String
    var alias: String
    var type: String
    var length: Int?
}

struct Feature: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case attributes
        case geometry
    }
    
    var attributes: ArboretumFeature
    var geometry: Geometry
}

struct Geometry: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case x, y
    }
    var x: Double
    var y: Double
}
