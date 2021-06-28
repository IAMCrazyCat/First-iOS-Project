//
//  File.swift
//  Reborn
//
//  Created by Christian Liu on 2/1/21.
//

import Foundation
import UIKit
import GoogleMobileAds
import MessageUI

extension UIViewController: UIViewControllerTransitioningDelegate  {
    
    private func present(to presenting: PopUpViewController) {
  
        let detailsTransitioningDelegate = PopUpViewTransitioningDelegate(from: self, to: presenting)
        presenting.modalPresentationStyle = .custom
        presenting.transitioningDelegate = detailsTransitioningDelegate
        self.present(presenting, animated:true, completion: nil)
     }
    

    
    func presentViewController(withIentifier identifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toViewController = storyboard.instantiateViewController(withIdentifier: identifier)
        
        if let purchaseViewController = toViewController as? PurchaseViewController {
            purchaseViewController.lastViewController = self
        }
        self.present(toViewController, animated: true, completion: nil)
        
    }
    
    func pushViewController(withIentifier identifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toViewController = storyboard.instantiateViewController(withIdentifier: identifier)
        
        if let purchaseViewController = toViewController as? PurchaseViewController {
            purchaseViewController.lastViewController = self
        }
        
        if let navigationController = self.navigationController {
            navigationController.pushViewController(toViewController, animated: true)
        }
        
        
        
    }
    
    func present(_ popUpType: PopUpType, size: PopUpSize = .small, animation animationType: PopUpAnimationType = .slideInToBottom, dataStartIndex: Int = 0) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let popUpViewController = storyboard.instantiateViewController(withIdentifier: "PopUpViewController") as? PopUpViewController {
            
            AppEngine.shared.delegate = self as? PopUpViewDelegate
            
            switch popUpType {
            case .customFrequencyPopUp:
                popUpViewController.popUp = CustomFrequencyPopUp(presentAnimationType: animationType, size: size, dataStartIndex: dataStartIndex, popUpViewController: popUpViewController)
            case .customItemNamePopUp:
                popUpViewController.popUp = CustomItemNamePopUpView(presentAnimationType: animationType, size: size, popUpViewController: popUpViewController)
            case .customTargetDaysPopUp:
                popUpViewController.popUp = CustomTargetDaysPopUp(presentAnimationType: animationType, size: size, dataStartIndex: dataStartIndex, popUpViewController: popUpViewController)
            case .customThemeColorPopUp:
                popUpViewController.popUp = CustomThemeColorPopUp(presentAnimationType: animationType, size: size, popUpViewController: popUpViewController)
            case .customUserInformationPopUp:
                popUpViewController.popUp = CustomUserInformationPopUp(presentAnimationType: animationType, size: size, popUpViewController: popUpViewController)
            case .notificationTimePopUp:
                
                if NotificationManager.shared.isNotificationEnabled() {
                    popUpViewController.popUp = NotificationTimePopUp(presentAnimationType: animationType, size: size, popUpViewController: popUpViewController)
                } else {
                    popUpViewController.popUp = NotificationTimePopUp(presentAnimationType: animationType, size: size, popUpViewController: popUpViewController)
                }
            case .itemCompletedPopUp:
                print("You should not use this function")
                print("Use 'showItemCompletedPopUp(for: Item)' instead")
            case .lightAndDarkModePopUp:
                popUpViewController.popUp = LightAndDarkModePopUp(presentAnimationType: animationType, size: size, popUpViewController: popUpViewController)
            case .everyWeekFreqencyPopUp:
                print("You should not use this function")
                print("Use 'present(_ popUpType: PopUpType, size: PopUpSize = .small, animation animationType: PopUpAnimationType = .slideInToBottom, newFrequency: NewFrequency)' instead")
            case .everyMonthFreqencyPopUp:
                print("You should not use this function")
                print("Use 'present(_ popUpType: PopUpType, size: PopUpSize = .small, animation animationType: PopUpAnimationType = .slideInToBottom, newFrequency: NewFrequency)' instead")
            case .newFeaturesPopUp:
                print("You should not use this function")
                print("Use present(size: PopUpSize = .small, animation animationType: PopUpAnimationType = .slideInToBottom, newFeatures: Array<CustomData>)")
            }
            
            self.present(to: popUpViewController)
        }

    }
    
    func present(_ popUpType: PopUpType, size: PopUpSize = .small, animation animationType: PopUpAnimationType = .slideInToBottom, newFrequency: NewFrequency?) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let popUpViewController = storyboard.instantiateViewController(withIdentifier: "PopUpViewController") as? PopUpViewController {
            
            AppEngine.shared.delegate = self as? PopUpViewDelegate
            
            switch popUpType {
            case .everyWeekFreqencyPopUp:
                popUpViewController.popUp = EveryWeekFrequencyPopUp(presentAnimationType: animationType, popUpViewController: popUpViewController, newFrequency: newFrequency)
            case .everyMonthFreqencyPopUp:
                popUpViewController.popUp = EveryMonthFrequencyPopUp(presentAnimationType: animationType, popUpViewController: popUpViewController, newFrequency: newFrequency)
            case .itemCompletedPopUp:
                print("You should not use this function")
                print("Use 'showItemCompletedPopUp(for: Item)' instead")
            case .newFeaturesPopUp:
                print("You should not use this function")
                print("Use present(size: PopUpSize = .small, animation animationType: PopUpAnimationType = .slideInToBottom, newFeatures: Array<CustomData>)")
            default:
                print("You should not use this function")
                print("present(_ popUpType: PopUpType, size: PopUpSize = .small, animation animationType: PopUpAnimationType = .slideInToBottom, dataStartIndex: Int = 0)")
            }
            
            self.present(to: popUpViewController)
        }

    }
    
    func present(size: PopUpSize = .small, animation animationType: PopUpAnimationType = .slideInToBottom, newFeatures: Array<CustomData>) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let popUpViewController = storyboard.instantiateViewController(withIdentifier: "PopUpViewController") as? PopUpViewController {
            
            AppEngine.shared.delegate = self as? PopUpViewDelegate
            popUpViewController.popUp = NewFeaturesPopUp(presentAnimationType: animationType, size: size, popUpViewController: popUpViewController, newFeatures: newFeatures)
            self.present(to: popUpViewController)
        }

    }
    
    
    
    func presentItemCompletedPopUp(for item: Item) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let popUpViewController = storyboard.instantiateViewController(withIdentifier: "PopUpViewController") as? PopUpViewController {
            
            AppEngine.shared.delegate = self as? PopUpViewDelegate
            popUpViewController.popUp = ItemCompletedPopUp(item: item, presentAnimationType: .fadeInFromCenter, size: .medium, popUpViewController: popUpViewController)
            self.present(to: popUpViewController)
        }
    }
    
    func updateViewStyle() {
        
        if AppEngine.shared.userSetting.appAppearanceMode == .lightMode {
            self.view.window?.overrideUserInterfaceStyle = .light
        } else if AppEngine.shared.userSetting.appAppearanceMode == .darkMode {
            self.view.window?.overrideUserInterfaceStyle = .dark
        } else {
            self.view.window?.overrideUserInterfaceStyle = .unspecified
        }
    }
    
    func setNavigationBarAppearance(withBorder: Bool = false, backgroundColor: UIColor = AppEngine.shared.userSetting.themeColorAndBlackContent, textColor: UIColor = AppEngine.shared.userSetting.smartLabelColorAndWhiteAndThemeColor.brightColor) {
        withBorder ? () : navigationController?.navigationBar.removeBorder()
        navigationController?.navigationBar.barTintColor = backgroundColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor]
        navigationItem.rightBarButtonItem?.tintColor = AppEngine.shared.userSetting.smartLabelColorAndWhite.brightColor
        navigationItem.leftBarButtonItem?.tintColor = AppEngine.shared.userSetting.smartLabelColorAndWhiteAndThemeColor
    }
    
  
   
}

class UpdateStyleMode: UIViewController {
    
}
