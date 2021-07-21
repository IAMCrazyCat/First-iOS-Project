//
//  ThemeColorStrategy.swift
//  Reborn
//
//  Created by Christian Liu on 29/3/21.
//

import Foundation
import UIKit
class SettingStrategy: VIPStrategyImpl {
    
    func saveUserSetting() {

        if !AppEngine.shared.currentUser.isVip && AppEngine.shared.userSetting.themeColor.isVipColor {
            AppEngine.shared.userSetting.themeColor = ThemeColor.default
            UIManager.shared.updateUIAfterNonVipUserSelectedVipSettings()
        }
        
        AppEngine.shared.saveUser()
        AppEngine.shared.saveSetting()
    }

  
    
    
}
