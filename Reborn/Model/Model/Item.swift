//
//  Item.swift
//  Reborn
//
//  Created by Christian Liu on 19/12/20.
//


import Foundation
class Item: Codable {
    var name: String
    var targetDays: Int
    var finishedDays: Int
    var creationDate: CustomDate
    var type: ItemType
    var punchInDates: Array<CustomDate> = []
    var frequency: DataOption
    
    var progress: Double {
        return Double(self.finishedDays) / Double(self.targetDays)
    }
    
    var progressInPercentageString: String {
        return String(format: "%.1f", progress * 100) + " %"
    }
    
    init(name: String, days: Int, finishedDays: Int, frequency: DataOption, creationDate: CustomDate, type: ItemType) {
        self.name = name
        self.targetDays = days
        self.finishedDays = finishedDays
        self.creationDate = creationDate
        self.type = type
        self.frequency = frequency
    }
    
    func punchIn(punchInDate: CustomDate) {
        self.punchInDates.append(punchInDate)
        self.finishedDays += 1
    }
    
    
}
