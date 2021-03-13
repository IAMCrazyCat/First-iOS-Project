//
//  ItemCardAction.swift
//  Reborn
//
//  Created by Christian Liu on 17/2/21.
//

import Foundation
import UIKit

class Actions {
    
    static var shared: Actions = Actions()
    
    private init() {
       
    }
    
    static var punchInAction: Selector = #selector(Actions.shared.itemPunchInButtonPressed)
    static var detailsViewAction: Selector = #selector(Actions.shared.itemDetailsButtonPressed(_:))
    static var themeColorChangedAction: Selector = #selector(Actions.shared.themeColorButtonPressed(_:))
    static var setUpTextFieldChangedAction: Selector = #selector(Actions.shared.setUpTextFieldTapped(_:))
    @objc func itemPunchInButtonPressed(_ sender: UIButton!) {
        AppEngine.shared.updateItem(tag: sender.tag)
        AppEngine.shared.notifyAllUIObservers()
        
        let item = AppEngine.shared.getItemBy(tag: sender.tag)
        if item.state == .completed {
            UIApplication.shared.getTopViewController()?.showItemCompletedPopUp(for: item)
        }
    }
    
    @objc func itemDetailsButtonPressed(_ sender: UIButton!) {
        
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
    
    @objc func themeColorButtonPressed(_ sender: UIButton!) {
        var newThemeColor: ThemeColor? = nil
        for themeColor in ThemeColor.allCases {
            if themeColor.rawValue == sender.accessibilityValue {
                newThemeColor = themeColor
            }
        }
        
        if newThemeColor != nil {
            Vibrator.vibrate(withImpactLevel: .light)
            AppEngine.shared.changeThemeColor(to: newThemeColor!)
        }
        
    }
    
    @objc func setUpTextFieldTapped(_ sender: UITextField!) {

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let setUpViewController = storyBoard.instantiateViewController(withIdentifier: "SetUpViewController") as? SetUpViewController {


    
        }
        
       
    }
}
