//
//  Day.swift
//  Reborn
//
//  Created by Christian Liu on 28/12/20.
//

import Foundation
enum WeekDay: Int, CaseIterable, Codable {
    case Monday = 1
    case Tuesday = 2
    case Wednesday = 3
    case Thursday = 4
    case Friday = 5
    case Saturday = 6
    case Sunday = 7
    
     var name: String {
        switch self {
        case .Monday: return "周一"
        case .Tuesday: return "周二"
        case .Wednesday: return "周三"
        case .Thursday: return "周四"
        case .Friday: return "周五"
        case .Saturday: return "周六"
        case .Sunday: return "周日"
        }
    }
    
    var shortName: String{
        switch self {
        case .Monday: return "一"
        case .Tuesday: return "二"
        case .Wednesday: return "三"
        case .Thursday: return "四"
        case .Friday: return "五"
        case .Saturday: return "六"
        case .Sunday: return "日"
        }
    }
    
    var originalWeekday: Int {
        let weekday = self.rawValue
        var originalWeekday = weekday + 1
        if originalWeekday > 7 {
            originalWeekday = 1
        }
        return originalWeekday
    }
    
}
