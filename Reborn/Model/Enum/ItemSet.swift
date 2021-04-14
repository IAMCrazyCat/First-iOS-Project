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
    
    var priority: Int {
        switch self {
        case .inProgress: return 1
        case .duringBreak: return 3
        case .completed: return 2
        }
    }
}

enum ItemType: String, CaseIterable, Codable {
    case undefined = ""
    case quitting = "戒除"
    case persisting = "坚持"
    
    var priority: Int {
        switch self {
        case .quitting: return 2
        case .persisting: return 1
        default: return 10
        }
    }
}
