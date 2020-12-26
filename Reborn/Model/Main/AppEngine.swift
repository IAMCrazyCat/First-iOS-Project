//
//  AppEngine.swift
//  Reborn
//
//  Created by Christian Liu on 19/12/20.
//

import Foundation
class AppEngine {
    var itemArray = [Item]()
    var defaults = UserDefaults.standard
    var currentDate = Date()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("item.plist")
    //let persistingDataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("persistingItem.plist")
    
    init() {
        
        loadItem()
        print(dataFilePath!)
    }
    
    func saveItem(newItem: Item) {
        
     
        self.itemArray.append(newItem)
        print(itemArray)
     
        let encoder = JSONEncoder()//PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
    
    }
    
    func loadItem() {
        
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
    
    func getItemArray() -> Array<Item> {
 
        return itemArray
    }
    
}
