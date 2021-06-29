//
//  CustomTime.swift
//  Reborn
//
//  Created by Christian Liu on 14/3/21.
//

import Foundation
class CustomTime: NSObject, NSCoding, Comparable, Codable {
    static func < (lhs: CustomTime, rhs: CustomTime) -> Bool {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH mm ss.SSSS"

        let lhsDate = formatter.date(from: "\(lhs.hour) \(lhs.minute) \(lhs.second).\(lhs.oneTenthSecond * 100)")!
        let rhsDate = formatter.date(from: "\(rhs.hour) \(rhs.minute) \(rhs.second).\(rhs.oneTenthSecond * 100)")!
        
        return lhsDate < rhsDate
    }
    
    
    
    
    var hour: Int
    var minute: Int
    var second: Int
    var oneTenthSecond: Int
    
    var timeRange: TimeRange {
        
        switch self.hour {
        case 0 ..< 6: return .midnight
        case 6 ..< 12: return .morning
        case 12 ..< 15: return .noon
        case 15 ..< 18: return .afternoon
        case 18 ..< 24: return .night
        default: return .morning
        }
    }

    public static var current: CustomTime {
        let date = Date()
        let currentHour: Int = Calendar.current.component(.hour, from: date)
        let currentMinute: Int = Calendar.current.component(.minute, from: date)
        let currentSecond: Int = Calendar.current.component(.second, from: date)
        let currentOneTenthSecond: Int = Calendar.current.component(.nanosecond, from: date) / 100000000
        return CustomTime(hour: currentHour, minute: currentMinute, second: currentSecond, oneTenthSecond: currentOneTenthSecond)
    }
    
    init(hour: Int, minute: Int, second: Int, oneTenthSecond: Int) {
        self.hour = hour
        self.minute = minute
        self.second = second
        self.oneTenthSecond = oneTenthSecond
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(hour, forKey: "Hour")
        coder.encode(minute, forKey: "Minute")
        coder.encode(second, forKey: "Second")
        coder.encode(oneTenthSecond, forKey: "OneTenthSecond")
    }
    
    required convenience init?(coder: NSCoder) {
        let hour = coder.decodeInteger(forKey: "Hour")
        let minute = coder.decodeInteger(forKey: "Minute")
        let second = coder.decodeInteger(forKey: "Second")
        let oneTenthSecond = coder.decodeInteger(forKey: "OneTenthSecond")
        self.init(hour: hour, minute: minute, second: second, oneTenthSecond: oneTenthSecond)
    }
    
    
    func getTimeString() -> String {
        var str = ""
        if hour < 10 {
            str += "0\(hour)"
        } else {
            str += "\(hour)"
        }
        
        str += ":"
        
        if minute < 10 {
            str += "0\(minute)"
        } else {
            str += "\(minute)"
        }
        return str
    }

   
    
   
}

