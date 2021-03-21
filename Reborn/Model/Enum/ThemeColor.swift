//
//  ThemeColor.swift
//  Reborn
//
//  Created by Christian Liu on 27/2/21.
//

import Foundation
import UIKit

enum ThemeColor: String, Codable, CaseIterable {

    case blue = "BlueThemeColor"
    case blue2 = "BlueThemeColor2"
    case pink = "PinkThemeColor"
    case pink2 = "PinkThemeColor2"
    case yellow = "YellowThemeColor"
    case cyan = "CyanThemeColor"
    case green = "GreenThemeColor"
    case red = "RedThemeColor"
    case orange = "OrangeThemeColor"
    case purple = "PurpleThemeColor"
    
    var uiColor: UIColor {
        return UIColor(named: self.rawValue) ?? UIColor.clear
    }
}

