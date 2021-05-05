//
//  CustomTime.swift
//  Reborn
//
//  Created by Christian Liu on 14/3/21.
//

import Foundation
class CustomTime: NSObject, NSCoding, Comparable {
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
    

   
    
   
}

