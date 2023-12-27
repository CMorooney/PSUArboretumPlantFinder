//
//  Signal.swift
//  PSUArboretum
//
//  Created by calvin on 12/27/23.
//

import Foundation

enum Signal: Equatable {
    case success
    case failure(ArboretumError)
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        true
    }
}
