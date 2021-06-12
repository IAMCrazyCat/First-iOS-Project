//
//  DateCalculator.swift
//  Reborn
//
//  Created by Christian Liu on 31/1/21.
//

import Foundation
class DateCalculator {
    
    static func calculateMonthDifference(withOriginalDate originalDate: CustomDate, andNewDate newDate: CustomDate) -> Int {
        
        let yearDifference = newDate.year - originalDate.year
        var monthDifference = newDate.month - originalDate.month
        monthDifference = yearDifference * 12 + monthDifference
        
        return monthDifference
    }
    
    
    static func calculateDate(withMonthDifference value: Int, originalDate: CustomDate) -> CustomDate {
        var yearResult = 0
        var monthResult = 0

        if value < 0 {
            var month = originalDate.month + value
            while month < 0 {
                month = 12 + month

            }
            
            if month == 0 {
                month = 12
            }
            monthResult = month
            
        } else if value > 0 {
            
            var month = value % 12 + originalDate.month
            
            if month > 12 {
                month = month - 12
            }
  
            monthResult = month
            
        } else {
            
            monthResult = originalDate.month
        }
        
        
        if value < 0 {
            var month = originalDate.month + value
            var year = 0
            while month < 0 {

                month = 12 + month
                year += 1
            }
            
            if month == 0 {
                month = 12
                year += 1
            }
            
            year = originalDate.year - year
            yearResult = year
            
        } else if value > 0 {
            
            let month = value % 12 + originalDate.month
            
            var year = Int(value / 12) + originalDate.year
            if month > 12 {
                year += 1
                
            }

            yearResult = year
            
        } else {
            
            yearResult = originalDate.year
        }
        
        
        return CustomDate(year: yearResult, month: monthResult, day: originalDate.day)
        
    }
    
    static func calculateDate(withDayDifference dayDifference: Int, originalDate: CustomDate) -> CustomDate {
        
        let defaultResult = CustomDate(year: 1997, month: 4, day: 9)
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy M d"
        
        guard let originalDate = dateFormatter.date(from: "\(originalDate.year) \(originalDate.month) \(originalDate.day)"),
              let nowDate = dateFormatter.date(from: "\(CustomDate.current.year) \(CustomDate.current.month) \(CustomDate.current.day)")
        else {
            return defaultResult
            
        }
        
        let date1 = calendar.startOfDay(for: originalDate)
        let date2 = calendar.startOfDay(for: nowDate)
        
        guard let daysDiffernceBetweenOriginalDateAndNow = calendar.dateComponents([.day], from: date1, to: date2).day
        else {
            return defaultResult
        }
        
        let date = calendar.date(byAdding: .day, value: dayDifference - daysDiffernceBetweenOriginalDateAndNow, to: Date())
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date!)
        let dateResult = CustomDate(year: components.year!, month: components.month!, day: components.day!)
        
        return dateResult
    }
    
    static func calculateDayDifferenceBetween(_ from: CustomDate, to: CustomDate) -> Int {
        
        let calendar = Calendar.current
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MM DD"
        var fromComponents = DateComponents()
        fromComponents.year = from.year
        fromComponents.month = from.month
        fromComponents.day = from.day
        
        var toComponents = DateComponents()
        toComponents.year = to.year
        toComponents.month = to.month
        toComponents.day = to.day
        
        let fromDate = calendar.startOfDay(for: calendar.date(from: fromComponents)!)
        let toDate = calendar.startOfDay(for: calendar.date(from: toComponents)!)
        let numberOfDays = calendar.dateComponents([.day], from: fromDate, to: toDate)
        
        return numberOfDays.day!
    }
    
    static func calculateTimeDifference(from: Date, to: Date) -> Int {
        
        let difference = Calendar.current.dateComponents([.second], from: from, to: to).second
        let oneTenthSecondDifference = difference! * 1000
        return oneTenthSecondDifference
    }
    
//    static func calculateDate(withMonthDifference monthDifference: Int, originalDate: CustomDate) -> CustomDate {
//        var newMonth = originalDate.month + (monthDifference % 12)
//        var newYear = originalDate.year + (monthDifference / 12)
//        if newMonth > 12 {
//            newMonth = 1
//        } else if newMonth == 0 {
//            newMonth = 12
//        } else if newMonth < 0 {
//            newMonth = 12 - newMonth
//        }
//        
//        
//        
//        return CustomDate(year: newYear, month: newMonth, day: <#T##Int#>)
//    }
    
}
