//
//  ItemCardAction.swift
//  Reborn
//
//  Created by Christian Liu on 17/2/21.
//

import Foundation
import UIKit
import WidgetKit
class Actions {
    
    static var shared: Actions = Actions()
    
    private init() {
       
    }
    
    static var punchInAction: Selector = #selector(Actions.shared.itemPunchInButtonPressed)
    static var detailsViewAction: Selector = #selector(Actions.shared.itemDetailsButtonPressed(_:))
    static var themeColorChangedAction: Selector = #selector(Actions.shared.themeColorButtonPressed(_:))
    static var setUpTextFieldChangedAction: Selector = #selector(Actions.shared.setUpTextFieldTapped(_:))
    static var appApperenceModeChangedAction: Selector = #selector(Actions.shared.appAppearanceOptionButtonPressed(_:))
    static var goToSystemSettingAction: Selector = #selector(Actions.shared.goToSystemSettingButtonPressed(_:))

    
    @objc func itemPunchInButtonPressed(_ sender: UIButton!) {
        AppEngine.shared.currentUser.updateItem(withTag: sender.tag)
        AppEngine.shared.saveUser()
        AppEngine.shared.notifyAllUIObservers()
        
        let item = AppEngine.shared.currentUser.getItemBy(tag: sender.tag)
        if item.state == .completed {
            UIApplication.shared.getTopViewController()?.presentItemCompletedPopUp(for: item)
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
            AppEngine.shared.userSetting.themeColor = newThemeColor ?? ThemeColor.blue
            AppEngine.shared.saveSetting()
            AppEngine.shared.notifyAllUIObservers()
        }
        
    }
    
    @objc func setUpTextFieldTapped(_ sender: UITextField!) {

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let setUpViewController = storyBoard.instantiateViewController(withIdentifier: "SetUpViewController") as? SetUpViewController {
    
        }

    }
    
    @objc func appAppearanceOptionButtonPressed(_ sender: UIButton!) {
        
  
        if sender.accessibilityIdentifier == "FollowSystemButton" {
            AppEngine.shared.userSetting.appAppearanceMode = .followSystem
        } else if sender.accessibilityIdentifier == "LightModeButton" {
            AppEngine.shared.userSetting.appAppearanceMode = .lightMode
        } else if sender.accessibilityIdentifier == "DarkModeButton" {
            AppEngine.shared.userSetting.appAppearanceMode = .darkMode
        }
        Vibrator.vibrate(withImpactLevel: .light)
        AppEngine.shared.saveSetting()
        AppEngine.shared.notifyAllUIObservers()
        
    }
    
    @objc func goToSystemSettingButtonPressed(_ sender: UIButton!) {
        AppEngine.shared.goToDeviceSystemSetting()
    }
    
    
}
