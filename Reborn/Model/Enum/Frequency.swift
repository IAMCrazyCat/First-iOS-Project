//
//  Frequency.swift
//  Reborn
//
//  Created by Christian Liu on 28/2/21.
//

import Foundation
import UIKit
enum Frequency: Int, CaseIterable, Codable {

    case everyday
    case everyTwoDays
    case everyThreeDays
    case everyFourDays
    case everyFiveDays
    case everySixDays
    case everyWeek
    case everyTwoWeeks
    case everyThreeWeeks
    case everyMonth
    case freedom
    
    var dataModel: DataModel {
        switch self {
        case .everyday: return DataModel(title: "每天", data: 1)
        case .everyTwoDays: return DataModel(title: "每两天", data: 2)
        case .everyThreeDays: return DataModel(title: "每三天", data: 3)
        case .everyFourDays: return DataModel(title: "每四天", data: 4)
        case .everyFiveDays: return DataModel(title: "每五天", data: 5)
        case .everySixDays: return DataModel(title: "每六天", data: 6)
        case .everyWeek: return DataModel(title: "每周", data: 7)
        case .everyTwoWeeks: return DataModel(title: "每两周", data: 14)
        case .everyThreeWeeks: return DataModel(title: "每三周", data: 21)
        case .everyMonth: return DataModel(title: "每月", data: 30)
        case .freedom: return DataModel(title: "自由打卡", data: 0)
        }
    }
    
}
