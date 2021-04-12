//
//  CustomTime.swift
//  Reborn
//
//  Created by Christian Liu on 14/3/21.
//

import Foundation
class CustomTime: NSObject, NSCoding {
    
    var hour: Int
    var minute: Int
    var second: Int

    public static var current: CustomTime {
        let date = Date()
        let currentHour: Int = Calendar.current.component(.hour, from: date)
        let currentMinute: Int = Calendar.current.component(.minute, from: date)
        let currentSecond: Int = Calendar.current.component(.second, from: date)
        return CustomTime(hour: currentHour, minute: currentMinute, second: currentSecond)
    }
    
    init(hour: Int, minute: Int, second: Int) {
        self.hour = hour
        self.minute = minute
        self.second = second
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(hour, forKey: "Hour")
        coder.encode(minute, forKey: "Minute")
        coder.encode(second, forKey: "Second")
    }
    
    required convenience init?(coder: NSCoder) {
        let hour = coder.decodeInteger(forKey: "Hour")
        let minute = coder.decodeInteger(forKey: "Minute")
        let second = coder.decodeInteger(forKey: "Second")
        self.init(hour: hour, minute: minute, second: second)
    }
    

   
    
   
}

