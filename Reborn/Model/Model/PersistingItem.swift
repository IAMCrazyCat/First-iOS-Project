//
//  PersistingItem.swift
//  Reborn
//
//  Created by Christian Liu on 19/12/20.
//

import Foundation
class PersistingItem: Item {
    init(name: String, days: Int, finishedDays: Int, creationDate: CustomDate) {
        super.init(name: name, days: days, finishedDays: finishedDays, creationDate: creationDate, type: .persisting)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
}
