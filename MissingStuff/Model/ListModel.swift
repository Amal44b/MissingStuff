//
//  ListModel.swift
//  MissingStuff
//
//  Created by Maryam Mohammad on 20/10/1445 AH.
//


import Foundation
import MapKit
import SwiftData

@Model
class ListModel{
    var CheckID: String = UUID().uuidString
    var name: String
    var items: [String]
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var isCompleted = Bool()
    
    init(name: String = "", items: [String] = [], latitude: CLLocationDegrees = 0.0, longitude: CLLocationDegrees = 0.0 , isCompleted: Bool = false) {
        self.name = name
        self.items = items
        self.latitude = latitude
        self.longitude = longitude
        self.isCompleted = isCompleted
    }
}
