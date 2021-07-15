//
//  EnergyStrategy.swift
//  Reborn
//
//  Created by Christian Liu on 29/3/21.
//

import Foundation

class EnergyStrategy: VIPStrategyImpl {
    
    let energySettingViewController: EnergySettingViewController
    init(energySettingViewController: EnergySettingViewController) {
        self.energySettingViewController = energySettingViewController
    }
    
    func updateLabels() {
        energySettingViewController.energyButton.setTitle("× \(AppEngine.shared.currentUser.energy)", for: .normal)

        if AppEngine.shared.currentUser.isVip {
            energySettingViewController.efficiencyLabel.text = "能效：连续打卡\(AppEngine.shared.currentUser.energyChargingEfficiencyDays)天 获得1点能量 (高级用户)"
        } else {
            energySettingViewController.efficiencyLabel.text = "能效：连续打卡\(AppEngine.shared.currentUser.energyChargingEfficiencyDays)天 获得1点能量 (普通用户)"
            
        }
    }
    
    func getAnimationSpeed() -> TimeInterval {
        return AppEngine.shared.currentUser.isVip ? 1.5 : 4.5
    }
    
}
