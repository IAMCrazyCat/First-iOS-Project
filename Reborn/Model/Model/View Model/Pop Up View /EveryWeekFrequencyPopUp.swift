//
//  EveryWeekFrequencyPopUp.swift
//  Reborn
//
//  Created by Christian Liu on 9/6/21.
//

import Foundation
import UIKit
class EveryWeekFrequencyPopUp: PopUpImpl, PickerViewPopUp {
    var segmentedControl: UISegmentedControl? {
        return super.contentView?.getSubviewBy(idenifier: "SegmentedControl") as? UISegmentedControl
    }
    
    var accordingToWeekDaysView: UIView? {
        return super.contentView?.getSubviewBy(idenifier: "AccordingToWeekDaysView")
    }
    
    var accordingToDaysView: UIView? {
        return super.contentView?.getSubviewBy(idenifier: "AccordingToDaysView")
    }
    
    var instructionView: UIView? {
        return super.contentView?.getSubviewBy(idenifier: "InstructionView")
    }
    
    var instructionLabel: UILabel? {
        return instructionView?.getSubviewBy(idenifier: "InstructionLabel") as? UILabel
    }
    
    var weekdayButtons: Array<CustomButton> {
        var buttons: Array<CustomButton> = []
        if accordingToWeekDaysView != nil {
            for button in accordingToWeekDaysView!.subviews {
                if let weekdayButton = button as? CustomButton {
                    buttons.append(weekdayButton)
                }
            }
        }
        return buttons
    }
    
    var pickerView: UIPickerView? {
        return accordingToDaysView?.getSubviewBy(idenifier: "PickerView") as? UIPickerView
    }
    
    
    var selectedWeekdays: Array<WeekDay> = []
    var selectedDays: Int = 0
    var pickerViewData: [CustomData] = []
    
    init(presentAnimationType: PopUpAnimationType, size: PopUpSize = .small, popUpViewController: PopUpViewController) {
        super.init(presentAnimationType: presentAnimationType, type: .everyWeekFreqencyPopUp, size: size, popUpViewController: popUpViewController)
        addTargetToWeekdayButtons()
        addTargetToSegmentedControl()
        setPickerViewData()
    }
    
   
    

    override func createWindow() -> UIView {
        return FrequencyPopUpViewBuilder(popUpViewController: super.popUpViewController, frame: super.frame).buildView()
    }
    
    override func getStoredData() -> Any? {
        
        if segmentedControl?.selectedSegmentIndex == 0 {
            return self.selectedWeekdays
        } else if segmentedControl?.selectedSegmentIndex == 1 {
            return self.selectedDays
        }
       
        return nil
    }
    
    private func addTargetToSegmentedControl() {
        segmentedControl?.addTarget(self, action: #selector(self.segmentedControlValueChanged), for: .valueChanged)
    }
    
    private func addTargetToWeekdayButtons() {
        for weekdayButton in weekdayButtons {
            weekdayButton.addTarget(self, action: #selector(self.weekdayButtonPressed), for: .touchUpInside)
        }
    }
    
  
    
    internal func setPickerViewData() {
        pickerView?.delegate = popUpViewController
        pickerView?.dataSource = popUpViewController
        self.pickerViewData = PickerViewData.weekDays
    }
    
    @objc
    private func weekdayButtonPressed(_ sender: CustomButton!) {
        Vibrator.vibrate(withImpactLevel: .light)
        sender.isSelected = !sender.isSelected
        if let weekday = sender.value as? WeekDay {
            
            if sender.isSelected {
                self.selectedWeekdays.append(weekday)
            } else {
                var index = 0
                for selectedWeekday in selectedWeekdays {
                    if weekday.rawValue == selectedWeekday.rawValue {
                        selectedWeekdays.remove(at: index)
                    }
                    index += 1
                }
                
            }
        }
        self.updateUI()
        print(selectedWeekdays)
    }
    
    @objc
    private func segmentedControlValueChanged(_ sender: UISegmentedControl!) {
        Vibrator.vibrate(withImpactLevel: .light)
        self.updateUI()
    }
    
    private func updateLabels() {
        if self.segmentedControl?.selectedSegmentIndex == 0 {
            super.titleLabel?.text = "设置每周打卡日"
            self.accordingToWeekDaysView?.isHidden = false
            self.accordingToDaysView?.isHidden = true
            self.instructionLabel?.text = "未设置在计划内的打卡日不会出现在今日打卡中"
            
            if selectedWeekdays.count >= 7 {
                self.instructionLabel?.text = "项目频率已设置为每天打卡"
            }
            
        } else if self.segmentedControl?.selectedSegmentIndex == 1 {
            super.titleLabel?.text = "设置每周打卡次数"
            self.accordingToWeekDaysView?.isHidden = true
            self.accordingToDaysView?.isHidden = false
            self.instructionView?.isHidden = false
            
            if let pickerView = self.pickerView {
                self.selectedDays = pickerView.selectedRow(inComponent: 0) + 1
                
                if pickerView.selectedRow(inComponent: 0) + 1 < 7 {
                    self.instructionLabel?.text = "一周内完成\(pickerView.selectedRow(inComponent: 0) + 1)次打卡后项目将不会出现在今日打卡中"
                } else {
                    self.instructionLabel?.text = "项目频率已设置为每天打卡"
                }

            }
        }
    }
    
    
    override func updateUI() {
        updateLabels()
    }
    
    // PickerViewMethods
    
    func numberOfComponents() -> Int {
        return 1
    }
    
    func numberOfRowsInComponents() -> Int {
        return pickerViewData.count
    }
    
    func titles() -> Array<String> {
        var titles: [String] = []
        for customData in pickerViewData {
            titles.append("\(customData.data ?? 0)")
        }
        return titles
    }
    
    func didSelectRow() {
        self.updateUI()
    }
}
