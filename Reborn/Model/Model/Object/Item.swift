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
    var lastEnergyConsecutiveDays: Int = 0 {
        didSet {
            if lastEnergyConsecutiveDays < 0 {
                lastEnergyConsecutiveDays = 0
            }
        }
    }
    
    public func getFinishedDays() -> Int {
        return punchInDates.count
    }
    
    public func isPunchedIn() -> Bool {
        if punchInDates.contains(CustomDate.current) {
            return true
        } else {
            return false
        }
    }
    
    public func todayIsAddedEnergy() -> Bool {
        if energyRedeemDates.contains(CustomDate.current) {
            return true
        } else {
            return false
        }
    }
    public func getProgress() -> Double {
        return Double(self.getFinishedDays()) / Double(self.targetDays)
    }
    
    public func getCurrentEnergyConsecutiveDays(finish: @escaping (Int) -> Void) {
        self.getConsecutiveDaysArray(finish: { result in
            finish(result.last ?? 0)
        })
    }

    public func getBestConsecutiveDays(finish: @escaping (Int) -> Void) {
        self.getConsecutiveDaysArray(finish: { result in
            finish(result.max() ?? 0)
        })
    }
    
    public func getProgressInPercentageString() -> String {
        return String(format: "%.1f", self.getProgress() * 100) + " %"
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
       
        
        do {
            self.ID = try container.decode(Int.self, forKey: .ID)
        } catch {
            print("Failed to decode ID")
            self.ID = 0
        }
        
        do {
            self.name = try container.decode(String.self, forKey: .name)
        } catch {
            print("Item name failed to decode")
            self.name = "一件事"
        }
        
        do {
            self.targetDays = try container.decode(Int.self, forKey: .targetDays)
        } catch {
            print("Target days failed to decode")
            self.targetDays = 30
        }
        
        do {
            self.energy = try container.decode(Int.self, forKey: .energy)
        } catch {
            print("Energy failed to decode")
            self.energy = 0
        }
        
        do {
            self.creationDate = try container.decode(CustomDate.self, forKey: .creationDate)
        } catch {
            print("CreatioDate failed to decode")
            self.creationDate = CustomDate.current
        }
        
        do {
            self.type = try container.decode(ItemType.self, forKey: .type)
        } catch {
            print("Type failed to decode")
            self.type = .persisting
        }
        
        do {
            self.punchInDates = try container.decode([CustomDate].self, forKey: .punchInDates)
        } catch {
            print("Punch In dates failed to decode")
            self.punchInDates = [CustomDate]()
        }
        
        do {
            self.state = try container.decode(ItemState.self, forKey: .state)
        } catch {
            print("State failed to decode")
            self.state = .inProgress
        }
        
        do {
            self.energyRedeemDates = try container.decode([CustomDate].self, forKey: .energyRedeemDates)
        } catch {
            print("Energy redeen dates failed to decode")
            self.energyRedeemDates = [CustomDate]()
        }
        
        
        do {
            self.icon = try container.decode(Icon.self, forKey: .icon)
        } catch {
            print("Icon failed to decode")
            self.icon = Icon.defaultIcon1
        }
        
        
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
            self.lastEnergyConsecutiveDays = 1
        }
        
        self.updateState()
        
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
        
        if isConsecutivePunchIn() {
            self.lastEnergyConsecutiveDays += 1
        } else {
            self.lastEnergyConsecutiveDays = 1
        }
        updateState()
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
        
        self.lastEnergyConsecutiveDays -= 1
        updateState()
    }
  
    public func add(punchInDates: Array<CustomDate>, finish: (() -> Void)?) {
        for punchInDate in punchInDates {
            self.punchInDates.append(punchInDate)
        }
       
        self.sortDateArray {
            self.updateState()
            finish?()
        }
        
        
        
    }
    
    func checkEveryWeekdaysCompletion(with newFrequency: EveryWeekdays) -> Bool {
        var currentWeekShouldPunchInDates: Array<CustomDate> = []
        var currentWeekPunchInDates: Array<CustomDate> = []

        for currentWeekDate in CustomDate.current.weekDates {
            if newFrequency.weekdays.contains(currentWeekDate.weekday) {
                currentWeekShouldPunchInDates.append(currentWeekDate)
            }
        }

        var index = self.punchInDates.count - 1
        
        while index >= 0 {
            let punchInDate = self.punchInDates[index]
            if CustomDate.current.weekDates.contains(punchInDate) {
                currentWeekPunchInDates.append(punchInDate)
            }
            
            var wentOutCurrentWeek = true // Optmize
            for currentWeekDate in CustomDate.current.weekDates {
                if currentWeekDate.month == punchInDate.month {
                    wentOutCurrentWeek = false
                }
            }
            if wentOutCurrentWeek {
                break
            }
            index -= 1
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
            if CustomDate.current.weekDates.contains(punchInDate) {
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
                
                if punchedDays >= newFrequency.days && !self.isPunchedIn() {
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
                if CustomDate.current.weekDates.contains(punchInDate) {
                    punchedDays += 1
                }
                
                if punchedDays >= newFrequency.days && !self.isPunchedIn() {
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

        
        if self.getFinishedDays() == self.targetDays {
            self.state = .completed
            
        } else {
            
            if let newFrequency = self.newFrequency as? EveryDay {
                self.state = .inProgress
            } else if let newFrequency = self.newFrequency as? EveryMonth {
                checkEveryMonthState(with: newFrequency)
            } else if let newFrequency = self.newFrequency as? EveryWeek {
                checkEveryWeekState(with: newFrequency)
            } else if let newFrequency = self.newFrequency as? EveryWeekdays {
                checkEveryWeekdaysState(with: newFrequency)
            }

        }
        
        
        NotificationManager.shared.scheduleNotification(for: self)
       
        
        
        

    }
    
    
    private func sortDateArray(finish: (() -> Void)? = nil) {
        
        DispatchQueue.global().async {
            let loadingItem = LoadingItem(item: self, description: "Sorting array")
            ThreadsManager.shared.add(loadingItem)
            print("Sorting punch in dates for item: \(self.name)")
            let newPunchInDates = self.punchInDates.sorted {
                DateCalculator.calculateDayDifferenceBetween($0, to: $1) > 0
            }
            DispatchQueue.main.async {
                self.punchInDates = newPunchInDates
                ThreadsManager.shared.remove(loadingItem)
                finish?()
                print("Finished sorting punch in dates for item: \(self.name)")
            }
        }

    }

    

    
    private func getConsecutiveDaysArray(finish: @escaping (Array<Int>) -> Void)  {
        
        var consecutiveDaysArray: Array<Int> = []
        var index: Int = 0
        var consecutiveDays: Int = 1
        
        DispatchQueue.global().async {
            let loadingItem = LoadingItem(item: self, description: "Getting consecutive days array")
            ThreadsManager.shared.add(loadingItem)
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
            
            DispatchQueue.main.async {
                ThreadsManager.shared.remove(loadingItem)
                finish(consecutiveDaysArray)
                
            }
        }
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
        let currentWeekSunday = CustomDate.current.weekDates.last!
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
                    for date in CustomDate.current.weekDates {
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
    
    public func getNextPunchInDateInString(finish: @escaping (String) -> Void) {
        
        DispatchQueue.global().async {
            let loadingItem = LoadingItem(item: self, description: "Getting next punch in date in string")
            ThreadsManager.shared.add(loadingItem)
            let nextPunchInDate = self.getNextPunchInDate(isPunchedIn: self.isPunchedIn())
            
            DispatchQueue.main.async {
                
                if let nextPunchInDate = nextPunchInDate {
                   
                    let daysDifference = DateCalculator.calculateDayDifferenceBetween(CustomDate.current, to: nextPunchInDate)
                    
                    switch daysDifference {
                    case 0: finish("今天")
                    case 1: finish("明天")
                    case 2: finish("后天")
                    default: finish("\(nextPunchInDate.month)月\(nextPunchInDate.day)日")
                    }

                } else {
                    return finish("暂无计划")
                }
                ThreadsManager.shared.remove(loadingItem)
            }
        }
        
        
    }
    
    public func getFullName() -> String {

        return self.name//"\(self.type.rawValue)\(self.name)"
    }
    
    public func getPeriodicalCompletionTitile() -> String {
        switch self.newFrequency.type {
        case .everyDay: return "今天"
        case .everyWeek: return "本周打卡"
        case .everyWeekdays: return "本周打卡"
        case .everyMonth: return "本月打卡"
        }
    }
    
    public func getPeriodicalCompletionInAttributedString(font: UIFont, normalColor: UIColor, redColor: UIColor, greenColor: UIColor, grayColor: UIColor, finish: @escaping (NSMutableAttributedString) -> Void) {
        var attributedString: NSMutableAttributedString = NSMutableAttributedString()
        
        switch self.newFrequency.type {
        case .everyDay:
            
            if self.isPunchedIn() {
                let attribute = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: greenColor]
                attributedString = NSMutableAttributedString(string: "已打卡", attributes: attribute)
            } else {
                let attribute = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: redColor]
                attributedString = NSMutableAttributedString(string: "未打卡", attributes: attribute)
            }
            finish(attributedString)
        case .everyWeek:
            let everyWeek: EveryWeek = self.newFrequency as! EveryWeek
            let currentWeekDates: Array<CustomDate> = CustomDate.current.weekDates
            var punchedInDaysInCurrentWeek: Int = 0
            DispatchQueue.global(qos: .userInitiated).async {
                for punchInDate in self.punchInDates {
                    if currentWeekDates.contains(punchInDate) {
                        punchedInDaysInCurrentWeek += 1
                    }
                }
                DispatchQueue.main.async {
                    let attribute = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: normalColor]
                    attributedString = NSMutableAttributedString(string: "\(punchedInDaysInCurrentWeek) / \(everyWeek.days)", attributes: attribute)
                    finish(attributedString)
                }
            }
           
            
            
        case .everyWeekdays:

            let everyWeekdays: EveryWeekdays = self.newFrequency as! EveryWeekdays
            let currentWeekDates: Array<CustomDate> = CustomDate.current.weekDates
            var currentWeekPunchedInWeekdays: Array<WeekDay> = []
            
            DispatchQueue.global(qos: .userInitiated).async {
                for punchInDate in self.punchInDates {
                    if currentWeekDates.contains(punchInDate)  {
                        currentWeekPunchedInWeekdays.append(punchInDate.weekday)
                    }
                }
                DispatchQueue.main.async {
                    var newAttributedString: NSMutableAttributedString = NSMutableAttributedString() // This is the way to show compeletion in each day
                    for weekday in everyWeekdays.weekdays {

                        let attribute1 = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: grayColor]
                        let attribute2 = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: greenColor]

                        if currentWeekPunchedInWeekdays.contains(weekday) {
                            newAttributedString = NSMutableAttributedString(string: "\(weekday.name)" + (weekday == everyWeekdays.weekdays.last ? "" : ", "), attributes: attribute2)
                        } else {
                            newAttributedString = NSMutableAttributedString(string: "\(weekday.name)" + (weekday == everyWeekdays.weekdays.last ? "" : ", "), attributes: attribute1)
                        }
                        attributedString.append(newAttributedString)
                    }
                    finish(attributedString)
                }
            }
            

            
            
            
        case .everyMonth:
            let everyMonth: EveryMonth = self.newFrequency as! EveryMonth
            let currentMonthDates: Array<CustomDate> = CustomDate.current.monthDates
            var punchedInDaysInCurrentMonth: Int = 0
            
            DispatchQueue.global(qos: .userInitiated).async {
                for punchInDate in self.punchInDates {
                    if currentMonthDates.contains(punchInDate) {
                        punchedInDaysInCurrentMonth += 1
                    }
                }
                DispatchQueue.main.async {
                    let attribute = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: normalColor]
                    attributedString = NSMutableAttributedString(string: "\(punchedInDaysInCurrentMonth) / \(everyMonth.days)", attributes: attribute)
                    finish(attributedString)
                }
            }
            
            

        }
        
       
    }
    
    
}

