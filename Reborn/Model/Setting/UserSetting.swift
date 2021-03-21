//
//  AppStyleSetting.swift
//  Reborn
//
//  Created by Christian Liu on 23/12/20.
//

import Foundation
import UIKit
class UserSetting {
    var themeColor = UIColor(named: ThemeColor.blue.rawValue)!
    var largeFont = UIFont.systemFont(ofSize: 30)
    var mediumFont = UIFont.systemFont(ofSize: 17)
    var smallFont = UIFont.systemFont(ofSize: 14)
    var notificationTime: Array<CustomTime> = [CustomTime(hour: 9, minute: 0), CustomTime(hour: 21, minute: 0)]
    var appAppearanceMode: AppAppearanceMode = .followSystem
    
    var uiUserInterfaceStyle : UIUserInterfaceStyle {
        if appAppearanceMode == .darkMode {
            return .dark
        } else if appAppearanceMode == .lightMode {
            return .light
        } else {
            return .unspecified
        }
    }
    
    let properThemeColor = UIColor { system in
        switch system.userInterfaceStyle {
        case .dark:
            return AppEngine.shared.userSetting.themeColor.brightColor
        default:
            return AppEngine.shared.userSetting.themeColor.darkColor
        }
        
    }
    let themeColorDarkAndThemeColor = UIColor { system in

        switch system.userInterfaceStyle {
        case.dark:
            return AppEngine.shared.userSetting.themeColor
        default:
            return AppEngine.shared.userSetting.themeColor.darkColor
        }
        
    }
    let themeColorAndBlackContent = UIColor { system in
        
        switch AppEngine.shared.userSetting.appAppearanceMode {
        case .lightMode:
            return AppEngine.shared.userSetting.themeColor
        case .darkMode:
            return AppEngine.shared.userSetting.blackContent
            
        case .followSystem:
            switch system.userInterfaceStyle {
            case .dark:
                return AppEngine.shared.userSetting.blackContent
            default:
                return AppEngine.shared.userSetting.themeColor
            }
        }
        
    }
    let themeColorAndWhite = UIColor { system in
        switch system.userInterfaceStyle {
        case .dark:
            return UIColor.white
        default:
            return AppEngine.shared.userSetting.themeColor
        }
    }
    let themeColorAndSmartLabelColor = UIColor { system in
        
        switch system.userInterfaceStyle {
        case .dark:
            return AppEngine.shared.userSetting.smartLabelColorAndWhite
        default:
            return AppEngine.shared.userSetting.themeColor
            
        }
    }
    let whiteAndThemColor = UIColor { system in
        switch system.userInterfaceStyle {
        case .dark:
            return AppEngine.shared.userSetting.themeColor
        default:
            return AppEngine.shared.userSetting.whiteAndBlackContent
        }
    }
    
    let smartLabelColorAndWhite = UIColor { system in

        switch system.userInterfaceStyle {
        case .dark:
            return .white
        default:
            let colorBrightness = ((AppEngine.shared.userSetting.themeColor.value.red * 299) + (AppEngine.shared.userSetting.themeColor.value.green * 587) + (AppEngine.shared.userSetting.themeColor.value.blue * 114)) / 1000
    
            if colorBrightness <= 0.7 {
                return .white
            } else {
                return UIColor.black.withAlphaComponent(0.7)
            }
            
        }
        
    }
    
    let smartLabelColor = UIColor { _ in
        let colorBrightness = ((AppEngine.shared.userSetting.themeColor.value.red * 299) + (AppEngine.shared.userSetting.themeColor.value.green * 587) + (AppEngine.shared.userSetting.themeColor.value.blue * 114)) / 1000

        if colorBrightness <= 0.7 {
            return .white
        } else {
            return UIColor.black.withAlphaComponent(0.7)
        }
    }
    
    let smartThemeColor = UIColor { _ in
        let colorBrightness = ((AppEngine.shared.userSetting.themeColor.value.red * 299) + (AppEngine.shared.userSetting.themeColor.value.green * 587) + (AppEngine.shared.userSetting.themeColor.value.blue * 114)) / 1000

        if colorBrightness <= 0.7 {
            return AppEngine.shared.userSetting.themeColor
        } else {
            return AppEngine.shared.userSetting.themeColor.darkColor
        }
    }
    
    let smartThemeLabelColor = UIColor { system in
        

        switch system.userInterfaceStyle {
        case .dark:
            let colorBrightness = ((AppEngine.shared.userSetting.themeColor.value.red * 299) + (AppEngine.shared.userSetting.themeColor.value.green * 587) + (AppEngine.shared.userSetting.themeColor.value.blue * 114)) / 1000

            if colorBrightness <= 0.7 {
                return UIColor.white
            } else {
                return UIColor.black.withAlphaComponent(0.7)
            }
        default:
            let colorBrightness = ((AppEngine.shared.userSetting.themeColor.value.red * 299) + (AppEngine.shared.userSetting.themeColor.value.green * 587) + (AppEngine.shared.userSetting.themeColor.value.blue * 114)) / 1000

            if colorBrightness <= 0.7 {
                return AppEngine.shared.userSetting.themeColor
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
            return AppEngine.shared.userSetting.themeColor
        case .followSystem:
            
            switch system.userInterfaceStyle {
            case .dark:
                return AppEngine.shared.userSetting.themeColor
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
            return AppEngine.shared.userSetting.themeColor
        case .followSystem:
            
            switch system.userInterfaceStyle {
            case .dark:
                return AppEngine.shared.userSetting.themeColor
            default:
                return AppEngine.shared.userSetting.smartLabelColor
            }
        }
       
    }
    

    
    
    
    let whiteAndBlackContent: UIColor = UIColor(named: "WhiteAndBlackContent") ?? UIColor.blue
    let whiteAndBlackBackground: UIColor = UIColor(named: "WhiteAndBlackBackground") ?? UIColor.blue
    let grayAndBlack: UIColor = UIColor(named: "GrayAndBlack") ?? UIColor.blue
    let grayWhiteAndBlackBackground: UIColor = UIColor(named: "grayWhiteAndBlackBackground") ?? UIColor.blue
    let greenColor =  UIColor(named: "GreenColor") ?? UIColor.blue
    let redColor =  UIColor(named: "RedColor") ?? UIColor.blue
    let blackContent = UIColor(named: "BlackContent") ?? UIColor.blue
    let blackBackground = UIColor(named: "BlackBackGround") ?? UIColor.blue

}
