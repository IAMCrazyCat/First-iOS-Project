//
//  CalendarPage.swift
//  Reborn
//
//  Created by Christian Liu on 14/1/21.
//

import Foundation
struct CalendarPage {
    let calendar = Calendar.current
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
        let firstDayDate =  formatter.date(from: "\(year) \(month) 1")
        return calendar.component(.weekday, from: firstDayDate!)
    }
    
    var currentYearAndMonthInString: String {
        return "\(year)年 \(month)月"
    }
    
    init(year: Int, month: Int, punchedInDays: Array<Int>) {
        self.year = year
        self.month = month
        self.punchedInDays = punchedInDays
    }
}
