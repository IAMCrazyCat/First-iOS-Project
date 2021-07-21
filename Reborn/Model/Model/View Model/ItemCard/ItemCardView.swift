//
//  ItemCardView.swift
//  Reborn
//
//  Created by Christian Liu on 17/7/21.
//

import Foundation
import UIKit
class ItemCardView: UIView {
    var item: Item
    var contentView: UIView = UIView()
  
    public init(frame: CGRect, item: Item, contentView: UIView) {
        self.item = item
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    public func updateItem() {
        
        if !item.isPunchedIn() {
            item.punchIn()
            if self.item.state == .completed {
                UIApplication.shared.getCurrentViewController()?.presentItemCompletedPopUp(for: self.item)
            }
            
            Vibrator.vibrate(withNotificationType: .success)
        } else {
            item.revokePunchIn()
            Vibrator.vibrate(withImpactLevel: .light)
        }
        
        AppEngine.shared.currentUser.updateEnergy(by: item)
        
    }
    
 
    
    public func updateContentView() {
        self.removeAllSubviews()
        self.contentView = ItemCardViewBuilder(item: self.item, frame: self.frame, isInteractable: true).buildContentView()
        self.addSubview(self.contentView)
    }
    
    
    @objc func itemPunchInButtonPressed(_ sender: UIButton!) {
        
        updateItem()
        UIManager.shared.updateUIAfterPunchInButtonPressed(item)
        AppEngine.shared.saveUser()

        
    }
    
    @objc func itemDetailsButtonPressed(_ sender: UIButton!) {
        Vibrator.vibrate(withImpactLevel: .medium)

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let senderViewController = sender.findViewController(),
              let navigationController = senderViewController.navigationController,
              let itemDetailViewController = storyBoard.instantiateViewController(withIdentifier: "ItemDetailViewController") as? ItemDetailViewController
        else {
            return
        }
        
        itemDetailViewController.item = self.item
        itemDetailViewController.lastViewController = senderViewController
        navigationController.pushViewController(itemDetailViewController, animated: true)

    }
}
