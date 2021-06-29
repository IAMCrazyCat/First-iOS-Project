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
        CustomData(title: "永久会员限时8折购买🎉🎉", body: "活动截止时间: 2021年7月15日"),
        CustomData(title: "新增项目提醒！⏰", body: "您现在可以为您的习惯添加提醒时间"),
        CustomData(title: "新增了'薰衣草'主题色", body: "您可以在设置中试用"),
        CustomData(title: "新增了8款会员图标", body: "习惯图标持续更新中"),
        CustomData(title: "修改了固定通知提醒的方法", body: "您现在每天最多只会收到一次固定提醒推送，您可以在 个人中心-通知设置 中重新设置"),
        CustomData(title: "修复了iOS15 / iOS13的兼容性问题", body: "用于iOS15属于开发者测试版，如果您在使用过程中遇到了问题，请在 个人中心-反馈 / 客户服务 中反馈您遇到的问题"),
        CustomData(title: "修复了一些布局问题", body: "修改了自律管理中顶部Indicator大小，修改了项目详情中数据的间隔"),
        CustomData(title: "项目处于持续开发阶段", body: "欢迎您提供想法，请在 个人中心-反馈 / 客户服务 中反馈建议，您的建议有机会被采纳并在新版本中发布")
    ]
    
    let newFeatureForVipUsers: Array<CustomData> = [
        CustomData(title: "新增项目提醒！⏰", body: "您现在可以为您的习惯添加提醒时间"),
        CustomData(title: "新增了'薰衣草'主题色", body: "您可以在设置中使用"),
        CustomData(title: "新增了8款会员图标", body: "习惯图标持续更新中"),
        CustomData(title: "修改了固定通知提醒的方法", body: "您现在每天最多只会收到一次固定提醒推送，您可以在 个人中心-通知设置 中重新设置"),
        CustomData(title: "修复了iOS15 / iOS13的兼容性问题", body: "用于iOS15属于开发者测试版，如果您在使用过程中遇到了问题，请在 个人中心-反馈 / 客户服务 中反馈您遇到的问题"),
        CustomData(title: "修复了一些布局问题", body: "修改了自律管理中顶部Indicator大小，修改了项目详情中数据的间隔"),
        CustomData(title: "项目处于持续开发阶段", body: "欢迎您提供想法，请在 个人中心-反馈 / 客户服务 中反馈建议，您的建议有机会被采纳并在新版本中发布")
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
