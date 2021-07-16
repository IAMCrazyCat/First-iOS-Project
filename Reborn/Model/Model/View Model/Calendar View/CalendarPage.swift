//
//  CalendarPage.swift
//  Reborn
//
//  Created by Christian Liu on 14/1/21.
//

import Foundation
struct CalendarPage {
    let calendar = Calendar.current
    let item: Item
    var year: Int
    var month: Int
    var punchedInDays: Array<Int> = []
    var days: Int {
        let dateComponents = DateComponents(year: year, month: month)
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    var weekdayOfFirstDay: Int {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        if let firstDayDate = formatter.date(from: "\(year) \(month) 1") {
            return calendar.component(.weekday, from: firstDayDate) - 1
        } else {
            print("Wrong year or/and month data inlitialized! Year: \(year) Month: \(month), the calendar is set to 1997/4")
            return calendar.component(.weekday, from: formatter.date(from: "\(1997) \(4) 9")!) - 1
        }
       
    }
    
    var currentYearAndMonthInString: String {
        return "\(year)年 \(month)月"
    }
    
    init(year: Int, month: Int, item: Item) {
        self.year = year
        self.month = month
        self.item = item
        self.punchedInDays = getPunchedInDays()
    }
    
    public func getPunchedInDays() -> Array<Int> {
        var punchedInDays: Array<Int> = []

        for punchedInDate in self.item.punchInDates { // add all punched in date into punchedInDays array
            if punchedInDate.year == self.year && punchedInDate.month == self.month {
                punchedInDays.append(punchedInDate.day)
            }
        }
       
        return punchedInDays
    }
}
