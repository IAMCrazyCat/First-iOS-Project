//
//  EveryMonthFrequencyPopUp.swift
//  Reborn
//
//  Created by Christian Liu on 10/6/21.
//

import Foundation
import UIKit
class EveryMonthFrequencyPopUp: EveryWeekFrequencyPopUp {
    
    var leftLabel: UILabel? {
        return super.accordingToDaysView?.getSubviewBy(idenifier: "LeftLabel") as? UILabel
    }
    
    override init(presentAnimationType: PopUpAnimationType, size: PopUpSize = .small, popUpViewController: PopUpViewController) {
        super.init(presentAnimationType: presentAnimationType, popUpViewController: popUpViewController)
        super.type = .everyMonthFreqencyPopUp
        self.setUpUI()
    }
    
    override func getStoredData() -> Any? {
        return self.selectedDays
    }

    override func setPickerViewData() {
        pickerView?.delegate = popUpViewController
        pickerView?.dataSource = popUpViewController
        self.pickerViewData = PickerViewData.monthDays
    }
    
    override func didSelectRow() {
        updateUI()
    }
    
    
    private func updateLabels() {
        if let pickerView = self.pickerView {
            self.selectedDays = pickerView.selectedRow(inComponent: 0) + 1
            self.instructionLabel?.text = "一月内完成\(pickerView.selectedRow(inComponent: 0) + 1)次打卡后项目将不会出现在今日打卡中"

        }
    }
    
    private func setUpUI() {
        super.accordingToWeekDaysView?.isHidden = true
        super.accordingToDaysView?.isHidden = false
        super.segmentedControl?.isHidden = true
        super.titleLabel?.text = "设置每月打卡天数"
        self.leftLabel?.text = "每月"
    }
    
    override func updateUI() {
        self.updateLabels()
    }
    
}


