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
    case pink = "PinkThemeColor"
    case yellow = "YellowThemeColor"
    case cyan = "CyanThemeColor"
    case green = "GreenThemeColor"
    case red = "RedThemeColor"
    case orange = "OrangeThemeColor"
    
    var uiColor: UIColor {
        return UIColor(named: self.rawValue) ?? UIColor.clear
    }
}

