//
//  AppEngine.swift
//  Reborn
//
//  Created by Christian Liu on 19/12/20.
//

import Foundation
import UIKit

class AppEngine {
    
    static let shared = AppEngine()
    var itemArray = [Item]()
    var defaults = UserDefaults.standard
    var currentDate = Date()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("item.plist")
    let setting = SystemStyleSetting()
    var overAllProgress = 0.0

    private init() {
        
        //loadItems()
        print(dataFilePath!)
    }
    
    public func addItem(newItem: Item) {
        
        self.itemArray.append(newItem)
        print(itemArray)
    }
    
    public func saveItems() {
        let encoder = JSONEncoder()//PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
    }
    
    public func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = JSONDecoder() //PropertyListDecoder()
            
            do {
                self.itemArray = try decoder.decode([Item].self, from: data) // .self 可以提取数据类型
            } catch {
                print(error)
            }
        }
        
//        for index in 0 ..< self.itemArray.count {
//            let item = self.itemArray[index]
//            if item.type == ItemType.QUITTING {
//                self.itemArray[index] = item as! QuittingItem
//            } else {
//                self.itemArray[index] = item as! PersistingItem
//            }
//        }
    }
    
    
    public func getItemArray() -> Array<Item> {
 
        return itemArray
    }
    
    public func addItemCardsToHomeView(controller: HomeViewController) {
        
        var cordinateY: CGFloat = 0
        var tag: Int = 0
        for item in self.itemArray {
            
            let builder = ItemCardBuilder(item: item, corninateX: 0, cordinateY: cordinateY, punchInButtonTag: tag)
            builder.buildStandardView()
            controller.updateVerticalScrollView(newItemCard: builder.getBuiltItem() as! UIView, updatedHeight: cordinateY)
            cordinateY += setting.itemCardHeight + setting.itemCardGap
            tag += 1
        }
    }
    
    
    public func punchInItem(tag: Int) {
        itemArray[tag].punchIn(punchInDate: currentDate)
        print(itemArray[tag].punchInDate)
    }
    
    public func getFinishedDays(tag: Int) -> Int {
        return itemArray[tag].finishedDays
    }
    
    public func getDays(tag: Int) -> Int {
        return itemArray[tag].days
    }
    
    public func getOverAllProgress() -> Double {
        
        self.overAllProgress = 0
        for item in itemArray {
            let itemProgress = Double(item.finishedDays) / Double(item.days)
            self.overAllProgress += itemProgress
        }
        
        self.overAllProgress /= Double(itemArray.count)
        return self.overAllProgress
    }
    
    public func generateNewItemCard(name: String, type: String, days: Int) -> UIView {
        
        switch type {
        case "戒除":
            let builder = ItemCardBuilder(item: QuittingItem(name: name, days: days, finishedDays: 0, creationDate: currentDate), corninateX: 0, cordinateY: 0, punchInButtonTag: itemArray.count + 1)
            builder.buildStandardView()
            return builder.getBuiltItem() as! UIView
        case "坚持":
            let builder = ItemCardBuilder(item: PersistingItem(name: name, days: days, finishedDays: 0, creationDate: currentDate), corninateX: 0, cordinateY: 0, punchInButtonTag: itemArray.count + 1)
            builder.buildStandardView()
            return builder.getBuiltItem() as! UIView
        default:
            let builder = ItemCardBuilder(item: Item(name: name, days: days, finishedDays: 0, creationDate: currentDate, type: .UNDEFINED), corninateX: 0, cordinateY: 0, punchInButtonTag: itemArray.count + 1)
            builder.buildStandardView()
            return builder.getBuiltItem() as! UIView
        }
    }
    
    public func generatePopUp(popUpType: PopUpType) -> PopUpView {
        
        let popUpView = ButtomPopUpBuilder(popUpType: popUpType).buildPopUpView()
        return popUpView
    }
    
  
    
}
