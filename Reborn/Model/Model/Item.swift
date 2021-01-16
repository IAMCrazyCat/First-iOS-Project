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
    var creationDate: CustomDate
    var type: ItemType
    var punchInDate: Array<CustomDate> = []
    var frequency: DataOption? = nil
    
    init(name: String, days: Int, finishedDays: Int, creationDate: CustomDate, type: ItemType) {
        self.name = name
        self.days = days
        self.finishedDays = finishedDays
        self.creationDate = creationDate
        self.type = type
    }
    
    func punchIn(punchInDate: CustomDate) {
        self.punchInDate.append(punchInDate)
        self.finishedDays += 1
    }
    
    func setFreqency(frequency: DataOption) {
        self.frequency = frequency
    }
}
