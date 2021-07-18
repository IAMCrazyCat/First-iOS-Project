//
//  User.swift
//  Reborn
//
//  Created by Christian Liu on 9/1/21.
//

import Foundation
import UIKit


class User: Codable {
    var ID: String
    var name: String
    var gender: Gender
    var avatar: Data
    var energy: Int
    var items: Array<Item>
    var purchasedType: PurchaseType = .none
    var isVip: Bool {
        return purchasedType != .none
    }
    var energyChargingEfficiencyDays: Int {
        if self.isVip {
            return SystemSetting.shared.defaultVipEnergyChargingEfficiencyDays
        } else {
            return SystemSetting.shared.defaultNonVipEnergyChargingEfficiencyDays
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
    
    var creationDate: CustomDate

    
    public init(ID: String, name: String, gender: Gender, avatar: UIImage, energy: Int, items: Array<Item>, creationDate: CustomDate) {
        self.ID = ID
        self.name = name
        self.gender = gender
        self.avatar = avatar.pngData() ?? Data()
        self.energy = energy
        self.items = items
        self.creationDate = creationDate
    }
    
    private enum Key: String, CodingKey {
        case ID
        case name
        case gender
        case avatar
        case energy
        case items
        case purchasedType
        case creationDate
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        do {
            self.ID = try container.decode(String.self, forKey: .ID)
        } catch {
            print("User ID Decoding failed, default value assigned")
            self.ID = SystemSetting.shared.defaultUserID
        }
        
        do {
            self.name = try container.decode(String.self, forKey: .name)
        } catch {
            print("User name Decoding failed, default value assigned")
            self.name = SystemSetting.shared.defaultUserName
        }
        
        do {
            self.gender = try container.decode(Gender.self, forKey: .gender)
        } catch {
            print("User gender Decoding failed, default value assigned")
            self.gender = SystemSetting.shared.defaultUserGender
        }
        
        do {
            self.avatar = try container.decode(Data.self, forKey: .avatar)
        } catch {
            print("User Avatar Decoding failed, default value assigned")
            self.avatar = SystemSetting.shared.defaultUserAvatarData
        }
        
        do {
            
            self.energy = try container.decode(Int.self, forKey: .energy)
        } catch {
            print("User Energy Decoding failed, default value assigned")
            self.energy = SystemSetting.shared.defaultUserEnergy
        }
        
        do {
            self.items = try container.decode(Array<Item>.self, forKey: .items)
        } catch {
            print("User Items Decoding failed, default value assigned")
            self.items = SystemSetting.shared.defaultUserItems
        }
        
        do {
            self.purchasedType = try container.decode(PurchaseType.self, forKey: .purchasedType)
        } catch {
            print("User PurchasedType Decoding failed, default value assigned")
            self.purchasedType = .none
        }
        
        do {
            self.creationDate = try container.decode(CustomDate.self, forKey: .creationDate)
        } catch {
            print("User CreationDate Decoding failed, default value assigned")
            var creationDate: CustomDate = SystemSetting.shared.defaultCreationDate
            for item in items {
                if item.creationDate < creationDate {
                    creationDate = item.creationDate
                }
            }
            self.creationDate = creationDate
            print("User CreationDate \(creationDate.getDateString()) assigned")
        }
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        do {
            try container.encode(ID, forKey: .ID)
            try container.encode(name, forKey: .name)
            try container.encode(gender, forKey: .gender)
            try container.encode(avatar, forKey: .avatar)
            try container.encode(energy, forKey: .energy)
            try container.encode(items, forKey: .items)
            try container.encode(purchasedType, forKey: .purchasedType)
            try container.encode(creationDate, forKey: .creationDate)
        } catch {
            print("Encoding User failed")
            print(error)
        }
        
    }
    
    public func getAvatarImage() -> UIImage {
        return UIImage(data: avatar) ?? UIImage()
    }
    
    public func setAvatarImage(_ image: UIImage) {

        avatar = image.pngData() ?? #imageLiteral(resourceName: "Test").pngData()!

    }
    
    public func getOverAllProgress() -> Double {
        
        var overAllProgress = 0.0
        var allItemsTargetDays = 0
        var allItemsFinishedDays = 0
        
        for item in self.items {
            
            allItemsTargetDays += item.targetDays
            allItemsFinishedDays += item.finishedDays
        }
        
        if allItemsTargetDays != 0 {
            overAllProgress =  Double(allItemsFinishedDays) / Double(allItemsTargetDays)
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
    
    
    
    public func sortItems() {
        self.items.sort {
            ($0.state.priority, $0.type.priority) > ($1.state.priority, $1.type.priority)
        }
    }
    
    public func updateEnergy(by item: Item) {

        if item.lastEnergyConsecutiveDays >= self.energyChargingEfficiencyDays && !item.todayIsAddedEnergy {
            print("User has new eneger redeemed")
            self.energy += 1
            item.lastEnergyConsecutiveDays = 0
            item.energyRedeemDates.append(CustomDate.current)
            AppEngine.shared.userSetting.hasViewedEnergyUpdate = false
            AppEngine.shared.saveSetting()
        } else {
            print("User has not achived new energy yet")
        }
    }
    
//    public func add(punchInDates: Array<CustomDate>, to item: Item, finish: (() -> Void)?) {
//        item.add(punchInDates: punchInDates, finish: finish)
//    }
    
    public func getItemBy(_ ID: Int) -> Item? {
        for item in self.items {
            if item.ID == ID {
                return item
            }
        }
        
        return nil
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
            
            if item.energy >= self.energyChargingEfficiencyDays {
                item.energy = 0
            }
            item.hasSanction = false
        }
        
        self.blockItems()
    }
    
    public func removeItemWith(id: Int) {
        var index = 0
        for item in self.items {
            if item.ID == id {
                self.items.remove(at: index)
            }
            index += 1
        }
    }
    
    func blockItems() {
        
        if !self.isVip && self.items.count > SystemSetting.shared.nonVipUserMaxItems {
            var items = [Item]()
            for item in self.items {
                items.append(item)
            }
            
            items.sort {
                $0.creationDate < $1.creationDate
            }
            
            var index = 0
            for item in items {
                if index + 1 > SystemSetting.shared.nonVipUserMaxItems {
                    item.hasSanction = true
                } else {
                    item.hasSanction = false
                }
                index += 1
            }
        }
       
    }
    

}
