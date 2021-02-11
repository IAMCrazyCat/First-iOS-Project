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
    
    func showPopUp(popUpType: PopUpType) {
        newItemViewController.engine.showBottomPopUp(popUpType, from: newItemViewController)
    }
    
    func isRedyToDismiss() -> Bool {
        var isRedyToDismiss: Bool = false
        
        if newItemViewController.itemNameTextfield.text != ""
            && newItemViewController.selectedTypeButton != nil
            && newItemViewController.selectedFrequencyButton != nil
            && newItemViewController.selectedTargetDaysButton != nil {
            
            isRedyToDismiss = true
            
        } else {
            
            isRedyToDismiss = false
            newItemViewController.preViewItemCard.shake()
        }
        
        
        return isRedyToDismiss
    }
    
    
    func doneButtonPressed(_ sender: UIButton) {
        
        if isRedyToDismiss() {
            newItemViewController.engine.addItem(newItem: newItemViewController.item)
            newItemViewController.dismiss(animated: true) {
                self.newItemViewController.engine.notigyAllObservers()
        }
       
        }
    }
}
