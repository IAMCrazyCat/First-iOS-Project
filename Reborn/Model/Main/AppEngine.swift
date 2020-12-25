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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("quittingItem.plist")
    //let persistingDataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("persistingItem.plist")
    
    init() {
        
        loadItem()
        
    }
    
    func saveItem(newItem: Item) {
        
            
        self.itemArray.append(newItem)
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
    
    }
    
    func loadItem() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            
            do {
                itemArray = try decoder.decode([Item].self, from: data) // .self 可以提取数据类型
            } catch {
                print(error)
            }
        }
        
    }
    
    func getItemArray() -> Array<Item> {
        print("\(itemArray.count) HERERERE")
        return itemArray
    }
    
}
