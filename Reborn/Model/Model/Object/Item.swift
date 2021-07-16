//
//  Item.swift
//  Reborn
//
//  Created by Christian Liu on 19/12/20.
//


import Foundation
import UIKit

class Item: Codable {
    var ID: Int
    var name: String
    var targetDays: Int
    var energy: Int = 0
    var creationDate: CustomDate
    var type: ItemType
    var punchInDates: Array<CustomDate> = []
    var energyRedeemDates: Array<CustomDate> = []
    var state: ItemState = .inProgress
    var hasSanction: Bool = false
    var icon: Icon
    var newFrequency: NewFrequency
    var notificationTimes: Array<CustomTime> = []
    var missedPunchInDates: Array<CustomDate> = []
    
    
    var finishedDays: Int {
        return punchInDates.count
    }
    var isPunchedIn: Bool {
        if punchInDates.contains(CustomDate.current) {
            return true
        } else {
            return false
        }
    }
    var todayIsAddedEnergy: Bool {
        if energyRedeemDates.contains(CustomDate.current) {
            return true
        } else {
            return false
        }
    }
    
    var progress: Double {
        return Double(self.finishedDays) / Double(self.targetDays)
    }
    
    var lastEnergyConsecutiveDays: Int = 0 {
        didSet {
            if lastEnergyConsecutiveDays < 0 {
                lastEnergyConsecutiveDays = 0
            }
        }
    }
    
    var currentEnergyConsecutiveDays: Int {
        return self.getConsecutiveDaysArray().last ?? 0
    }
    
    var bestConsecutiveDays: Int {
        return self.getConsecutiveDaysArray().max() ?? 0
    }
    
    var progressInPercentageString: String {
        return String(format: "%.1f", progress * 100) + " %"
    }
    
    var nextPunchInDate: CustomDate? {
        return getNextPunchInDate(isPunchedIn: self.isPunchedIn)
    }
    
    var nextPunchInDateInString: String {
        return getNextPunchInDateInString()
    }
    
    init(ID: Int, name: String, days: Int, frequency: NewFrequency, creationDate: CustomDate, type: ItemType, icon: Icon, notificationTimes: Array<CustomTime>) {
        self.ID = ID
        self.name = name
        self.targetDays = days
        self.creationDate = creationDate
        self.type = type
        self.icon = icon
        self.newFrequency = frequency
        self.notificationTimes = notificationTimes
        updateState()
    }
    
    private enum Key: String, CodingKey {
        case ID
        case name
        case targetDays
        case energy
        case lastEnergyConsecutiveDays
        case creationDate
        case type
        case scheduleDates
        case punchInDates
        case state
        case frequency
        case hasSanction
        case energyRedeemDates
        case icon
        case newFrequency
        case newFrequencyType
        case notificationTimes
    }
    
    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: Key.self)
        self.ID = try container.decode(Int.self, forKey: .ID)
        self.name = try container.decode(String.self, forKey: .name)
        self.targetDays = try container.decode(Int.self, forKey: .targetDays)
        self.energy = try container.decode(Int.self, forKey: .energy)
        self.creationDate = try container.decode(CustomDate.self, forKey: .creationDate)
        self.type = try container.decode(ItemType.self, forKey: .type)
        self.punchInDates = try container.decode([CustomDate].self, forKey: .punchInDates)
        self.state = try container.decode(ItemState.self, forKey: .state)
        self.energyRedeemDates = try container.decode([CustomDate].self, forKey: .energyRedeemDates)
        self.icon = try container.decode(Icon.self, forKey: .icon)

        
        
        
        do {
            self.notificationTimes = try container.decode(Array<CustomTime>.self, forKey: .notificationTimes)
        } catch {
            self.notificationTimes = [CustomTime]()
            print("notificationTimes failed to decode")
        }
        
        var newFrequencyType: NewFrequencyType
        do {
            newFrequencyType = try container.decode(NewFrequencyType.self, forKey: .newFrequencyType)
        } catch {
            print("newFrequencyType failed to decode")
            newFrequencyType = .everyDay
        }
        
        switch newFrequencyType {
        case .everyDay:
            do {
                self.newFrequency = try container.decode(EveryDay.self, forKey: .newFrequency)
            } catch {
                self.newFrequency = EveryDay()
                print("EveryDay.self failed to decode")
            }
        case .everyMonth:
            do {
                self.newFrequency = try container.decode(EveryMonth.self, forKey: .newFrequency)
            } catch {
                self.newFrequency = EveryDay()
                print("EveryMonth.self failed to decode")
            }
        case .everyWeek:
            do {
                self.newFrequency = try container.decode(EveryWeek.self, forKey: .newFrequency)
            } catch {
                self.newFrequency = EveryDay()
                print("EveryWeek.self failed to decode")
            }
        case .everyWeekdays:
            do {
                self.newFrequency = try container.decode(EveryWeekdays.self, forKey: .newFrequency)
            } catch {
                self.newFrequency = EveryDay()
                print("EveryWeekdays.self failed to decode")
            }
        }
        
        do {
            self.lastEnergyConsecutiveDays = try container.decode(Int.self, forKey: .lastEnergyConsecutiveDays)
        } catch {
            print("lastEnergyConsecutiveDays failed to decode")
            self.lastEnergyConsecutiveDays = self.bestConsecutiveDays
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(ID, forKey: .ID)
        try container.encode(name, forKey: .name)
        try container.encode(targetDays, forKey: .targetDays)
        try container.encode(energy, forKey: .energy)
        try container.encode(creationDate, forKey: .creationDate)
        try container.encode(type, forKey: .type)
        try container.encode(punchInDates, forKey: .punchInDates)
        try container.encode(state, forKey: .state)
        try container.encode(hasSanction, forKey: .hasSanction)
        try container.encode(energyRedeemDates, forKey: .energyRedeemDates)
        try container.encode(icon, forKey: .icon)
        try container.encode(newFrequency.type, forKey: .newFrequencyType)
        try container.encode(lastEnergyConsecutiveDays, forKey: .lastEnergyConsecutiveDays)
        try container.encode(notificationTimes, forKey: .notificationTimes)
        
        switch newFrequency.type {
        case .everyDay: try container.encode(newFrequency as? EveryDay, forKey: .newFrequency)
        case .everyMonth: try container.encode(newFrequency as? EveryMonth, forKey: .newFrequency)
        case .everyWeek: try container.encode(newFrequency as? EveryWeek, forKey: .newFrequency)
        case .everyWeekdays: try container.encode(newFrequency as? EveryWeekdays, forKey: .newFrequency)
        }

    }
    
    
    public func punchIn(on date: CustomDate = CustomDate.current) {
        self.punchInDates.append(date)
        updateState()
        if isConsecutivePunchIn() {
            self.lastEnergyConsecutiveDays += 1
        } else {
            self.lastEnergyConsecutiveDays = 1
        }
        DispatchQueue.main.async {
            NotificationManager.shared.scheduleNotification(for: self)
        }
    }
    
    
    public func revokePunchIn() {
        
        if self.punchInDates.count > 0 {
            var index = self.punchInDates.count - 1
            for _ in 0 ... index {
                if self.punchInDates[index] == CustomDate.current {
                    self.punchInDates.remove(at: index)
                }
                index -= 1
            }

        }
        updateState()
        self.lastEnergyConsecutiveDays -= 1
        DispatchQueue.main.async {
            NotificationManager.shared.scheduleNotification(for: self)
        }
    }
  
    public func add(punchInDate: CustomDate) {
        self.punchInDates.append(punchInDate)
        
        updateState()
        sortDateArray()
        
    }
    
    func checkEveryWeekdaysCompletion(with newFrequency: EveryWeekdays) -> Bool {
        var currentWeekShouldPunchInDates: Array<CustomDate> = []
        var currentWeekPunchInDates: Array<CustomDate> = []

        for currentWeekDate in CustomDate.current.week {
            if newFrequency.weekdays.contains(currentWeekDate.weekday) {
                currentWeekShouldPunchInDates.append(currentWeekDate)
            }
        }

        for punchInDate in self.punchInDates {
            if CustomDate.current.week.contains(punchInDate) {
                currentWeekPunchInDates.append(punchInDate)
            }
        }

        var allDatesPunchedIn = true
        for shouldPunchInDate in currentWeekShouldPunchInDates {
            if !currentWeekPunchInDates.contains(shouldPunchInDate) {
                allDatesPunchedIn = false
            }
        }

        if allDatesPunchedIn {
            return true
        } else {
            return false
        }
    }
    
    func checkEveryWeekCompletion(with newFrequency: EveryWeek) -> Bool {
        var punchedDays = 0
        for punchInDate in self.punchInDates {
            if CustomDate.current.week.contains(punchInDate) {
                punchedDays += 1
            }
            
            if punchedDays >= newFrequency.days {
                return true
            }
        }
        
        if punchedDays < newFrequency.days {
            return false
        }
        
        return false
        
    }
    
    func checkEveryMonthCompletion(with newFrequency: EveryMonth) -> Bool {
        var punchedDays = 0
        for punchInDate in self.punchInDates {
            if punchInDate.month == CustomDate.current.month {
                punchedDays += 1
            }
            
            if punchedDays >= newFrequency.days {
                return true
            }
        }
        
        if punchedDays < newFrequency.days {
            return false
        }
        
        return false
    }
    
    
    public func updateState() {
        
        func checkEveryMonthState(with newFrequency: EveryMonth) {
            var punchedDays = 0
            for punchInDate in self.punchInDates {
                if punchInDate.month == CustomDate.current.month {
                    punchedDays += 1
                }
                
                if punchedDays >= newFrequency.days && !isPunchedIn {
                    self.state = .duringBreak
                    break
                }
            }
            
            if punchedDays < newFrequency.days {
                self.state = .inProgress
            }
        }
        
        func checkEveryWeekState(with newFrequency: EveryWeek) {
            var punchedDays = 0
            for punchInDate in self.punchInDates {
                if CustomDate.current.week.contains(punchInDate) {
                    punchedDays += 1
                }
                
                if punchedDays >= newFrequency.days && !isPunchedIn {
                    self.state = .duringBreak
                    break
                }
            }
            
            if punchedDays < newFrequency.days {
                self.state = .inProgress
            }
            
        }
        
        func checkEveryWeekdaysState(with newFrequency: EveryWeekdays) {
            
            if newFrequency.weekdays.contains(CustomDate.current.weekday) {
                self.state = .inProgress
            } else {
                self.state = .duringBreak
            }
        }

        
        if self.finishedDays == self.targetDays {
            self.state = .completed
            
        } else {
            
            if let newFrequency = newFrequency as? EveryDay {
                self.state = .inProgress
            } else if let newFrequency = newFrequency as? EveryMonth {
                checkEveryMonthState(with: newFrequency)
            } else if let newFrequency = newFrequency as? EveryWeek {
                checkEveryWeekState(with: newFrequency)
            } else if let newFrequency = newFrequency as? EveryWeekdays {
                checkEveryWeekdaysState(with: newFrequency)
            }

        }
        
        DispatchQueue.main.async {
            NotificationManager.shared.scheduleNotification(for: self)
        }

    }
    
    
    private func sortDateArray() {
        
        DispatchQueue.main.async {
            self.punchInDates.sort {
                DateCalculator.calculateDayDifferenceBetween($0, to: $1) > 0
            }
        }

    }

    

    
    private func getConsecutiveDaysArray() -> Array<Int> {
        
        var consecutiveDaysArray: Array<Int> = []
        var index: Int = 0
        var consecutiveDays: Int = 1
        self.sortDateArray()
        
        
        if self.punchInDates.count > 0 {
            consecutiveDaysArray.append(1) // if item has at leat one punch in date
        }
        
        while index < self.punchInDates.count - 1 {
            let date1 = self.punchInDates[index]
            let date2 = self.punchInDates[index + 1]
            
            if DateCalculator.calculateDayDifferenceBetween(date1, to: date2) == 1 {
                consecutiveDays += 1
            } else {
                consecutiveDaysArray.append(consecutiveDays)
                consecutiveDays = 1
            }
 
            index += 1
            
            if index >= self.punchInDates.count - 1 {
                consecutiveDaysArray.append(consecutiveDays)
            }
            
            
        }
        
       return consecutiveDaysArray
    }
    
    private func isConsecutivePunchIn() -> Bool {
        if punchInDates.count - 2 >= 0 {
            let yesterday = self.punchInDates[punchInDates.count - 2]
            let today = self.punchInDates[punchInDates.count - 1]
            if DateCalculator.calculateDayDifferenceBetween(yesterday, to: today) == 1 {
                return true
            } else {
                return false
            }
        } else {
           return true
        }
    }
    
    public func getNextPunchInDate(isPunchedIn: Bool) -> CustomDate? {
        
        let tomorrow = DateCalculator.calculateDate(withDayDifference: 1, originalDate: CustomDate.current)
        let today = CustomDate.current
        let currentWeekSunday = CustomDate.current.week.last!
        let nextMonday = DateCalculator.calculateDate(withDayDifference: 1, originalDate: currentWeekSunday)
        let nextYear = DateCalculator.calculateDate(withMonthDifference: 1, originalDate: CustomDate.current).year
        let nextMonth = DateCalculator.calculateDate(withMonthDifference: 1, originalDate: CustomDate.current).month
       
        
        func getItBy(_ newFrequency: EveryDay) -> CustomDate? {
            
            if isPunchedIn {
                return tomorrow
            } else {
                return today
            }
        }
        
        func getItBy(_ newFrequency: EveryWeek) -> CustomDate? {
            if checkEveryWeekCompletion(with: newFrequency) {
                return nextMonday
            } else {
                if isPunchedIn {
                    return tomorrow
                } else {
                    return today
                }
            }
        }
        
        func getItBy(_ newFrequency: EveryWeekdays) -> CustomDate? {
            
            let todayShouldPunchIn = newFrequency.weekdays.contains(CustomDate.current.weekday)
            let isCompletedInCurrentWeek = checkEveryWeekdaysCompletion(with: newFrequency)
            let todayDidPunchIn = isPunchedIn
            var nextWeekFirstPunchInDate: CustomDate? {
                
                for dayDifference in 0 ... 6 {
                    let nextWeekDate = DateCalculator.calculateDate(withDayDifference: dayDifference, originalDate: nextMonday)
                    if nextWeekDate.weekday.rawValue == newFrequency.weekdays.first?.rawValue { // first punch in date
                        return nextWeekDate
                    }
                }
                return nil
            }

            func nextPunchInDate() -> CustomDate? {
                var nextWeekday: WeekDay? = nil
                for weekday in newFrequency.weekdays {
                    if weekday.rawValue > CustomDate.current.weekday.rawValue { // next weekday should punchIn in current week
                        nextWeekday = weekday
                        break
                    }
                }
                
                if nextWeekday != nil {
                    for date in CustomDate.current.week {
                        if date.weekday.rawValue == nextWeekday!.rawValue {
                            return date
                        }
                    }
                }
                return nextWeekFirstPunchInDate
            }
            
            
            if isCompletedInCurrentWeek {
                return nextPunchInDate()
            } else {
                if todayShouldPunchIn && todayDidPunchIn {
                    return nextPunchInDate()
                } else if todayShouldPunchIn && !todayDidPunchIn {
                    return today
                } else {
                    return nextPunchInDate()
                }
            }

        }
        
        func getItBy(_ newFrequency: EveryMonth) -> CustomDate {
            
            if checkEveryMonthCompletion(with: newFrequency) {
                return CustomDate(year: nextYear, month: nextMonth, day: 1)
            } else {
                if isPunchedIn {
                    return tomorrow
                } else {
                    return today
                }
                
            }
        }
        
        
        
        
        if self.state == .completed {
            return nil
        } else {
            
            if let newFrequency = newFrequency as? EveryDay {
               return getItBy(newFrequency)
            } else if let newFrequency = newFrequency as? EveryMonth {
                return getItBy(newFrequency)
            } else if let newFrequency = newFrequency as? EveryWeek {
                return getItBy(newFrequency)
            } else if let newFrequency = newFrequency as? EveryWeekdays {
                return getItBy(newFrequency)
            } else {
                return nil
            }

        }
    }
    
    private func getNextPunchInDateInString() -> String {
        
        
        if let nextPunchInDate = self.nextPunchInDate {
           
            let daysDifference = DateCalculator.calculateDayDifferenceBetween(CustomDate.current, to: nextPunchInDate)
            
            switch daysDifference {
            case 0: return "今天"
            case 1: return "明天"
            case 2: return "后天"
            default: return "\(nextPunchInDate.month)月\(nextPunchInDate.day)日"
            }

        } else {
            return "暂无计划"
        }
    }
    
    public func getFullName() -> String {

        return self.name//"\(self.type.rawValue)\(self.name)"
    }
    
    public func getPeriodicalCompletionTitile() -> String {
        switch self.newFrequency.type {
        case .everyDay: return "今天"
        case .everyWeek, .everyWeekdays: return "本周"
        case .everyMonth: return "本月"
        }
    }
    
    public func getPeriodicalCompletionInAttributedString(font: UIFont, normalColor: UIColor, redColor: UIColor, greenColor: UIColor, grayColor: UIColor) -> NSMutableAttributedString {
        var attributedString: NSMutableAttributedString
        
        switch self.newFrequency.type {
        case .everyDay:
            
            if self.isPunchedIn {
                let attribute = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: greenColor]
                attributedString = NSMutableAttributedString(string: "已打卡", attributes: attribute)
            } else {
                let attribute = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: redColor]
                attributedString = NSMutableAttributedString(string: "未打卡", attributes: attribute)
            }
            return attributedString
        case .everyWeek:
            let everyWeek: EveryWeek = self.newFrequency as! EveryWeek
            let currentWeekdaysDates: Array<CustomDate> = CustomDate.current.week
            var punchedInDaysInCurrentWeek: Int = 0
            for punchInDate in self.punchInDates {
                if currentWeekdaysDates.contains(punchInDate) {
                    punchedInDaysInCurrentWeek += 1
                }
            }
            let attribute = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: normalColor]
            attributedString = NSMutableAttributedString(string: "\(punchedInDaysInCurrentWeek)/\(everyWeek.days)", attributes: attribute)
            
        case .everyWeekdays:
            let everyWeekdays: EveryWeekdays = self.newFrequency as! EveryWeekdays
            let currentWeekdaysDates: Array<CustomDate> = CustomDate.current.week
            var punchedInDaysInCurrentWeek: Int = 0
            for punchInDate in self.punchInDates {
                if currentWeekdaysDates.contains(punchInDate) {
                    punchedInDaysInCurrentWeek += 1
                }
            }
            let attribute = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: normalColor]
            attributedString = NSMutableAttributedString(string: "\(punchedInDaysInCurrentWeek)/\(everyWeek.days)", attributes: attribute)
        case .everyMonth:
            let everyMonth: EveryMonth = self.newFrequency as! EveryMonth
            let currentWeekdaysDates: Array<CustomDate> = CustomDate.current.week
            var punchedInDaysInCurrentMonth: Int = 0
            for punchInDate in self.punchInDates {
                if currentWeekdaysDates.contains(punchInDate) {
                    punchedInDaysInCurrentMonth += 1
                }
            }
            let attribute = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: normalColor]
            attributedString = NSMutableAttributedString(string: "\(punchedInDaysInCurrentMonth)/\(everyMonth.days)", attributes: attribute)
            
            
        return attributedString
        }
    }
    
    
    
}
