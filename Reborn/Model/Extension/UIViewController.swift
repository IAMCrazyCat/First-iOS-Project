//
//  File.swift
//  Reborn
//
//  Created by Christian Liu on 2/1/21.
//

import Foundation
import UIKit

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
        self.present(toViewController, animated: true, completion: nil)

    }
    
    func present(_ popUpType: PopUpType, animation animationType: PopUpAnimationType = .slideInToBottom, dataStartIndex: Int = 0) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let popUpViewController = storyboard.instantiateViewController(withIdentifier: "PopUpViewController") as? PopUpViewController {
            
            AppEngine.shared.delegate = self as? PopUpViewDelegate
            
            switch popUpType {
            case .customFrequencyPopUp:
                popUpViewController.popUp = CustomFrequencyPopUp(presentAnimationType: animationType, dataStartIndex: dataStartIndex, popUpViewController: popUpViewController)
            case .customItemNamePopUp:
                popUpViewController.popUp = CustomItemNamePopUpView(presentAnimationType: animationType, popUpViewController: popUpViewController)
            case .customTargetDaysPopUp:
                popUpViewController.popUp = CustomTargetDaysPopUp(presentAnimationType: animationType, dataStartIndex: dataStartIndex, popUpViewController: popUpViewController)
            case .customThemeColorPopUp:
                popUpViewController.popUp = CustomThemeColorPopUp(presentAnimationType: animationType, size: .small, popUpViewController: popUpViewController)
            case .customUserNamePopUp:
                popUpViewController.popUp = CustomUserNamePopUp(presentAnimationType: animationType, popUpViewController: popUpViewController)
            case .notificationTimePopUp:
                
                if AppEngine.shared.isNotificationEnabled() {
                    popUpViewController.popUp = NotificationTimePopUp(presentAnimationType: animationType, size: .small, popUpViewController: popUpViewController)
                } else {
                    popUpViewController.popUp = NotificationTimePopUp(presentAnimationType: animationType, size: .large, popUpViewController: popUpViewController)
                }
                
            case .itemCompletedPopUp:
                print("You should not use this function")
                print("Use 'showItemCompletedPopUp(for: Item)' instead")
            case .lightAndDarkModePopUp:
                popUpViewController.popUp = LightAndDarkModePopUp(presentAnimationType: animationType, size: .medium, popUpViewController: popUpViewController)
            }
            
            self.present(to: popUpViewController)
        }
       
       
        
    }
    
    func showItemCompletedPopUp(for item: Item) {
        
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
}

class UpdateStyleMode: UIViewController {
    
}
