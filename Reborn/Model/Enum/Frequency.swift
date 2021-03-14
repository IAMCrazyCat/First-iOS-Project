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
    
    var dataModel: CustomData {
        switch self {
        case .everyday: return CustomData(title: "每天", data: 1)
        case .everyTwoDays: return CustomData(title: "每两天", data: 2)
        case .everyThreeDays: return CustomData(title: "每三天", data: 3)
        case .everyFourDays: return CustomData(title: "每四天", data: 4)
        case .everyFiveDays: return CustomData(title: "每五天", data: 5)
        case .everySixDays: return CustomData(title: "每六天", data: 6)
        case .everyWeek: return CustomData(title: "每周", data: 7)
        case .everyTwoWeeks: return CustomData(title: "每两周", data: 14)
        case .everyThreeWeeks: return CustomData(title: "每三周", data: 21)
        case .everyMonth: return CustomData(title: "每月", data: 30)
        case .freedom: return CustomData(title: "自由打卡", data: 0)
        }
    }
    
}
