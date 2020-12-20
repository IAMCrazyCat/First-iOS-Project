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
    
    init() {
        
        if let savedArray = defaults.array(forKey: "SavedQuittingItemArray") as? [QuittingItem] {
            quittingItemArray = savedArray
        }
        
        if let savedArray = defaults.array(forKey: "SavedPersistingItemArray") as? [PersistingItem] {
            persistingItemArray = savedArray
        }
    }
    
    func addNewItem(item: Item) {
        if item is QuittingItem {
            quittingItemArray.append(item as! QuittingItem)
            defaults.setValue(quittingItemArray, forKey: "SavedQuittingItemArray")
        } else if item is PersistingItem{
            persistingItemArray.append(item as! PersistingItem)
            defaults.setValue(persistingItemArray, forKey: "SavedPersistingItemArray")
        } else {
            print("Unknown item type")
        }
    }
}
