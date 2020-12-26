//
//  Item.swift
//  Reborn
//
//  Created by Christian Liu on 19/12/20.
//


import Foundation
class Item: Codable {
    var name: String
    var days: Int
    var finishedDays: Int
    var creationDate: Date
    var type: ItemType

    init(name: String, days: Int, finishedDays: Int, creationDate: Date, type: ItemType) {
        self.name = name
        self.days = days
        self.finishedDays = finishedDays
        self.creationDate = creationDate
        self.type = type
    }
    
}
