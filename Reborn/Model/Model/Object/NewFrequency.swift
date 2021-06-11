//
//  NewFrequency.swift
//  Reborn
//
//  Created by Christian Liu on 8/6/21.
//
import Foundation

enum NewFrequencyType: String, Codable {
    case everyDay
    case everyWeek
    case everyWeekdays
    case everyMonth
}


class NewFrequency: Codable {
    var type: NewFrequencyType
    
    init(type: NewFrequencyType) {
        self.type = type
    }
    
    func getFreqencyString() -> String {
        return ""
    }
    
    func getSpecificFreqencyString() -> String {
        return getFreqencyString()
    }
    
    func isCompletedInPeriod() -> Bool {
        return false
    }
}

class EveryDay: NewFrequency {
    private enum Key: String, CodingKey {
        case type
    }
    
    init() {
        super.init(type: .everyDay)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    override func getFreqencyString() -> String {
        return "每天"
    }
}

class EveryWeek: NewFrequency {
    var days: Int
    
    private enum Key: String, CodingKey {
        case days
    }
    
    init(days: Int) {
        self.days = days
        super.init(type: .everyWeek)
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        self.days = try container.decode(Int.self, forKey: .days)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(days, forKey: Key.days)
        try super.encode(to: encoder)
    }
    
    override func getFreqencyString() -> String {
        return "每周\(self.days)次"
    }
    
    
}

class EveryWeekdays: NewFrequency {
    var weekdays: Array<WeekDay>
    
    private enum Key: String, CodingKey {
        case weekdays
    }
    
    init(weekDays: Array<WeekDay>) {
        self.weekdays = weekDays
        super.init(type: .everyWeekdays)
        self.sortWeekdays()
    }
    
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: Key.self)
        self.weekdays = try container.decode(Array<WeekDay>.self, forKey: .weekdays)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(weekdays, forKey: .weekdays)
        try super.encode(to: encoder)
    }
    
    private func sortWeekdays() {
        weekdays.sort {
            $0.rawValue < $1.rawValue
        }
    }
    
    override func getFreqencyString() -> String {
        
        if weekdays.count == 2 && weekdays.contains(.Saturday) && weekdays.contains(.Sunday) {
            return "周末"
        }
        
        if weekdays.count == 5 && !weekdays.contains(.Saturday) && !weekdays.contains(.Sunday) {
            return "工作日"
        }
        
        if weekdays.count == 1 {
            return weekdays.first!.name
        }
        
        if weekdays.count > 1 && weekdays.count < 7 {
            
            var consecutive = true
            var day = weekdays.first!.rawValue
            for weekday in weekdays {
                if weekday.rawValue != day {
                    consecutive = false
                }
                day += 1
            }
            
            if consecutive {
                return "\(weekdays.first!.name) ~ \(weekdays.last!.name)"
            }
            
        }
        
        if weekdays.count > 1 && weekdays.count <= 3{
            var str = ""
            for weekday in weekdays {
                str += "\(weekday.name)、"
            }
        }
        
        
        return "每周自定"
       
    }
    
    override func getSpecificFreqencyString() -> String {
        var str = ""
        for weekday in weekdays {
            str += "\(weekday.name), "
        }
        
        str.removeLast()
        return str
    }
}

class EveryMonth: NewFrequency {
    var days: Int
    private enum Key: String, CodingKey {
        case days
    }
    init(days: Int) {
        self.days = days
        super.init(type: .everyMonth)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        self.days = try container.decode(Int.self, forKey: .days)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(days, forKey: Key.days)
        try super.encode(to: encoder)
    }
    
    override func getFreqencyString() -> String {
        return "每月\(self.days)次"
    }
}




