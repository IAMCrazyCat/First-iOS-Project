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
        if let pickerView = self.pickerView {
            if pickerView.numberOfComponents >= 1 {
                return pickerView.selectedRow(inComponent: 0) + 1
            }
        }
        return 1
        
    }
    var pickerViewData: [CustomData] = []
    
    init(presentAnimationType: PopUpAnimationType, size: PopUpSize = .small, popUpViewController: PopUpViewController, newFrequency: NewFrequency?) {
        
        self.newFrequency = newFrequency
        super.init(presentAnimationType: presentAnimationType, type: .everyWeekFreqencyPopUp, size: size, popUpViewController: popUpViewController)
        addTargetToWeekdayButtons()
        addTargetToSegmentedControl()
        setPickerViewData()
        presetWeekdays()
    }
    
    override func viewDidLoad() {
        
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func viewWillAppear() {
        
    }
    
    override func viewDidAppear() {
        presetDays()
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
        self.excuteViewAnimation(withSegmentedIndex: sender.selectedSegmentIndex)
        self.updateUI()
    }
    
    private func excuteViewAnimation(withSegmentedIndex index: Int) {
        let animationDuration: TimeInterval = 0.45
        var weekdayButtonsForAnimation: Array<UIView> = []
        for customButton in self.weekdayButtons {
            weekdayButtonsForAnimation.append(customButton)
        }

        if index == 0 {
            weekdayButtonsForAnimation.sort {
                $0.frame.origin.x > $1.frame.origin.x
            }
           
            
            let fromValue = self.accordingToDaysView?.layer.position.x ?? 0
            let toValue = (self.accordingToDaysView?.layer.position.x ?? 0) + 400

            let viewMoveToRightAnimation = CABasicAnimation(keyPath: "position.x")
            viewMoveToRightAnimation.beginTime = CACurrentMediaTime()
            viewMoveToRightAnimation.fromValue = fromValue
            viewMoveToRightAnimation.toValue = toValue
            viewMoveToRightAnimation.duration = animationDuration
            viewMoveToRightAnimation.fillMode = CAMediaTimingFillMode.forwards
            viewMoveToRightAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.29, 0.34, 0.02, 1)
            viewMoveToRightAnimation.isRemovedOnCompletion = false
            self.accordingToDaysView?.layer.add(viewMoveToRightAnimation, forKey: nil)
           
           
            
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration / 2 ) {
                self.accordingToDaysView?.isHidden = true
                self.accordingToWeekDaysView?.isHidden = false
                var delay: TimeInterval = 0
                var currentX: CGFloat = weekdayButtonsForAnimation.first?.frame.origin.x ?? 0
                for buttonForAnimation in weekdayButtonsForAnimation {
                    let fromValue = buttonForAnimation.layer.position.x - 400
                    let toValue = buttonForAnimation.layer.position.x
                    let viewMoveToRightAnimation = CABasicAnimation(keyPath: "position.x")
                    viewMoveToRightAnimation.beginTime = CACurrentMediaTime() + delay
                    viewMoveToRightAnimation.fromValue = fromValue
                    viewMoveToRightAnimation.toValue = toValue
                    viewMoveToRightAnimation.duration = animationDuration
                    viewMoveToRightAnimation.fillMode = CAMediaTimingFillMode.forwards
                    viewMoveToRightAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.29, 0.34, 0.02, 1)
                    viewMoveToRightAnimation.isRemovedOnCompletion = false
                    buttonForAnimation.layer.add(viewMoveToRightAnimation, forKey: nil)
                    
                    if buttonForAnimation.frame.origin.x <= currentX {
                        delay += 0.05
                    }
                    
                    currentX = buttonForAnimation.frame.origin.x
                }
            }
        
        }
        
        if index == 1 {
            weekdayButtonsForAnimation.sort {
                $0.frame.origin.x < $1.frame.origin.x
            }
            var delay: TimeInterval = 0
            var currentX: CGFloat = weekdayButtonsForAnimation.first?.frame.origin.x ?? 0
            for buttonForAnimation in weekdayButtonsForAnimation {
                let fromValue = buttonForAnimation.layer.position.x
                let toValue = buttonForAnimation.layer.position.x - 400
                
                let viewMoveToLeftAnimation = CABasicAnimation(keyPath: "position.x")
                viewMoveToLeftAnimation.beginTime = CACurrentMediaTime() + delay
                viewMoveToLeftAnimation.fromValue = fromValue
                viewMoveToLeftAnimation.toValue = toValue
                viewMoveToLeftAnimation.duration = animationDuration
                viewMoveToLeftAnimation.fillMode = CAMediaTimingFillMode.forwards
                viewMoveToLeftAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.29, 0.34, 0.02, 1)
                viewMoveToLeftAnimation.isRemovedOnCompletion = false
                buttonForAnimation.layer.add(viewMoveToLeftAnimation, forKey: nil)
                
                if buttonForAnimation.frame.origin.x >= currentX {
                    delay += 0.05
                    
                }
                currentX = buttonForAnimation.frame.origin.x
            }

            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                let fromValue = (self.accordingToDaysView?.layer.position.x ?? 0) + 400
                let toValue = self.accordingToDaysView?.layer.position.x ?? 0
                self.accordingToWeekDaysView?.isHidden = true
                self.accordingToDaysView?.isHidden = false
                let viewMoveToLeftAnimation = CABasicAnimation(keyPath: "position.x")
                viewMoveToLeftAnimation.beginTime = CACurrentMediaTime()
                viewMoveToLeftAnimation.fromValue = fromValue
                viewMoveToLeftAnimation.toValue = toValue
                viewMoveToLeftAnimation.duration = animationDuration
                viewMoveToLeftAnimation.fillMode = CAMediaTimingFillMode.forwards
                viewMoveToLeftAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.29, 0.34, 0.02, 1)
                viewMoveToLeftAnimation.isRemovedOnCompletion = false
                self.accordingToDaysView?.layer.add(viewMoveToLeftAnimation, forKey: nil)
            }
            
            
            
            
            
        }
    }
    
    internal func updateLabels() {
        self.instructionLabel?.textColor = super.setting.smartLabelGrayColor
        if self.segmentedControl?.selectedSegmentIndex == 0 {
            super.titleLabel?.text = "设置每周打卡日"
            
            
            if selectedWeekdays.count >= 7 {
                self.instructionLabel?.text = "项目频率已设置为每天打卡"
            } else {
                self.instructionLabel?.text = "项目在非打卡日不会出现在今日打卡中"
            }
            
        } else if self.segmentedControl?.selectedSegmentIndex == 1 {

            super.titleLabel?.text = "设置每周打卡次数"
            if selectedDays < 7 {
                self.instructionLabel?.text = "一周内完成\(self.selectedDays)次打卡后项目将不会出现在今日打卡中"
            } else {
                self.instructionLabel?.text = "项目频率已设置为每天打卡"
            }
        }
    }
    
    
    internal func presetWeekdays() {
        if self.newFrequency is EveryWeekdays {
            self.segmentedControl?.selectedSegmentIndex = 0
            self.weekdays = (newFrequency as! EveryWeekdays).weekdays
            for weekdayButton in self.weekdayButtons {
                if let weekday = weekdayButton.value as? WeekDay, self.weekdays.contains(weekday) {
                    weekdayButton.isSelected = true
                } else {
                    weekdayButton.isSelected = false
                }
               
            }
        }
        self.updateUI()
    }
    
    internal func presetDays() {
        guard let everyMonthFrequency = self.newFrequency as? EveryWeek,
              let pickerView = self.pickerView
        else {
            return
        }
       
        self.segmentedControl?.selectedSegmentIndex = 1
        if pickerView.numberOfComponents >= 1 && pickerView.numberOfRows(inComponent: 0) >= everyMonthFrequency.days{
            self.excuteViewAnimation(withSegmentedIndex: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                pickerView.selectRow(everyMonthFrequency.days - 1, inComponent: 0, animated: true)
            })
            
        }
        
        self.updateUI()
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
