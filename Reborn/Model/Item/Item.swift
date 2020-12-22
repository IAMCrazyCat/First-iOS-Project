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
class Item: NSObject {
    var name: String
    var days: Int
    var creationDate: Date
    init(name: String, days: Int, creationDate: Date) {
        self.name = name
        self.days = days
        self.creationDate = creationDate
    }
}
