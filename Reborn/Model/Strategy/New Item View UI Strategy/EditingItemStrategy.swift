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
            newItemViewController.selectedTypeButton = newItemViewController.persistingTypeButton
        } else if newItemViewController.item.type == .quitting {
            newItemViewController.quittingTypeButton.isSelected = true
            newItemViewController.selectedTypeButton = newItemViewController.quittingTypeButton
        }
            
        switch newItemViewController.item.targetDays {
            case 7:
                newItemViewController.sevenDaysButton.isSelected = true
                newItemViewController.selectedTargetDaysButton = newItemViewController.sevenDaysButton
            case 30:
                newItemViewController.thirtyDaysButton.isSelected = true
                newItemViewController.selectedTargetDaysButton = newItemViewController.thirtyDaysButton
            case 60:
                newItemViewController.sixtyDaysButton.isSelected = true
                newItemViewController.selectedTargetDaysButton = newItemViewController.sixtyDaysButton
            case 100:
                newItemViewController.oneHundredDaysButton.isSelected = true
                newItemViewController.selectedTargetDaysButton = newItemViewController.oneHundredDaysButton
            case 365:
                newItemViewController.oneYearButton.isSelected = true
                newItemViewController.selectedTargetDaysButton = newItemViewController.oneYearButton
            default:
                newItemViewController.customTargetDaysButton.isSelected = true
                newItemViewController.selectedTargetDaysButton = newItemViewController.customTargetDaysButton
                
            }
            
        switch newItemViewController.item.frequency.title {
        case "每天":
            newItemViewController.everydayFrequencyButton.isSelected = true
            newItemViewController.selectedFrequencyButton = newItemViewController.everydayFrequencyButton
        case "每两天":
            newItemViewController.everyTwoDaysFreqencyButton.isSelected = true
            newItemViewController.selectedFrequencyButton = newItemViewController.everyTwoDaysFreqencyButton
        case "每周":
            newItemViewController.everyWeekFreqencyButton.isSelected = true
            newItemViewController.selectedFrequencyButton = newItemViewController.everyWeekFreqencyButton
        case "每月":
            newItemViewController.everyMonthFrequencyButton.isSelected = true
            newItemViewController.selectedFrequencyButton = newItemViewController.everyMonthFrequencyButton
        case "自由打卡":
            newItemViewController.freedomFrequencyButton.isSelected = true
            newItemViewController.selectedFrequencyButton = newItemViewController.freedomFrequencyButton
        default:
            newItemViewController.customFrequencyButton.isSelected = true
            newItemViewController.selectedFrequencyButton = newItemViewController.customFrequencyButton
        }
 
        
    }
    
    func showPopUp(popUpType: PopUpType) {
        if popUpType == .customTargetDays {
            newItemViewController.engine.showBottomPopUp(popUpType, dataStartIndex: newItemViewController.item.finishedDays, from: newItemViewController)
        } else if popUpType == .customFrequency {
            newItemViewController.engine.showBottomPopUp(popUpType, from: newItemViewController)
        }
        
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
            newItemViewController.engine.saveUser(newItemViewController.engine.currentUser)
            newItemViewController.dismiss(animated: true) {
                self.newItemViewController.engine.notigyAllObservers()
            }
        }
    }
    
}
