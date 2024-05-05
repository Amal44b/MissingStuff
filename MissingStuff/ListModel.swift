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
    var name : String
    var items : [String]
    var location : String
    var subLocation : String
    var isCompleted = Bool()
    
    init(name: String = "", items: [String] = [] , location: String = "", subLocation: String = "", isCompleted: Bool = false) {
        self.name = name
        self.items = items
        self.location = location
        self.subLocation = subLocation
        self.isCompleted = isCompleted
    }
}
