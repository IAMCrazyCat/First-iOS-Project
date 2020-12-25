//
//  Item.swift
//  Reborn
//
//  Created by Christian Liu on 19/12/20.
//
enum Type {
    case quitting
    case persisting
}

import Foundation
class Item: Codable {
    var name: String
    var days: Int
    var finishedDays: Int
    var creationDate: Date

    init(name: String, days: Int, finishedDays: Int, creationDate: Date) {
        self.name = name
        self.days = days
        self.finishedDays = finishedDays
        self.creationDate = creationDate
    }
}
