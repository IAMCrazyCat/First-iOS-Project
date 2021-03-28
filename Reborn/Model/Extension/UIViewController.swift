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
                
                if AppEngine.shared.isNotificationEnabled() {
                    popUpViewController.popUp = NotificationTimePopUp(presentAnimationType: animationType, size: size, popUpViewController: popUpViewController)
                } else {
                    popUpViewController.popUp = NotificationTimePopUp(presentAnimationType: animationType, size: size, popUpViewController: popUpViewController)
                }
                
            case .itemCompletedPopUp:
                print("You should not use this function")
                print("Use 'showItemCompletedPopUp(for: Item)' instead")
            case .lightAndDarkModePopUp:
                popUpViewController.popUp = LightAndDarkModePopUp(presentAnimationType: animationType, size: size, popUpViewController: popUpViewController)
            }
            
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
    
    func addBottomBannerAdIfNeeded() {
        if !AppEngine.shared.currentUser.isVip {
            
            var bannerView: GADBannerView!
            bannerView = GADBannerView(adSize: kGADAdSizeBanner)
            bannerView.accessibilityIdentifier = "BottomBannerAd"
            bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(bannerView)
            
            bannerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            bannerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            bannerView.widthAnchor.constraint(equalToConstant: 320).isActive = true
            bannerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        
        
    }
    
    func removeBottomBannerAdIfVIP() {
        if AppEngine.shared.currentUser.isVip {
            self.view.removeSubviewBy(idenifier: "BottomBannerAd")
        }
        
    }
    
   
}

class UpdateStyleMode: UIViewController {
    
}
