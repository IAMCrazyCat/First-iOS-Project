//
//  PersistingItem.swift
//  Reborn
//
//  Created by Christian Liu on 19/12/20.
//

import Foundation
class PersistingItem: Item {
    init(ID: Int, name: String, days: Int, finishedDays: Int, frequency: DataOption, creationDate: CustomDate) {
        super.init(ID: ID, name: name, days: days, finishedDays: finishedDays, frequency: frequency, creationDate: creationDate, type: .persisting)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
}
