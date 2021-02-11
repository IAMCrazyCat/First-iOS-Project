//
//  ItemType.swift
//  Reborn
//
//  Created by Christian Liu on 25/12/20.
//

import Foundation
enum ItemType: String, CaseIterable, Codable {
    case undefined = ""
    case quitting = "戒除"
    case persisting = "坚持"
}
