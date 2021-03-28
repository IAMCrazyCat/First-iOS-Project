//
//  AppAppearanceMode.swift
//  Reborn
//
//  Created by Christian Liu on 20/3/21.
//

import Foundation
enum AppAppearanceMode: String, Codable, CaseIterable{
    
    var name: String {
        switch self {
        case .followSystem: return "跟随系统"
        case .lightMode: return "白天模式"
        case .darkMode: return "黑夜模式"
        }
    }
    
    case followSystem = "FollowSystem"
    case lightMode = "LightMode"
    case darkMode = "DarkMode"
}
