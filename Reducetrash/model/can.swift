//
//  can.swift
//  Reducetrash
//
//  Created by taha majdoub on 7/4/2023.
//

import Foundation
import MapKit
struct Can: Codable {
    var latitude: Double
    var longitude: Double
    var tid: Int
    var commodityWasteSeparated: String
    var owner: String?
    var name: String
    var street: String?
    var cp: Int
    var isPublic: String?
    var typeWasteSeparated: String?
   
        
        func toAnnotation() -> CanAnnotation {
            let annotation = CanAnnotation(
                
                         coordinate: CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude),
                         title: self.name,
                         subtitle: self.street,
                         can: self
                     )
            annotation.can = self
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotation.title = name
            annotation.subtitle = street
            return annotation
            
        }
    }


