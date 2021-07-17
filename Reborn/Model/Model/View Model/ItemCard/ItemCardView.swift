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
    var icon: UIImage
    var titileLabel: UILabel
    var frequencyLabel: UILabel
    var notificationIcon: UIImage
    var progressBar: UIView
    var punchInButton: UIButton
    var detatilsButton: UIButton
    var rightButton: UIButton
    
    public init(frame: CGRect, item: Item, icon: UIImage, titileLabel: UILabel, frequencyLabel: UILabel, notificationIcon: UIImage, progressBar: UIView, punchInButton: UIButton, detatilsButton: UIButton, rightButton: UIButton) {
        self.item = item
        self.icon = icon
        self.titileLabel = titileLabel
        self.frequencyLabel = frequencyLabel
        self.notificationIcon = notificationIcon
        self.progressBar = progressBar
        self.punchInButton = punchInButton
        self.detatilsButton = detatilsButton
        self.rightButton = rightButton
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func itemPunchInButtonPressed(_ sender: UIButton!) {
        let ID = Int(sender.accessibilityValue ?? "-1")!
        AppEngine.shared.currentUser.updateItem(with: ID)
        AppEngine.shared.saveUser()
        AppEngine.shared.notifyUIObservers(withIdentifier: "HomeViewController")
        AppEngine.shared.notifyUIObservers(withIdentifier: "ItemManagementViewController")
 
        if let item = AppEngine.shared.currentUser.getItemBy(ID), item.state == .completed {
            UIApplication.shared.getCurrentViewController()?.presentItemCompletedPopUp(for: item)
        }
        
    
    }
    
    @objc func itemDetailsButtonPressed(_ sender: UIButton!) {
        Vibrator.vibrate(withImpactLevel: .medium)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let senderViewController = sender.findViewController(),
              let navigationController = senderViewController.navigationController,
              let itemDetailViewController = storyBoard.instantiateViewController(withIdentifier: "ItemDetailView") as? ItemDetailViewController
        else {
            return
        }
        
        itemDetailViewController.item = AppEngine.shared.currentUser.items[sender.tag]
        itemDetailViewController.lastViewController = senderViewController
        navigationController.pushViewController(itemDetailViewController, animated: true)

    }
}
