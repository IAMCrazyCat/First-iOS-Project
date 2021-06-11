//
//  punchInDate.swift
//  Reborn
//
//  Created by Christian Liu on 15/1/21.
//

import Foundation

struct CustomDate: Codable, Equatable, Comparable {
    static func < (lhs: CustomDate, rhs: CustomDate) -> Bool {
        let dayDifference = DateCalculator.calculateDayDifferenceBetween(lhs, to: rhs)
        if dayDifference > 0 {
            return true
        } else {
            return false
        }
    }
    
    
    public static var current: CustomDate {
        let date = Date()
        let currentYear: Int = Calendar.current.component(.year, from: date)
        let currentMonth: Int = Calendar.current.component(.month, from: date)
        let currentDay: Int = Calendar.current.component(.day, from: date)
        return CustomDate(year: currentYear, month: currentMonth, day: currentDay)
    }
    
    var year: Int
    var month: Int
    var day: Int
    var weekday: WeekDay? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        if let date = formatter.date(from: "\(year) \(month) \(day)") {
            let weekday = Calendar.current.component(.weekday, from: date)
            let weekDay = WeekDay(rawValue: weekday)
            return weekDay
        }
       
        return nil
    }
    
    var week: Array<CustomDate> {
        var currentWeek: Array<CustomDate> = []
        if let currentWeekdayNumber = CustomDate.current.weekday?.rawValue {
            for i in 1 ... 7 {
                let currentWeekday = DateCalculator.calculateDate(withDayDifference: i - currentWeekdayNumber + 1, originalDate: self)
                currentWeek.append(currentWeekday)
            }
        }
        return currentWeek
    }
}
