//
//  NewFeaturesManager.swift
//  Reborn
//
//  Created by Christian Liu on 13/6/21.
//

import Foundation
import UIKit
class NewFeaturesManager {
    
    let testing: Bool = false
    public static let shared = NewFeaturesManager()
    private let defaults = UserDefaults.standard
    let newFeatureForNonVipUsers: Array<CustomData> = [
        CustomData(title: "新增 激励语！添加您自己的激励语，动力加倍", body: "高级用户现在可以在自律工具中自定义激励语，激励语将会在主页显示，用您自己的方式提醒自己时刻自律，完成自己的目标，当前版本您最多可以设置8个激励语"),
        CustomData(title: "优化了阴影效果", body: "新的阴影效果更加真实，给您带来更好的用户体验"),
        CustomData(title: "修复了固定通知设置界面闪退问题", body: "我们向之前受到此问题影响的用户表示抱歉"),
        CustomData(title: "重新布局了一些元素", body: "删除了番茄时钟，呼吸，能量界面的大标题")
    ]
    
    let newFeatureForVipUsers: Array<CustomData> = [
        CustomData(title: "新增 激励语！添加您自己的激励语！动力加倍", body: "高级用户现在可以在自律工具中自定义激励语，激励语将会在主页显示，用您自己的方式提醒自己时刻自律，完成自己的目标，当前版本您最多可以设置8个激励语"),
        CustomData(title: "优化了阴影效果", body: "新的阴影效果更加真实，给您带来更好的用户体验"),
        CustomData(title: "修复了固定通知设置界面闪退问题", body: "我们向之前受到此问题影响的用户表示抱歉"),
        CustomData(title: "重新布局了一些元素", body: "删除了番茄时钟，呼吸，能量界面的大标题")
    ]
    
    var newFeature: Array<CustomData> {
        if AppEngine.shared.currentUser.isVip {
            return newFeatureForVipUsers
        } else {
            return newFeatureForNonVipUsers
        }
    }
    
    
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
        
        if testing {
            presentNewFeaturePopUp()
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
