//
//  UIUpdatingManager.swift
//  Reborn
//
//  Created by Christian Liu on 19/7/21.
//

import Foundation
import UIKit
class UIManager {
    public static let shared = UIManager()
    private init() {}
    
    public func updateUIAfterUserIsLoadedInBackgroundThread() {
        AppEngine.shared.notifyUIObservers(withIdentifier: "HomeViewController")
    }
    
    public func updateUIAfterPunchInButtonPressed(_ item: Item) {
        if let homeViewController = AppEngine.shared.getUIObserver(withIdentifier: "HomeViewController") as? HomeViewController {
            homeViewController.updateItemCardView(by: item)
            homeViewController.updateNavigationView()
        }
        
        if let itemManagementViewController = AppEngine.shared.getUIObserver(withIdentifier: "ItemManagementViewController") as? ItemManagementViewController {
            itemManagementViewController.updateItemCardView(by: item)
        }
    }
    
    public func updateUIAfterNewItemAdded() {
        if let view = UIApplication.shared.getCurrentViewController()?.view {

            LoadingAnimationManager.shared.add(to: view, circleWidth: 2, circleRadius: 30, proportionallyOnYPosition: 0.4, backgroundAlpha: 0, identifier: "UpdateItemsAnimation")
        }
        AppEngine.shared.notifyAllUIObservers() {
            LoadingAnimationManager.shared.removeAnimationWith(identifier: "UpdateItemsAnimation")
        }
    }
    
    public func updateUIAfterItemWasDeleted() {
        AppEngine.shared.notifyAllUIObservers()
    }
    
    
    
    public func updateUIAfterItemWasEdited(_ item: Item) {
        if let view = UIApplication.shared.getCurrentViewController()?.view {
            LoadingAnimationManager.shared.add(to: view, identifier: "nil")
        }
        AppEngine.shared.notifyAllUIObservers() {
            LoadingAnimationManager.shared.removeAnimationWith(identifier: "nil")
        }
        
    }
    
    public func updateUIAfterTimeMachineWasUsed(_ item: Item) {
        if let view = UIApplication.shared.getCurrentViewController()?.view {
            LoadingAnimationManager.shared.add(to: view, identifier: "nil")
        }
        AppEngine.shared.notifyAllUIObservers() {
            LoadingAnimationManager.shared.removeAnimationWith(identifier: "nil")
        }
    }
    
    public func updateUIWhenTimeMachineCalendarCellIsPressed() {
        AppEngine.shared.notifyUIObservers(withIdentifier: "TimeMachineViewController")
    }
    
    public func updateUIAfterEncourageTextWasEdited() {
        if let homeViewController = AppEngine.shared.getUIObserver(withIdentifier: "HomeViewController") as? HomeViewController {
            homeViewController.updateNavigationView()
        }
    }
    
    public func updateUIAfterUserInfomationWasEdited() {
        AppEngine.shared.notifyUIObservers(withIdentifier: "UserCenterViewController")
    }
    
    public func updateUIAfterUserAvatarWasChanged() {
        AppEngine.shared.notifyAllUIObservers()
    }
    
    public func updateUIAfterThemeColorWasSelected() {
        AppEngine.shared.notifyUIObservers(withIdentifier: "PopUpViewController")
        AppEngine.shared.notifyUIObservers(withIdentifier: "UserCenterViewController")
        
    }
    
    public func updateUIAfterThemeColorWasChanged() {
        if let view = UIApplication.shared.getCurrentViewController()?.view {
            LoadingAnimationManager.shared.add(to: view, identifier: "ThemeColorChangingAnimation")
        }
        AppEngine.shared.notifyAllUIObservers() {
            LoadingAnimationManager.shared.removeAnimationWith(identifier: "ThemeColorChangingAnimation")
        }
        
    }
    
    public func updateUIAfterAppAppearanceWasSelected() {
        UIApplication.shared.getCurrentViewController()?.view.window?.overrideUserInterfaceStyle = AppEngine.shared.userSetting.uiUserInterfaceStyle
        AppEngine.shared.notifyUIObservers(withIdentifier: "PopUpViewController")
        AppEngine.shared.notifyUIObservers(withIdentifier: "UserCenterViewController")
    }
    
    public func updateUIAfterAppAppearanceWasChanged() {
        if let view = UIApplication.shared.getCurrentViewController()?.view {
            LoadingAnimationManager.shared.add(to: view, identifier: "AppAppearanceChangingAnimation")
        }
        AppEngine.shared.notifyAllUIObservers() {
            LoadingAnimationManager.shared.removeAnimationWith(identifier: "AppAppearanceChangingAnimation")
        }
        
    }
    
    public func updateUIWhenEnergyViewWillDisapper() {
        AppEngine.shared.notifyUIObservers(withIdentifier: "UserCenterViewController")
    }
    
    public func updateUIAccordingToTimeChange() {
        if let view = UIApplication.shared.getCurrentViewController()?.view {
            LoadingAnimationManager.shared.add(to: view, identifier: "nil")
        }
        AppEngine.shared.notifyAllUIObservers() {
            LoadingAnimationManager.shared.removeAnimationWith(identifier: "nil")
        }
    }
    
    public func updateUIAfterAppWasPurchased() {
        if let view = UIApplication.shared.getCurrentViewController()?.view {
            LoadingAnimationManager.shared.add(to: view, identifier: "nil")
        }
        AppEngine.shared.notifyAllUIObservers() {
            LoadingAnimationManager.shared.removeAnimationWith(identifier: "nil")
        }
    }
    
    public func updateUIAfterEnergyWasPurchased() {
        AppEngine.shared.notifyUIObservers(withIdentifier: "EnergySettingViewController")
        AppEngine.shared.notifyUIObservers(withIdentifier: "UserCenterViewController")
    }
    
    public func updateUIAfterSubscriptionCheckFailed() {
        if let view = UIApplication.shared.getCurrentViewController()?.view {
            LoadingAnimationManager.shared.add(to: view, identifier: "nil")
        }
        AppEngine.shared.notifyAllUIObservers() {
            LoadingAnimationManager.shared.removeAnimationWith(identifier: "nil")
        }
    }
    
    public func updateUIAfterSubscriptionCheckSuccessed() {
        if let view = UIApplication.shared.getCurrentViewController()?.view {
            LoadingAnimationManager.shared.add(to: view, identifier: "nil")
        }
        AppEngine.shared.notifyAllUIObservers() {
            LoadingAnimationManager.shared.removeAnimationWith(identifier: "nil")
        }
    }
    
    public func updateUIAfterNotificationStatusChanged() {
        AppEngine.shared.notifyUIObservers(withIdentifier: "PopUpViewController")
        AppEngine.shared.notifyUIObservers(withIdentifier: "UserCenterViewController")
    }
    
    public func updateUIAfterTomatoTimerIsRecovered() {
        AppEngine.shared.notifyUIObservers(withIdentifier: "PotatoClockViewController")
    }
    
    public func updateUIAfterNonVipUserSelectedVipSettings() {
        if let view = UIApplication.shared.getCurrentViewController()?.view {
            LoadingAnimationManager.shared.add(to: view, identifier: "nil")
        }
        AppEngine.shared.notifyAllUIObservers() {
            LoadingAnimationManager.shared.removeAnimationWith(identifier: "nil")
        }
    }
}
