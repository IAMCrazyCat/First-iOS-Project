//
//  ItemType.swift
//  Reborn
//
//  Created by Christian Liu on 25/12/20.
//

import Foundation
enum ItemType: String, CaseIterable, Codable {
    case UNDEFINED = ""
    case QUITTING = "戒除"
    case PERSISTING = "坚持"
}
