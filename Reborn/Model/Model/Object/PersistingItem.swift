//
//  PersistingItem.swift
//  Reborn
//
//  Created by Christian Liu on 19/12/20.
//

import Foundation
class PersistingItem: Item {
    init(ID: Int, name: String, days: Int, frequency: NewFrequency, creationDate: CustomDate) {
        super.init(ID: ID, name: name, days: days, frequency: frequency, creationDate: creationDate, type: .persisting, icon: Icon.defaultIcon1, notificationTimes: [CustomTime]())
    }
    
    required init(from decoder: Decoder) throws {
        print("Decoding PersistingItem")
        try super.init(from: decoder)
    }
    
}
