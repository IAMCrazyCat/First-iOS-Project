//
//  EveryWeekFrequencyPopUp.swift
//  Reborn
//
//  Created by Christian Liu on 9/6/21.
//

import Foundation
import UIKit
class EveryWeekFrequencyPopUp: PopUpImpl, PickerViewPopUp {
    
    var newFrequency: NewFrequency?
    var weekdays: Array<WeekDay> = []
    
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
    
    
    var selectedWeekdays: Array<WeekDay> {
        var selectedWeekdays: Array<WeekDay> = []
        guard let customButtonView =  self.accordingToWeekDaysView else { return selectedWeekdays }
        for subview in customButtonView.subviews {
            if let customButton = subview as? CustomButton, let weekday = customButton.value as? WeekDay {
                customButton.isSelected == true ? selectedWeekdays.append(weekday) : ()
            }
        }
        return selectedWeekdays
    }
    var selectedDays: Int {
        if let pickerViewSelectedRow = pickerView?.selectedRow(inComponent: 0) {
            return pickerViewSelectedRow + 1
        } else {
            return 1
        }
        
        
    }
    var pickerViewData: [CustomData] = []
    
    init(presentAnimationType: PopUpAnimationType, size: PopUpSize = .small, popUpViewController: PopUpViewController, newFrequency: NewFrequency?) {
        
        self.newFrequency = newFrequency
        super.init(presentAnimationType: presentAnimationType, type: .everyWeekFreqencyPopUp, size: size, popUpViewController: popUpViewController)
        addTargetToWeekdayButtons()
        addTargetToSegmentedControl()
        setPickerViewData()
    }
    
    override func viewDidLoad() {
        print("WTF!!!!!!")
        
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func viewWillAppear() {
        
    }
    
    override func viewDidAppear() {
        self.setUpPreSettings()
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
    
    override func isReadyToDismiss() -> Bool {
        
        if segmentedControl?.selectedSegmentIndex == 0 {
            
            if selectedWeekdays.count > 0 {
                return true
            } else {
                self.instructionLabel?.text = "请选择至少一天打卡日"
                self.instructionLabel?.textColor = .systemRed
                return false
            }
            
        } else {
            return true
        }
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
        self.updateUI()
        print(selectedWeekdays)
    }
    
    @objc
    private func segmentedControlValueChanged(_ sender: UISegmentedControl!) {
        Vibrator.vibrate(withImpactLevel: .light)
        self.updateUI()
    }
    
    internal func updateLabels() {
        self.instructionLabel?.textColor = super.setting.smartLabelGrayColor
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
            
            if selectedDays < 7 {
                self.instructionLabel?.text = "一周内完成\(self.selectedDays)次打卡后项目将不会出现在今日打卡中"
            } else {
                self.instructionLabel?.text = "项目频率已设置为每天打卡"
            }
        }
    }
    
    internal func setUpPreSettings() {

        switch self.newFrequency {
        case is EveryWeek:
            self.segmentedControl?.selectedSegmentIndex = 1
            self.pickerView?.selectRow((newFrequency as! EveryWeek).days - 1, inComponent: 0, animated: true)
        case is EveryWeekdays:
            self.segmentedControl?.selectedSegmentIndex = 0
            self.weekdays = (newFrequency as! EveryWeekdays).weekdays
            for weekdayButton in self.weekdayButtons {
                if let weekday = weekdayButton.value as? WeekDay, self.weekdays.contains(weekday) {
                    weekdayButton.isSelected = true
                } else {
                    weekdayButton.isSelected = false
                }
               
            }
        default:
            break
        }
        
        
    }
    
    
    override func updateUI() {
        
        updateLabels()

    }
    
    
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
