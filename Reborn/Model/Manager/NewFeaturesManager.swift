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
        CustomData(title: "新的习惯频率模式！", body: "重要: 请重新设置您的习惯频率！我们添加了新的习惯重复模式，您可以设置固定打卡日或者打卡天数，请在在习惯详情中点击编辑来更新您的频率"),
        CustomData(title: "新图标", body: "新增了10款习惯图标"),
        CustomData(title: "新主题颜色", body: "删除了原谅绿主题颜色，重新调整了新的主题色"),
        CustomData(title: "新的打卡通知", body: "新的打卡通知内容更加智能，让您更好坚持自己的目标")
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
