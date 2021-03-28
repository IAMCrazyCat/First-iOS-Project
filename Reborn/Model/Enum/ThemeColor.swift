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
    
    var name: String {
        switch self {
        case .blue: return "圣托里尼蓝"
        case .blue2: return "蓝天"
        case .pink:
            switch AppEngine.shared.currentUser.gender {
            case .male: return "猛男粉"
            case .female: return "仙女粉"
            default: return "仙女/猛男粉"
            }
            
        case .pink2: return "玫瑰粉"
        case .yellow: return "柠檬黄"
        case .cyan: return "青出于蓝"
        case .green: return "原谅绿"
        case .red: return "里米尼红"
        case .orange: return "橘猫"
        case .purple: return "紫罗兰"

        }
    }
}

