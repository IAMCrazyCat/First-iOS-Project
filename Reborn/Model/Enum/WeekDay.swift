//
//  Day.swift
//  Reborn
//
//  Created by Christian Liu on 28/12/20.
//

import Foundation
enum WeekDay: Int, Codable {
    case Monday = 1
    case Tuesday = 2
    case Wednesday = 3
    case Thursday = 4
    case Friday = 5
    case Saturday = 6
    case Sunday = 7
    
     var str: String {
        switch self {
        case .Monday: return "星期一"
        case .Tuesday: return "星期二"
        case .Wednesday: return "星期三"
        case .Thursday: return "星期四"
        case .Friday: return "星期五"
        case .Saturday: return "星期六"
        case .Sunday: return "星期天"
        }
    }
    
}

