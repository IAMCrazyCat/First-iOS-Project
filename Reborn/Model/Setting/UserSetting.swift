//
//  AppStyleSetting.swift
//  Reborn
//
//  Created by Christian Liu on 23/12/20.
//

import Foundation
import UIKit
class UserSetting {
    var themeColor = UIColor(named: ThemeColor.blue.rawValue) ?? UIColor.clear
    var fontLarge = UIFont.systemFont(ofSize: 30)
    var fontMedium = UIFont.systemFont(ofSize: 17)
    var fontSmall = UIFont.systemFont(ofSize: 14)
    var notificationHour: Int = 22
    var notificationMinute: Int = 10
    
    
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
    let whiteAndBlackContent: UIColor = UIColor(named: "WhiteAndBlackContent") ?? UIColor.clear
    let whiteAndBlackBackground: UIColor = UIColor(named: "WhiteAndBlackBackground") ?? UIColor.clear
    let grayAndBlack: UIColor = UIColor(named: "GrayAndBlack") ?? UIColor.clear
    let grayWhiteAndBlackBackground: UIColor = UIColor(named: "grayWhiteAndBlackBackground") ?? UIColor.clear
    let greenColor =  UIColor(named: "GreenColor") ?? UIColor.clear
    let redColor =  UIColor(named: "RedColor") ?? UIColor.clear


}
