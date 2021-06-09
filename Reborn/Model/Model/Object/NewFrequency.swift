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
}

class EveryDay: NewFrequency {
    
    init() {
        super.init(type: .everyDay)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

class EveryWeek: NewFrequency {
    var days: Int
    
    init(days: Int) {
        self.days = days
        super.init(type: .everyWeek)
        
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

class EveryWeekdays: NewFrequency {
    var weekdays: Array<WeekDay>
    init(weekDays: Array<WeekDay>) {
        self.weekdays = weekDays
        super.init(type: .everyWeekdays)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

class EveryMonth: NewFrequency {
    var days: Int
    init(days: Int) {
        self.days = days
        super.init(type: .everyMonth)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}




