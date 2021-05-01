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
        
        newItemViewController.quittingTypeButton.alpha = 0.5
        newItemViewController.persistingTypeButton.alpha = 0.5
        newItemViewController.quittingTypeButton.isUserInteractionEnabled = false
        newItemViewController.persistingTypeButton.isUserInteractionEnabled = false
        
        newItemViewController.doneButton.setTitle("保存", for: .normal)
        newItemViewController.titleLabel.text = "编辑项目"
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
            case 100:
                newItemViewController.oneHundredDaysButton.isSelected = true
                newItemViewController.selectedTargetDaysButton = newItemViewController.oneHundredDaysButton
            default:
                newItemViewController.customTargetDaysButton.isSelected = true
                newItemViewController.selectedTargetDaysButton = newItemViewController.customTargetDaysButton
                
            }
//        if newItemViewController.item.finishedDays 7 ..< 30:
//            newItemViewController.sevenDaysButton.alpha = 0.5
//            newItemViewController.sevenDaysButton.isUserInteractionEnabled = false
//        case 30 ..< 60:
//            newItemViewController.thirtyDaysButton.alpha = 0.5
//            newItemViewController.thirtyDaysButton.isUserInteractionEnabled = false
//        case 60 ..< 100:
//            newItemViewController.sixtyDaysButton.alpha = 0.5
//            newItemViewController.sixtyDaysButton.isUserInteractionEnabled = false
//        case 100 ..< 365:
//            newItemViewController.oneHundredDaysButton.alpha = 0.5
//            newItemViewController.oneHundredDaysButton.isUserInteractionEnabled = false
//        }
            
        switch newItemViewController.item.frequency.dataModel.title {
        case "每天":
            newItemViewController.everydayFrequencyButton.isSelected = true
            newItemViewController.selectedFrequencyButton = newItemViewController.everydayFrequencyButton
        case "每周":
            newItemViewController.everyWeekFreqencyButton.isSelected = true
            newItemViewController.selectedFrequencyButton = newItemViewController.everyWeekFreqencyButton
        case "每月":
            newItemViewController.everyMonthFrequencyButton.isSelected = true
            newItemViewController.selectedFrequencyButton = newItemViewController.everyMonthFrequencyButton
        default:
            newItemViewController.customFrequencyButton.isSelected = true
            newItemViewController.selectedFrequencyButton = newItemViewController.customFrequencyButton
        }
        
        
        let secondInstructionLabel = newItemViewController.verticalScrollView.getSubviewBy(idenifier: "SecondInstructionLabel")
        let deleteItemButton = UIButton()
        deleteItemButton.frame = CGRect(x: SystemSetting.shared.mainPadding, y: ((secondInstructionLabel?.frame.maxY) ?? newItemViewController.verticalContentView.frame.height - SystemSetting.shared.mainButtonHeight - 20) + 20 , width: newItemViewController.verticalContentView.frame.width - 2 * SystemSetting.shared.mainPadding, height: SystemSetting.shared.mainButtonHeight)
       
        deleteItemButton.setTitle("删除项目", for: .normal)
        deleteItemButton.setBackgroundColor(AppEngine.shared.userSetting.redColor, for: .normal)
        deleteItemButton.addTarget(newItemViewController, action: #selector(newItemViewController.deleteItemButtonPressed(_:)), for: .touchUpInside)
        
        
        
        newItemViewController.verticalContentView.addSubview(deleteItemButton)
        newItemViewController.verticalScrollViewContentViewHeightConstraint.constant = deleteItemButton.frame.maxY + SystemSetting.shared.contentToScrollViewBottomDistance
        newItemViewController.verticalScrollView.layoutIfNeeded()
        
        deleteItemButton.leftAnchor.constraint(equalTo: newItemViewController.verticalContentView.leftAnchor, constant: SystemSetting.shared.mainPadding).isActive = true
        deleteItemButton.rightAnchor.constraint(equalTo: newItemViewController.verticalContentView.rightAnchor, constant: -SystemSetting.shared.mainPadding).isActive = true
        deleteItemButton.topAnchor.constraint(equalTo: newItemViewController.secondInstructionLabel.bottomAnchor, constant: SystemSetting.shared.mainGap).isActive = true
        deleteItemButton.proportionallySetHeightWithScreen()
        deleteItemButton.setCornerRadius()
        newItemViewController.verticalScrollView.layoutIfNeeded()
        newItemViewController.verticalScrollViewContentViewHeightConstraint.constant = deleteItemButton.frame.maxY + SystemSetting.shared.contentToScrollViewBottomDistance
    }
    
    func show(_ popUpType: PopUpType) {
        if popUpType == .customTargetDaysPopUp {
            newItemViewController.present(popUpType, dataStartIndex: newItemViewController.item.finishedDays)
        } else if popUpType == .customFrequencyPopUp {
            newItemViewController.present(popUpType)
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
            newItemViewController.promptLabel.isHidden = false
        }
        
        return isRedyToDismiss
    }
    
    
    func doneButtonPressed(_ sender: UIButton) {
        
        if isRedyToDismiss() {
            newItemViewController.engine.saveUser(newItemViewController.engine.currentUser)
            newItemViewController.dismiss(animated: true) {
                self.newItemViewController.engine.notifyAllUIObservers()
            }
        }
    }
    
}
