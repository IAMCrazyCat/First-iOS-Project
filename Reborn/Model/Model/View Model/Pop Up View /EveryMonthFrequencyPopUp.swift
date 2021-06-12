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
    
    override init(presentAnimationType: PopUpAnimationType, size: PopUpSize = .small, popUpViewController: PopUpViewController, newFrequency: NewFrequency?) {
        super.init(presentAnimationType: presentAnimationType, popUpViewController: popUpViewController, newFrequency: newFrequency)
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
    
    override func presetDays() {
        guard let everyMonthFrequency = super.newFrequency as? EveryMonth,
              let pickerView = super.pickerView
        else {
            return
        }
       
        if pickerView.numberOfComponents >= 1 && pickerView.numberOfRows(inComponent: 0) >= everyMonthFrequency.days{
            pickerView.selectRow(everyMonthFrequency.days - 1, inComponent: 0, animated: true)
        }
        self.updateUI()
    }

    
    override func updateLabels() {
        self.instructionLabel?.text = "一月内完成\(super.selectedDays)次打卡后项目将不会出现在今日打卡中"
    }
    
    private func setUpUI() {
        super.segmentedControl?.selectedSegmentIndex = 1
        super.accordingToWeekDaysView?.isHidden = true
        super.accordingToDaysView?.isHidden = false
        super.segmentedControl?.isHidden = true
        super.titleLabel?.text = "设置每月打卡天数"
        self.leftLabel?.text = "每月"
    }
    
    override func updateUI() {
        super.updateUI()
    }
    
}


