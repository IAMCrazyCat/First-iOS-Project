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
    
    static func > (lhs: CustomDate, rhs: CustomDate) -> Bool {
        let dayDifference = DateCalculator.calculateDayDifferenceBetween(lhs, to: rhs)
        if dayDifference > 0 {
            return false
        } else {
            return true
        }
    }
    
    static func == (lhs: CustomDate, rhs: CustomDate) -> Bool {
        let dayDifference = DateCalculator.calculateDayDifferenceBetween(lhs, to: rhs)
        if dayDifference == 0 {
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
    var weekday: WeekDay {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let date = formatter.date(from: "\(year) \(month) \(day)")
        var weekdayNumber = Calendar.current.component(.weekday, from: date!)
        if weekdayNumber <= 1 {
            weekdayNumber = 7
        } else {
            weekdayNumber -= 1
        }
        
        let weekDay = WeekDay(rawValue: weekdayNumber)
        return weekDay!
    }
    
    var week: Array<CustomDate> {
        var currentWeek: Array<CustomDate> = []
        let currentWeekdayNumber = CustomDate.current.weekday.rawValue
        for i in 1 ... 7 {
            let currentWeekday = DateCalculator.calculateDate(withDayDifference: i - currentWeekdayNumber, originalDate: self)
            currentWeek.append(currentWeekday)
        }

        return currentWeek.sorted(by: {
            $0.weekday.rawValue < $1.weekday.rawValue
        })
    }
    
    var currentMonth: Array<CustomDate> {
        var currentMonth: Array<CustomDate> = []
        var daysInCurrentMonth: Int {
            let calendar = Calendar.current
            let dateComponents = DateComponents(year: self.year, month: self.month)
            let date = calendar.date(from: dateComponents)!
            let range = calendar.range(of: .day, in: .month, for: date)!
            return range.count
        }
       
        for day in 1 ... daysInCurrentMonth {
            let customDate = CustomDate(year: self.year, month: self.month, day: day)
            currentMonth.append(customDate)
        }
        return currentMonth
    }
    
    public func getDateString() -> String {
        let yearStr: String = "\(self.year)"
        let monthStr: String
        let dayStr: String
        
        if self.month < 10 {
            monthStr = "0\(self.month)"
        } else {
            monthStr = "\(self.month)"
        }
        
        if self.day < 10 {
            dayStr = "0\(self.day)"
        } else {
            dayStr = "\(self.day)"
        }
        
        return yearStr + " " + monthStr + " " + dayStr
    }
}
