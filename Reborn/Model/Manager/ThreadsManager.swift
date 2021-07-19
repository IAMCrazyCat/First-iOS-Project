//
//  ThreadsManager.swift
//  Reborn
//
//  Created by Christian Liu on 19/7/21.
//

import Foundation

class LoadingItem {
    var item: Any
    var decription: String
    
    init(item: Any, description: String) {
        self.item = item
        self.decription = description
    }
}

class ThreadsManager {
    public static let shared = ThreadsManager()
    public var userIsLoading: Bool = false
    public var itemsAreLoading: Bool {
        if loadingItems.count == 0 {
            return true
        } else {
            return false
        }
    }
    private var loadingItems: [LoadingItem] = []
    private init() {
        indicateLoadingItems()
    }
    
    
    public func userDidLoad() {
        print("User did load all items")
        self.userIsLoading = false
    }
    
    public func add(_ loadingItem: LoadingItem) {
        self.loadingItems.append(loadingItem)
    }
    
    public func remove(_ loadingItem: LoadingItem) {
        var index = 0
        for storedLoadingItem in self.loadingItems {
            if storedLoadingItem === loadingItem {
                self.loadingItems.remove(at: index)
            }
            index += 1
        }
        
    }
    
    public func indicateLoadingItems() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            for loadingItem in self.loadingItems {
                print("\(CustomTime.current.getTimeString()) \(loadingItem.item) is loading in background thread, description: \(loadingItem.decription)")
            }
            if self.loadingItems.count == 0 {
                print("\(CustomTime.current.getTimeString()) No item is currently loading")
            }
        }
    }
}
