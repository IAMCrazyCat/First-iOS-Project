//
//  AddingItemStrategy.swift
//  Reborn
//
//  Created by Christian Liu on 7/2/21.
//

import Foundation
import UIKit

class AddingItemStrategy: NewItemViewStrategy {
    
    let newItemViewController: NewItemViewController
    
    init(newItemViewController: NewItemViewController) {
        self.newItemViewController = newItemViewController
    }
    
    
    func initializeUI() {
        
    }
    
    
    
    func doneButtonPressed(_ sender: UIButton) {
        
        print("DONEDONE")
        newItemViewController.engine.addItem(newItem: newItemViewController.item)
        newItemViewController.dismiss(animated: true) {
            self.newItemViewController.engine.notigyAllObservers()
        }
    }
}
