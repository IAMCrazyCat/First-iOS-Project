//
//  EditingItemStrategy.swift
//  Reborn
//
//  Created by Christian Liu on 7/2/21.
//

import Foundation
import UIKit
class EditingItemStrategy: NewItemViewStrategy {

    let newItemViewController: NewItemViewController
    
    init(newItemViewController: NewItemViewController) {
        self.newItemViewController = newItemViewController
    }
    
    func initializeUI() {
        
        newItemViewController.doneButton.setTitle("保存", for: .normal)
        newItemViewController.titleLabel.text = "编辑卡片"
     
            
        newItemViewController.itemNameTextfield.text = newItemViewController.item.name
            
        if newItemViewController.item.type == .persisting {
                newItemViewController.persistingTypeButton.isSelected = true
        } else if newItemViewController.item.type == .quitting {
                newItemViewController.quittingTypeButton.isSelected = true
            }
            
        switch newItemViewController.item.targetDays {
            case 7:
                newItemViewController.sevenDaysButton.isSelected = true
            case 30:
                newItemViewController.thirtyDaysButton.isSelected = true
            case 60:
                newItemViewController.sixtyDaysButton.isSelected = true
            case 100:
                newItemViewController.oneHundredDaysButton.isSelected = true
            case 365:
                newItemViewController.oneYearButton.isSelected = true
            default:
                newItemViewController.customTargetDaysButton.isSelected = true
            }
            
 
        
    }
        
    
    
    
    
    func doneButtonPressed(_ sender: UIButton) {
        
        
        newItemViewController.engine.saveUser(newItemViewController.engine.currentUser)
        newItemViewController.dismiss(animated: true) {
            self.newItemViewController.engine.notigyAllObservers()
        }
    }
    
}
