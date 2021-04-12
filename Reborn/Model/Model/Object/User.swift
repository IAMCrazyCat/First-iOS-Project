//
//  User.swift
//  Reborn
//
//  Created by Christian Liu on 9/1/21.
//

import Foundation
import UIKit


class User: Codable {

    var name: String
    var gender: Gender
    var avatar: Data
    var energy: Int
    var items: Array<Item>
    var isVip: Bool
    
    var energyChargingEfficiencyDays: Int {
        if self.isVip {
            return 7
        } else {
            return 21
        }
    }
    
    var inProgressItems: Array<Item> {
        var inProgressItems: Array<Item> = []
        for item in self.items {
            if item.state == .inProgress {
                inProgressItems.append(item)
            }
        }
        return inProgressItems
    }

    
    public init(name: String, gender: Gender, avatar: UIImage, energy: Int, items: Array<Item>, isVip: Bool) {
        self.name = name
        self.gender = gender
        self.avatar = avatar.pngData() ?? Data()
        self.energy = energy
        self.items = items
        self.isVip = isVip
    }
    
    public func getAvatarImage() -> UIImage {
        return UIImage(data: avatar) ?? UIImage()
    }
    
    public func setAvatarImage(_ image: UIImage) {

        avatar = image.pngData() ?? #imageLiteral(resourceName: "Test").pngData()!

    }
    
    public func getOverAllProgress() -> Double {
        
        var overAllProgress = 0.0
        
        for item in self.items {
           
            if item.targetDays != 0 {
                let itemProgress = Double(item.finishedDays) / Double(item.targetDays)
    
                overAllProgress += itemProgress
            }

        }
        
        if self.items.count != 0 {
            overAllProgress /= Double(self.items.count)
        }
        
        
        return overAllProgress
       
    }
    
    public func add(newItem: Item) {
        
        self.items.append(newItem)

    }
    
    public func delete(item itemforDeleting: Item) {
        var index = 0
        for item in self.items {
            if item.ID == itemforDeleting.ID {
                self.items.remove(at: index)
            }
            index += 1
        }

        
    }
    
    public func updateItem(withTag index: Int) {
        
        let item = self.items[index]
        if !item.isPunchedIn {
            item.punchIn()
            
            Vibrator.vibrate(withNotificationType: .success)
        } else {
            item.revokePunchIn()

            Vibrator.vibrate(withImpactLevel: .light)
        }
        
        updateEnergy(by: item)
        
    }
    
    public func updateEnergy(by item: Item) {

        if item.lastEnergyConsecutiveDays >= self.energyChargingEfficiencyDays && !item.todayIsAddedEnergy {
            self.energy += 1
            item.lastEnergyConsecutiveDays = 0
            item.energyRedeemDates.append(CustomDate.current)
            AppEngine.shared.userSetting.hasViewedEnergyUpdate = false
            AppEngine.shared.saveSetting()
        }
    }
    
    public func add(punchInDates: Array<CustomDate>, to item: Item) {
        for makingUpDate in punchInDates {
            item.add(punchInDate: makingUpDate)
        }
        
    }
    
    public func getItemBy(tag index: Int) -> Item {
        return self.items[index]
    }
    
    public func getLargestItemID() -> Int {
        var largestID = 0
        for item in self.items {
            let ID = item.ID
            if ID > largestID {
                largestID = ID
            }
        }
        return largestID
    }
    
    public func getNumberOfTodayInProgresItems() -> Int {

        let numberOfInProgressItems: Int = self.inProgressItems.count

        return numberOfInProgressItems
    }
    
    public func getNumberOfTodayPunchedInItems() -> Int {
    
        var numberOfPunchedInItems: Int = 0
        for item in self.inProgressItems {
            if item.isPunchedIn {
                numberOfPunchedInItems += 1
            }
        }
        
        return numberOfPunchedInItems
    }
    
    public func updateAllItems() {
        for item in self.items {
            item.updateState()
        }
    }
    

}
