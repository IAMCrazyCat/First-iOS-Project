//
//  Item.swift
//  Reborn
//
//  Created by Christian Liu on 19/12/20.
//


import Foundation
class Item: Codable {
    var ID: Int
    var name: String
    var targetDays: Int {
        didSet {
            self.updateScheduleDates()
        }
    }
    var finishedDays: Int {
        return punchInDates.count
    }
    var energy: Int = 0
    var creationDate: CustomDate
    var type: ItemType
    var scheduleDates: Array<CustomDate> = []
    var punchInDates: Array<CustomDate> = []
    var state: ItemState = .inProgress
    var frequency: Frequency {
        didSet{
            self.updateScheduleDates()
        }
    }
    var isPunchedIn: Bool{
        print(CustomDate.current.day)
        if punchInDates.contains(CustomDate.current) {
            return true
        } else {
            return false
        }
    }
    
    var progress: Double {
        return Double(self.finishedDays) / Double(self.targetDays)
    }
    
    var progressInPercentageString: String {
        return String(format: "%.1f", progress * 100) + " %"
    }
    
    var bestConsecutiveDays: Int {

        return self.getConsecutiveDaysArray().max() ?? 0
    }
    
    var currentConsecutiveDays: Int {

        return self.getConsecutiveDaysArray().last ?? 0
    }
    
    var lastEnergyConsecutiveDays: Int = 0
    var energyRedeemDates: Array<CustomDate> = []
    var todayIsAddedEnergy: Bool {
        if energyRedeemDates.contains(CustomDate.current) {
            return true
        } else {
            return false
        }
    }
    
    init(ID: Int, name: String, days: Int, frequency: Frequency, creationDate: CustomDate, type: ItemType) {
        self.ID = ID
        self.name = name
        self.targetDays = days
        self.creationDate = creationDate
        self.type = type
        self.frequency = frequency
        
        updateScheduleDates()
        updateState()
    }
    
    public func punchIn(on date: CustomDate = CustomDate.current) {
        self.punchInDates.append(date)
        updateState()
        updateEnergyConsecutiveDays(withDaysToAdd: 1)
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
        updateEnergyConsecutiveDays(withDaysToAdd: -1)

    }
  
    public func add(punchInDate: CustomDate) {
        self.punchInDates.append(punchInDate)
        
        updateState()
        sortDateArray()
        
    }
    
    private func updateState() {
        
        if self.finishedDays == self.targetDays {
            self.state = .completed
        } else if self.scheduleDates.contains(CustomDate.current) {
            self.state = .inProgress
        } else {
            self.state = .duringBreak
        }
    }
    
    private func updateScheduleDates() {
   
        self.scheduleDates.removeAll()
        var cycle = self.frequency.dataModel.data ?? 1
        var difference = 0
        while self.scheduleDates.count < self.targetDays  {

            if cycle < (self.frequency.dataModel.data ?? 1) - 1 {
                
                cycle += 1
                
            } else {
                
                let customDate = DateCalculator.calculateDate(withDayDifference: difference, originalDate: self.creationDate)
                
                self.scheduleDates.append(customDate)
                cycle = 0
            }
            difference += 1
        }
        
        updateState()
        sortDateArray()
    }
    
    private func sortDateArray() {
        self.punchInDates.sort {
            DateCalculator.calculateDayDifferenceBetween($0, and: $1) > 0
        }
        self.scheduleDates.sort {
            DateCalculator.calculateDayDifferenceBetween($0, and: $1) > 0
        }
        print("PunchIn Dates Sorted")
        //print(self.punchInDates)
        
        print("Schedule Dates Sorted")
        //print(self.scheduleDates)
        
    }

    
    private func updateEnergyConsecutiveDays(withDaysToAdd days: Int) {

        if isConsecutivePunchIn() {
            self.lastEnergyConsecutiveDays += days
        } else {
            self.lastEnergyConsecutiveDays = 0
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
            
            if DateCalculator.calculateDayDifferenceBetween(date1, and: date2) == 1 {
                print(consecutiveDays)
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
            if DateCalculator.calculateDayDifferenceBetween(yesterday, and: today) == 1 {
                return true
            } else {
                return false
            }
        } else {
           return true
        }

        
    }
    
    
    
    
    
}
