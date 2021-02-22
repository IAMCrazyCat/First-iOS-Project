//
//  AppStyleSetting.swift
//  Reborn
//
//  Created by Christian Liu on 23/12/20.
//

import Foundation
import UIKit
class UserSetting {
    var themeColor = UIColor(named: "ThemeColor") ?? UIColor.clear
    var themeColorPair = UIColor(named: "ThemeColorPair") ?? UIColor.clear
    var themeColorAndBlack = UIColor { system in
        switch system.userInterfaceStyle {
        case .dark:
            return AppEngine.shared.userSetting.whiteAndBlackContent
        default:
            return AppEngine.shared.userSetting.themeColor
        }
    }
    var whiteAndThemColor = UIColor { system in
        switch system.userInterfaceStyle {
        case .dark:
            return AppEngine.shared.userSetting.themeColor
        default:
            return AppEngine.shared.userSetting.whiteAndBlackContent
        }
    }
    var whiteAndBlackContent: UIColor = UIColor(named: "WhiteAndBlackContent") ?? UIColor.clear
    var whiteAndBlackBackground: UIColor = UIColor(named: "WhiteAndBlackBackground") ?? UIColor.clear
    var grayAndBlack: UIColor = UIColor(named: "GrayAndBlack") ?? UIColor.clear
    var grayWhiteAndBlackBackground: UIColor = UIColor(named: "grayWhiteAndBlackBackground") ?? UIColor.clear
    var greenColor =  UIColor(named: "GreenColor") ?? UIColor.clear
    var redColor =  UIColor(named: "RedColor") ?? UIColor.clear
    var fontLarge = UIFont.systemFont(ofSize: 30)
    var fontMedium = UIFont.systemFont(ofSize: 17)
    var fontSmall = UIFont.systemFont(ofSize: 14)
    var notificationHour: Int = 22
    var notificationMinute: Int = 10

}
