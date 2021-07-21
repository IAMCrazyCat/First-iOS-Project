//
//  AppStyleSetting.swift
//  Reborn
//
//  Created by Christian Liu on 23/12/20.
//

import Foundation
import UIKit
class UserSetting {
    var themeColor = ThemeColor.default
    var largeFont = UIFont.systemFont(ofSize: 30)
    var mediumFont = UIFont.systemFont(ofSize: 17)
    var smallFont = UIFont.systemFont(ofSize: 14)
    var notificationTime: Array<CustomTime> = [CustomTime(hour: 21, minute: 0, second: 0, oneTenthSecond: 0)]
    var appAppearanceMode: AppAppearanceMode = .followSystem
    var hasViewedEnergyUpdate: Bool = false
    var uiUserInterfaceStyle: UIUserInterfaceStyle {
        if appAppearanceMode == .darkMode {
            return .dark
        } else if appAppearanceMode == .lightMode {
            return .light
        } else {
            return .unspecified
        }
    }
    var encourageText = ["坚持就是胜利，继续加油",
                         "我依然还爱着你，继续加油",
                         "生活不是随心所欲, 而是自我主宰, 继续坚持!",
                         "你又来了，感觉你今天更好了",
                         "成功源于自律",
                         "自律，就是一场旅行，沿途都是风景",
                         "坚持路上你不孤独，有我陪你，辛苦了！",
                         "如果你还爱着我，请不要放弃"]
    
    let properThemeColor = UIColor { system in
        switch system.userInterfaceStyle {
        case .dark:
            return AppEngine.shared.userSetting.themeColor.uiColor.brightColor
        default:
            return AppEngine.shared.userSetting.themeColor.uiColor.darkColor
        }
        
    }
    let themeColorDarkAndThemeColor = UIColor { system in

        switch AppEngine.shared.userSetting.appAppearanceMode {
        case .lightMode:
            return AppEngine.shared.userSetting.themeColor.uiColor.darkColor
        case .darkMode:
            return AppEngine.shared.userSetting.themeColor.uiColor
            
        case .followSystem:
            switch system.userInterfaceStyle {
            case.dark:
                return AppEngine.shared.userSetting.themeColor.uiColor
            default:
                return AppEngine.shared.userSetting.themeColor.uiColor.darkColor
            }
        }
        
        
        
    }
    let themeColorAndBlackContent = UIColor { system in
        
        switch AppEngine.shared.userSetting.appAppearanceMode {
        case .lightMode:
            return AppEngine.shared.userSetting.themeColor.uiColor
        case .darkMode:
            return AppEngine.shared.userSetting.blackContent
            
        case .followSystem:
            switch system.userInterfaceStyle {
            case .dark:
                return AppEngine.shared.userSetting.blackContent
            default:
                return AppEngine.shared.userSetting.themeColor.uiColor
            }
        }
        
    }
    let themeColorAndWhite = UIColor { system in
        switch system.userInterfaceStyle {
        case .dark:
            return UIColor.white
        default:
            return AppEngine.shared.userSetting.themeColor.uiColor
        }
    }
    let themeColorAndSmartLabelColor = UIColor { system in
        
        switch system.userInterfaceStyle {
        case .dark:
            return AppEngine.shared.userSetting.smartLabelColorAndWhite
        default:
            return AppEngine.shared.userSetting.themeColor.uiColor
            
        }
    }
    let whiteAndThemColor = UIColor { system in
        switch system.userInterfaceStyle {
        case .dark:
            return AppEngine.shared.userSetting.themeColor.uiColor
        default:
            return AppEngine.shared.userSetting.whiteAndBlackContent
        }
    }
    
    let smartLabelColorAndWhite = UIColor { system in

        switch system.userInterfaceStyle {
        case .dark:
            return .white
        default:
            let colorBrightness = ((AppEngine.shared.userSetting.themeColor.uiColor.value.red * 299) + (AppEngine.shared.userSetting.themeColor.uiColor.value.green * 587) + (AppEngine.shared.userSetting.themeColor.uiColor.value.blue * 114)) / 1000
    
            if colorBrightness <= 0.7 {
                return .white
            } else {
                return UIColor.black.withAlphaComponent(0.7)
            }
            
        }
        
    }
    
    let smartLabelColor = UIColor { _ in
        let colorBrightness = ((AppEngine.shared.userSetting.themeColor.uiColor.value.red * 299) + (AppEngine.shared.userSetting.themeColor.uiColor.value.green * 587) + (AppEngine.shared.userSetting.themeColor.uiColor.value.blue * 114)) / 1000

        if colorBrightness <= 0.7 {
            return .white
        } else {
            return UIColor.black.withAlphaComponent(0.7)
        }
    }
    
    let smartVisibleThemeColor = UIColor { _ in
        let colorBrightness = ((AppEngine.shared.userSetting.themeColor.uiColor.value.red * 299) + (AppEngine.shared.userSetting.themeColor.uiColor.value.green * 587) + (AppEngine.shared.userSetting.themeColor.uiColor.value.blue * 114)) / 1000

        if colorBrightness <= 0.7 {
            return AppEngine.shared.userSetting.themeColor.uiColor
        } else {
            return AppEngine.shared.userSetting.themeColor.uiColor.darkColor
        }
    }
    
    let smartThemeLabelColor = UIColor { system in
        

        switch system.userInterfaceStyle {
        case .dark:
            let colorBrightness = ((AppEngine.shared.userSetting.themeColor.uiColor.value.red * 299) + (AppEngine.shared.userSetting.themeColor.uiColor.value.green * 587) + (AppEngine.shared.userSetting.themeColor.uiColor.value.blue * 114)) / 1000

            if colorBrightness <= 0.7 {
                return UIColor.white
            } else {
                return UIColor.black.withAlphaComponent(0.7)
            }
        default:
            let colorBrightness = ((AppEngine.shared.userSetting.themeColor.uiColor.value.red * 299) + (AppEngine.shared.userSetting.themeColor.uiColor.value.green * 587) + (AppEngine.shared.userSetting.themeColor.uiColor.value.blue * 114)) / 1000

            if colorBrightness <= 0.7 {
                return AppEngine.shared.userSetting.themeColor.uiColor
            } else {
                return UIColor.black.withAlphaComponent(0.7)
            }
        }
    }
    
    
    
    let smartLabelColorAndWhiteAndThemeColor = UIColor { system in
        
        switch AppEngine.shared.userSetting.appAppearanceMode {
        case .lightMode:
            return AppEngine.shared.userSetting.smartLabelColorAndWhite
        case .darkMode:
            return AppEngine.shared.userSetting.themeColor.uiColor
        case .followSystem:
            
            switch system.userInterfaceStyle {
            case .dark:
                return AppEngine.shared.userSetting.themeColor.uiColor
            default:
                return AppEngine.shared.userSetting.smartLabelColorAndWhite
            }
        }
       
    }
    
    let smartLabelColorAndThemeColor = UIColor { system in
        
        switch AppEngine.shared.userSetting.appAppearanceMode {
        case .lightMode:
            return AppEngine.shared.userSetting.smartLabelColor
        case .darkMode:
            return AppEngine.shared.userSetting.themeColor.uiColor
        case .followSystem:
            
            switch system.userInterfaceStyle {
            case .dark:
                return AppEngine.shared.userSetting.themeColor.uiColor
            default:
                return AppEngine.shared.userSetting.smartLabelColor
            }
        }
       
    }
    
    let brightAndDarkThemeColor = UIColor { system in
        
        switch AppEngine.shared.userSetting.appAppearanceMode {
        case .lightMode:
            return AppEngine.shared.userSetting.themeColor.uiColor.brightColor
        case .darkMode:
            return AppEngine.shared.userSetting.themeColor.uiColor.darkColor.withAlphaComponent(0.4)
        case .followSystem:
            
            switch system.userInterfaceStyle {
            case .dark:
                return AppEngine.shared.userSetting.themeColor.uiColor.darkColor.withAlphaComponent(0.4)
            default:
                return AppEngine.shared.userSetting.themeColor.uiColor.brightColor
            }
        }
       
    }

    
    
    let whiteAndBlackContent: UIColor = UIColor { system in
        
        switch AppEngine.shared.userSetting.appAppearanceMode {
        case .lightMode:
            return .white
        case .darkMode:
            return AppEngine.shared.userSetting.blackContent
        case .followSystem:
            return UIColor(named: "WhiteAndBlackContent") ?? UIColor.blue
        }
       
    }
   
    let whiteAndBlackBackground: UIColor = UIColor { system in
       
        switch AppEngine.shared.userSetting.appAppearanceMode {
       
        case .lightMode:
            return UIColor.white
        case .darkMode:
            return AppEngine.shared.userSetting.blackBackground
        case .followSystem:
            return UIColor(named: "WhiteAndBlackBackground") ?? UIColor.blue
        }
       
    }
    
   
    let grayAndBlack: UIColor = UIColor(named: "GrayAndBlack") ?? UIColor.blue
    let grayWhiteAndBlackBackground: UIColor = UIColor(named: "grayWhiteAndBlackBackground") ?? UIColor.blue
    let greenColor =  UIColor(named: "GreenColor") ?? UIColor.blue
    let redColor =  UIColor(named: "RedColor") ?? UIColor.blue
    let blackContent = UIColor(named: "BlackContent") ?? UIColor.black.withAlphaComponent(0.8)
    let blackBackground = UIColor(named: "BlackBackground") ?? UIColor.black

}
