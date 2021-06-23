//
//  NewFeaturesManager.swift
//  Reborn
//
//  Created by Christian Liu on 13/6/21.
//

import Foundation
import UIKit
class NewFeaturesManager {
    
    public static let shared = NewFeaturesManager()
    private let defaults = UserDefaults.standard
    let newFeature: Array<CustomData> = [
        CustomData(title: "修复了习惯能量不累积的问题", body: "您之前打卡累积的能量进度已经返还，继续加油"),
        CustomData(title: "修复了通知内容不准确的问题", body: "暂时使用标准化通知内容，正在更新智能通知"),
    ]
    
    private init() {
        
    }
    
    public func presentNewFeaturePopUp() {
        let currentViewController = UIApplication.shared.getCurrentViewController()
        currentViewController?.present(size: .large, animation: .fadeInFromCenter, newFeatures: self.newFeature)
        saveViewedStatus(userHasViewed: true)
    }
    
    public func presentNewFeaturePopUpIfNeeded() {
        
        if isUpdatedFromPreviousVersion() {
            print("Is updated from previous version")
        } else {
            print("Is not updated from previous version")
        }
        
        if userHasViewedNewFeatures() {
            print("User has viewed new version")
        } else {
            print("User has not viewed new version")
        }
        
        if isUpdatedFromPreviousVersion() && !userHasViewedNewFeatures() {
            presentNewFeaturePopUp()
           
        } else {
            
        }
        
      
        
    }
    
    private func isUpdatedFromPreviousVersion() -> Bool {
        let previousSavedVersion = loadPreviousVersion()
        
        if previousSavedVersion == nil {
            return true
        } else {
            if previousSavedVersion != App.version {
                return true
            }
        }
        
        return false
    }
    
    public func saveCurrentVersion() {
        defaults.set(App.version, forKey: "AppVersion")
    }
    
    public func loadPreviousVersion() -> String? {
        let version = defaults.string(forKey: "AppVersion")
        return version
    }
    
    private func userHasViewedNewFeatures() -> Bool {
        if let savedVersion = loadViewedStatus()?.title, let viewed = loadViewedStatus()?.status {
            if savedVersion == App.version && viewed {
                print(savedVersion)
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    private func saveViewedStatus(userHasViewed: Bool) {
        defaults.set(CustomData(title: App.version, status: userHasViewed), forKey: "UserHasViewed")
    }
    
    private func loadViewedStatus() -> CustomData? {
        let status = defaults.customData(forKey: "UserHasViewed")
        return status
    }
}
