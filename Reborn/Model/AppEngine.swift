//
//  AppEngine.swift
//  Reborn
//
//  Created by Christian Liu on 19/12/20.
//

import Foundation
class AppEngine {
    var quittingItemArray: Array<QuittingItem> = []
    var persistingItemArray: Array<PersistingItem> = []
    var defaults = UserDefaults.standard
    var currentDate = Date()
    init() {
        
        if let savedArray = defaults.array(forKey: "SavedQuittingItemArray") as? [QuittingItem] {
            quittingItemArray = savedArray
            print(quittingItemArray)
        }
        
        if let savedArray = defaults.array(forKey: "SavedPersistingItemArray") as? [PersistingItem] {
            persistingItemArray = savedArray
            print(persistingItemArray)
        }
    }
    
    func saveNewItem(item: Item) {
        if item is QuittingItem {
            
            self.quittingItemArray.append(item as! QuittingItem)
            let codedArray = try! NSKeyedArchiver.archivedData(withRootObject: self.quittingItemArray, requiringSecureCoding: true)
            self.defaults.setValue(codedArray, forKey: "SavedQuittingItemArray")
            
        } else if item is PersistingItem{
            
            let codedArray = try! NSKeyedArchiver.archivedData(withRootObject: self.persistingItemArray, requiringSecureCoding: true)
            self.persistingItemArray.append(item as! PersistingItem)
            self.defaults.setValue(codedArray, forKey: "SavedPersistingItemArray")
        } else {
            print("Unknown item type")
        }
    }
}
