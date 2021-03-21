//
//  ItemState.swift
//  Reborn
//
//  Created by Christian Liu on 17/2/21.
//

import Foundation

enum ItemState: String, Codable {
    case inProgress
    case duringBreak
    case completed
}

enum ItemType: String, CaseIterable, Codable {
    case undefined = ""
    case quitting = "戒除"
    case persisting = "坚持"
}
