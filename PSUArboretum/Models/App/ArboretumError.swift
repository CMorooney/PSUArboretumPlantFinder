//
//  ArboretumError.swift
//  PSUArboretum
//
//  Created by calvin on 12/27/23.
//

import Foundation

enum ArboretumError: Error, Equatable {
    static func == (lhs: ArboretumError, rhs: ArboretumError) -> Bool {
        true
    }

    case writeDatabaseError
    case unknown(Error)
}
