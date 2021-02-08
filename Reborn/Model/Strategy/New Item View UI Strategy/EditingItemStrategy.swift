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
                newItemViewController.customTargetButton.isSelected = true
            }
            
 
        newItemViewController.updateUI()
        self.initializePreviewItemCard()
    }
        
    
    func updatePreViewItemCard() {

        if newItemViewController.frequency != nil {
            newItemViewController.item.setFreqency(frequency: newItemViewController.frequency!)
        }

        
        let builder = ItemViewBuilder(item: newItemViewController.item, width: newItemViewController.setting.screenFrame.width - 2 * newItemViewController.setting.mainPadding, height: newItemViewController.setting.itemCardHeight, corninateX: 0, cordinateY: 0)
  
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        newItemViewController.preViewItemCard = builder.buildItemCardView()
        newItemViewController.previewItemCardTag = newItemViewController.preViewItemCard!.tag
 
        newItemViewController.preViewItemCard!.center = newItemViewController.middleContentView.center
        newItemViewController.middleContentView.addSubview(newItemViewController.preViewItemCard!)
    }
    
   
    
    func initializePreviewItemCard() {
        let builder = ItemViewBuilder(item: newItemViewController.item, width: newItemViewController.setting.screenFrame.width - 2 * newItemViewController.setting.mainPadding, height: newItemViewController.setting.itemCardHeight, corninateX: 0, cordinateY: 0)
  
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        newItemViewController.preViewItemCard = builder.buildItemCardView()
        newItemViewController.previewItemCardTag = newItemViewController.preViewItemCard!.tag
 
        newItemViewController.preViewItemCard!.center = newItemViewController.middleContentView.center
        newItemViewController.middleContentView.addSubview(newItemViewController.preViewItemCard!)
    }
    
    
    func doneButtonPressed(_ sender: UIButton) {
        newItemViewController.engine.dismissNewItemViewAndSaveItem(viewController: newItemViewController)
        
    }
    
}
