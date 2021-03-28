//
//  punchInDate.swift
//  Reborn
//
//  Created by Christian Liu on 15/1/21.
//

import Foundation

struct CustomDate: Codable, Equatable {
    
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
}
