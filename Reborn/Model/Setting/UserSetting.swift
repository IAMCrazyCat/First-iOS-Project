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
    
    let properThemeColor = UIColor { system in
        switch system.userInterfaceStyle {
        case .dark:
            return AppEngine.shared.userSetting.themeColor.brightColor
        default:
            return AppEngine.shared.userSetting.themeColor.darkColor
        }
        
    }
    let themeColorDarkAndThemeCarlor = UIColor { system in
        switch system.userInterfaceStyle {
        case.dark:
            return AppEngine.shared.userSetting.themeColor
        default:
            return AppEngine.shared.userSetting.themeColor.darkColor
        }
        
    }
    let themeColorAndBlack = UIColor { system in
        switch system.userInterfaceStyle {
        case .dark:
            return AppEngine.shared.userSetting.whiteAndBlackContent
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
    
    let smartLabelColor = UIColor { system in
        
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
    
    let smartLabelColorAndThemeColor = UIColor { system in
        switch system.userInterfaceStyle {
        case .dark:
            return AppEngine.shared.userSetting.themeColor
        default:
            return AppEngine.shared.userSetting.smartLabelColor
        }
    }
    
    let whiteAndBlackContent: UIColor = UIColor(named: "WhiteAndBlackContent") ?? UIColor.clear
    let whiteAndBlackBackground: UIColor = UIColor(named: "WhiteAndBlackBackground") ?? UIColor.clear
    let grayAndBlack: UIColor = UIColor(named: "GrayAndBlack") ?? UIColor.clear
    let grayWhiteAndBlackBackground: UIColor = UIColor(named: "grayWhiteAndBlackBackground") ?? UIColor.clear
    let greenColor =  UIColor(named: "GreenColor") ?? UIColor.clear
    let redColor =  UIColor(named: "RedColor") ?? UIColor.clear


}
