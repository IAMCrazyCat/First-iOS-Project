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
    
    func show(_ popUpType: PopUpType) {
        newItemViewController.present(popUpType)
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
            newItemViewController.promptLabel.isHidden = false
            
            if newItemViewController.selectedFrequencyButton == nil {
                newItemViewController.verticalScrollView.scrollToBottom(animated: true)
            } else if newItemViewController.itemNameTextfield.text == "" {
                newItemViewController.verticalScrollView.scrollToTop(animated: true)
            }
        }
        
        
        return isRedyToDismiss
    }
    
    
    func doneButtonPressed(_ sender: UIButton) {
        if isRedyToDismiss() {

            let VIPStrategy: VIPStrategy = AddNewItemStrategy(newItemViewController: newItemViewController)
            VIPStrategy.performStrategy()
        }
        
    }
}
