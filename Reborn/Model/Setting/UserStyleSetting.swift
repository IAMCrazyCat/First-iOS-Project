//
//  AppStyleSetting.swift
//  Reborn
//
//  Created by Christian Liu on 23/12/20.
//

import Foundation
import UIKit
class UserStyleSetting {
    static var themeColor = UIColor(named: "ThemeColor") ?? UIColor.clear
    static var themeColorPair = UIColor(named: "ThemeColorPair") ?? UIColor.clear
    static var greenColor =  UIColor(named: "GreenColor") ?? UIColor.clear
    static var fontLarge = UIFont.systemFont(ofSize: 30)
    static var fontMedium = UIFont.systemFont(ofSize: 17)
    static var fontSmall = UIFont.systemFont(ofSize: 14)
}
