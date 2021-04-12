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

        addItem()
    }
    
    override func performNonVIPStrategy() {

        if AppEngine.shared.currentUser.items.count >= 2 {
            print("Only VIP user can create more than 2 items")
            newItemViewController.presentViewController(withIentifier: "PurchaseViewController")
        } else {
            addItem()
        }
    }
    
    func addItem() {
        AppEngine.shared.currentUser.add(newItem: newItemViewController.item)
        AppEngine.shared.saveUser()
        newItemViewController.dismiss(animated: true) {
            self.newItemViewController.engine.notifyAllUIObservers()
        }
    }
}
