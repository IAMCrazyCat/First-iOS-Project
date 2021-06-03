//
//  ThemeColor.swift
//  Reborn
//
//  Created by Christian Liu on 27/2/21.
//

import Foundation
import UIKit

enum ThemeColor: String, Codable, CaseIterable {
    
    static let `default` = ThemeColor.blue
    case blue = "BlueThemeColor"
    case blue2 = "BlueThemeColor2"
    case pink = "PinkThemeColor"
    case pink2 = "PinkThemeColor2"
    case yellow = "YellowThemeColor"
    case cyan = "CyanThemeColor"
    case cyan2 = "CyanThemeColor2"
    case green = "GreenThemeColor"
    case green2 = "GreenThemeColor2"
    case green3 = "GreenThemeColor3"
    case red = "RedThemeColor"
    case orange = "OrangeThemeColor"
    case purple = "PurpleThemeColor"
    
    var uiColor: UIColor {
        return UIColor(named: self.rawValue) ?? UIColor.clear
    }
    
    var name: String {
        
        switch self {
        case .blue: return "圣托里尼"
        case .blue2: return "贝加尔湖"
        case .pink:
            
            switch AppEngine.shared.currentUser.gender {
            case .male: return "猛男粉"
            case .female: return "仙女粉"
            default: return "仙女/猛男粉"
            }
            
        case .pink2: return "阿德莱德粉湖"
        case .yellow: return "柠檬"
        case .cyan: return "青出于蓝"
        case .cyan2: return "蒂芙尼"
        case .green: return "猕猴桃"
        case .green2: return "挪威森林"
        case .green3: return "原谅色"
        case .red: return "西瓜"
        case .orange: return "橘猫"
        case .purple: return "紫罗兰"

        }
    }
    
    var isVipColor: Bool {
        switch self {
        case .blue: return false
        case .blue2: return true
        case .pink: return false
        case .pink2: return true
        case .yellow: return true
        case .cyan: return true
        case .cyan2: return true
        case .green: return true
        case .green2: return true
        case .green3: return false
        case .red: return true
        case .orange: return false
        case .purple: return true

        }
    }
}

