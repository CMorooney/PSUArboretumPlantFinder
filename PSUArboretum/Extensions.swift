//
//  Extensions.swift
//  PSUArboretum
//
//  Created by calvin on 12/26/23.
//

import Combine
import Foundation
import MapKit
import SwiftUI
import RealmSwift
import ComposableArchitecture

extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}

extension String {
  var isBlank: Bool {
    return allSatisfy({ $0.isWhitespace })
  }
}

extension MapCameraBounds: Equatable {
    public static func == (lhs: MapCameraBounds, rhs: MapCameraBounds) -> Bool {
        // good enough for our specific use case, honestly
        return true
    }
}

extension MKMapRect {
    init(arboretumFeatures: [ArboretumFeature]) {
        self = arboretumFeatures
            .map({ MKMapRect(origin: MKMapPoint(CLLocationCoordinate2D(
                                                    latitude: $0.latitude,
                                                    longitude: $0.longitude)),
                             size: MKMapSize(width: 0, height: 0)) })
            .reduce(MKMapRect.null, { $0.union($1) })
    }
}

extension Realm {
    func save<T: Object>(_ object: T) -> Effect<Signal> {
        let p = Future<Signal, Never>() { promise in
            do {
                try self.write {
                    self.create(T.self, value: object, update: .modified)
                }
                return promise(.success(.success))
            } catch {
                return promise(.success(.failure(ArboretumError.writeDatabaseError)))
            }
        }
        return Effect.publisher(p.eraseToAnyPublisher)
    }
    
    func save<T: Object>(_ objects: [T]) -> Effect<Signal> {
        let p = Future<Signal, Never> { promise in
            do {
                try self.write {
                    self.add(objects, update: .modified)
                }
                return promise(.success(.success))
            } catch {
                return promise(.success(.failure(ArboretumError.writeDatabaseError)))
            }
        }
        
        return Effect.publisher(p.eraseToAnyPublisher)
    }
    
    func fetch<T: Object>(_ type: T.Type, predicate: NSPredicate? = nil) -> Effect<Results<T>> {
        let p = Future<Results<T>, Never> { promise in
            let objects = self.objects(type)
            if let predicate = predicate {
                promise(.success(objects.filter(predicate)))
                return
            }
            promise(.success(objects))
        }
        return Effect.publisher(p.eraseToAnyPublisher)
    }
}
