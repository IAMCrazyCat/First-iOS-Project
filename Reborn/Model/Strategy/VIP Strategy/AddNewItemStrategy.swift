//
//  AddNewItemStrategy.swift
//  Reborn
//
//  Created by Christian Liu on 6/3/21.
//

import Foundation
class AddNewItemStrategy: VIPStrategyImpl {
    let newItemViewController: NewItemViewController
    
    init(newItemViewController: NewItemViewController) {
        self.newItemViewController = newItemViewController
    }
    
    override func performVIPStrategy() {
        super.performVIPStrategy()
        addItem()
    }
    
    override func performNonVIPStrategy() {
        super.performNonVIPStrategy()
        if AppEngine.shared.currentUser.items.count >= 3 {
            print("Only VIP user can create more than 3 items")
            newItemViewController.showPurchaseView()
        } else {
            addItem()
        }
    }
    
    func addItem() {
        newItemViewController.engine.add(newItem: newItemViewController.item)
        newItemViewController.dismiss(animated: true) {
            self.newItemViewController.engine.notifyAllUIObservers()
        }
    }
}