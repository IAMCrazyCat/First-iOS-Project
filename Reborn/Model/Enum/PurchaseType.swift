//
//  PurchaseType.swift
//  Reborn
//
//  Created by Christian Liu on 3/5/21.
//

import Foundation
enum PurchaseType: String, Codable {
    case permanent
    case oneMonth
    case oneYear
    case energy
    case none

    var productID: String {
        switch self {
        case .oneMonth: return "com.crazycat.Reborn.OneMonthVip"
        case .oneYear: return "com.crazycat.Reborn.OneYearVip"
        case .permanent: return "com.crazycat.Reborn.PermanentVip"
        case .energy: return "com.crazycat.Reborn.threePointOfEnergy"
        case .none: return ""
        }
    }
    
    var packageIdentifier: String {
        switch self {
        case .oneMonth: return "Monthly"
        case .oneYear: return "Annual"
        case .permanent: return "Lifetime"
        case .energy: return "Energy"
        case .none: return ""
        }
    }
}
