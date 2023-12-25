//
//  DataReader.swift
//  PSUArboretum
//
//  Created by calvin on 9/16/23.
//

import Foundation

class DataReader: ObservableObject  {
    static func loadData() -> [ArboretumFeature]  {
        guard let url = Bundle.main.url(forResource: "raw", withExtension: "json")
        else {
            print("Json file not found")
            return []
        }
        
        guard let data = try? Data(contentsOf: url)
        else {
            print("Json file not readable")
            return []
        }
        
        do {
            let decoded = try JSONDecoder().decode(ArboEsriData.self, from: data)
            return decoded.features.map(\.attributes)
        } catch(let error) {
            print(error)
            return []
        }
    }
}
