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
    
    func isRedyToFinish() -> Bool {
        var isRedyToFinish: Bool = false
        
        if newItemViewController.itemNameTextfield.text != ""
            && newItemViewController.selectedTypeButton != nil
            && newItemViewController.selectedFrequencyButton != nil
            && newItemViewController.selectedTargetDaysButton != nil {
            
            isRedyToFinish = true
            
        } else {
            
            isRedyToFinish = false
            newItemViewController.preViewItemCard.shake()
        }
        
        
        return isRedyToFinish
    }
    
    func doneButtonPressed(_ sender: UIButton) {
        
        if isRedyToFinish() {
            newItemViewController.engine.addItem(newItem: newItemViewController.item)
            newItemViewController.dismiss(animated: true) {
                self.newItemViewController.engine.notigyAllObservers()
        }
       
        }
    }
}
