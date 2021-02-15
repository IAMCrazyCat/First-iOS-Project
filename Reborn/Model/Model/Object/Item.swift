//
//  Item.swift
//  Reborn
//
//  Created by Christian Liu on 19/12/20.
//


import Foundation
class Item: Codable {
    var name: String
    var targetDays: Int
    var finishedDays: Int
    var creationDate: CustomDate
    var type: ItemType
    var scheduleDates: Array<CustomDate> = []
    var punchInDates: Array<CustomDate> = []
    var frequency: DataOption {
        didSet{
            self.scheduleDates.removeAll()
            var cycle = self.frequency.data ?? 1
            var interval = 0
            while self.scheduleDates.count < self.targetDays  {
  
                if cycle < self.frequency.data ?? 1 {
                    
                    cycle += 1
                    
                } else {
                    
                    let calendar = Calendar.current
                    let date = calendar.date(byAdding: .day, value: interval, to: Date())
                    let components = calendar.dateComponents([.year, .month, .day, .hour], from: date!)
                    let customDate = CustomDate(year: components.year!, month: components.month!, day: components.day!)
                    self.scheduleDates.append(customDate)
                    cycle = 0
                }
                
                interval += 1
            }
            print(scheduleDates)
        }
    }
    var isPunchedIn: Bool{
        get {
            if self.punchInDates.count > 0 {
                var index = self.punchInDates.count - 1
                for _ in 0 ... index {
                    if self.punchInDates[index] == AppEngine.shared.currentDate {
                        return true
                    }
                    index -= 1
                }
            }
            return false
        }
    }
    
    var progress: Double {
        return Double(self.finishedDays) / Double(self.targetDays)
    }
    
    var progressInPercentageString: String {
        return String(format: "%.1f", progress * 100) + " %"
    }
    
    init(name: String, days: Int, finishedDays: Int, frequency: DataOption, creationDate: CustomDate, type: ItemType) {
        self.name = name
        self.targetDays = days
        self.finishedDays = finishedDays
        self.creationDate = creationDate
        self.type = type
        self.frequency = frequency
        
    }
    
    func punchIn(punchInDate: CustomDate) {
        self.punchInDates.append(punchInDate)
        self.finishedDays += 1
    }
    
    
    func revokePunchIn() {
        
        if self.punchInDates.count > 0 {
            var index = self.punchInDates.count - 1
            for _ in 0 ... index {
                if self.punchInDates[index] == AppEngine.shared.currentDate {
                    self.punchInDates.remove(at: index)
                }
                index -= 1
            }

            self.finishedDays -= 1
        }
        
    }
    
    
    
}
