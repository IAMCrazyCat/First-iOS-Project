//
//  EveryWeekFrequencyPopUpViewBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 9/6/21.
//

import Foundation
import UIKit
class FrequencyPopUpViewBuilder: PopUpViewBuilder {
    
    override func buildView() -> UIView {
        super.buildView()
        self.setUpTitle()
        self.addSegmentedControl()
        self.addInstrucrionView()
        self.addAccrodingToWeekDaysView()
        self.addAccrodingToDaysView()
        return super.outPutView
    }
    
    private func setUpTitle() {
        super.titleLabel.text = "设置每周打卡日"
    }
    
    private func addSegmentedControl() {
        let items = ["按日", "按天数"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.accessibilityIdentifier = "SegmentedControl"
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setSmartAppearance(withBackgroundStyle: .followSystem)
        super.contentView.addSubview(segmentedControl)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.topAnchor.constraint(equalTo: super.contentView.topAnchor, constant: 0).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: super.contentView.rightAnchor, constant: -20).isActive = true
    }
    
    private func addInstrucrionView() {
        let instructionView = UIView()
        instructionView.accessibilityIdentifier = "InstructionView"
        instructionView.backgroundColor = .clear
        super.contentView.addSubview(instructionView)
        instructionView.translatesAutoresizingMaskIntoConstraints = false
        instructionView.bottomAnchor.constraint(equalTo: super.contentView.bottomAnchor).isActive = true
        instructionView.leftAnchor.constraint(equalTo: super.contentView.leftAnchor, constant: 10).isActive = true
        instructionView.rightAnchor.constraint(equalTo: super.contentView.rightAnchor, constant: -10).isActive = true
        instructionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        instructionView.layoutIfNeeded()
        
        let instructionLabel = UILabel()
        instructionLabel.text = "未设置在计划内的日子不会出现在今日打卡中"
        instructionLabel.accessibilityIdentifier = "InstructionLabel"
        instructionLabel.frame = instructionView.bounds
        instructionLabel.lineBreakMode = .byWordWrapping
        instructionLabel.numberOfLines = 3
        instructionLabel.font = AppEngine.shared.userSetting.smallFont
        instructionLabel.textColor = super.setting.smartLabelGrayColor
        
        instructionView.addSubview(instructionLabel)
    }
    
    private func addAccrodingToWeekDaysView() {
        let instructionView = super.contentView.getSubviewBy(idenifier: "InstructionView")!
        let segmentedControl = super.contentView.getSubviewBy(idenifier: "SegmentedControl")!
        let accrodingToWeekDaysView = UIView()
        accrodingToWeekDaysView.accessibilityIdentifier = "AccordingToWeekDaysView"
        accrodingToWeekDaysView.backgroundColor = .clear
        super.contentView.addSubview(accrodingToWeekDaysView)
        
        accrodingToWeekDaysView.translatesAutoresizingMaskIntoConstraints = false
        accrodingToWeekDaysView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20).isActive = true
        accrodingToWeekDaysView.leftAnchor.constraint(equalTo: super.contentView.leftAnchor, constant: 20).isActive = true
        accrodingToWeekDaysView.rightAnchor.constraint(equalTo: super.contentView.rightAnchor, constant: -20).isActive = true
        accrodingToWeekDaysView.bottomAnchor.constraint(equalTo: instructionView.topAnchor, constant: -20).isActive = true
        
        super.contentView.layoutIfNeeded()
        
        let buttonSize: CGSize = CGSize(width: 70, height: 30)
        var maxmumNumberOfButtonInOneRow: Int {
            let width = accrodingToWeekDaysView.frame.width
            return Int(width / buttonSize.width)
        }
        
        var columns: Int {
           return Int(7 / maxmumNumberOfButtonInOneRow) + 1
            
        }

        var horizentalGap: CGFloat {
            let width = accrodingToWeekDaysView.frame.width
            let totalButtonWidth = buttonSize.width * CGFloat(maxmumNumberOfButtonInOneRow)
            let restWidth = width - totalButtonWidth
            return restWidth / CGFloat(maxmumNumberOfButtonInOneRow - 1)
        }
        var verticalGap: CGFloat {
            let height = accrodingToWeekDaysView.frame.height
            let totalButtonHeight = buttonSize.height * CGFloat(columns)
            let restHeight = height - totalButtonHeight
            return restHeight / (CGFloat(columns) + 1)
        }
       
        
        var numberOfButtonsAddedToCurrentRow = 0
        var x: CGFloat = 0
        var y: CGFloat = verticalGap
        for weekday in WeekDay.allCases {
            let weekdayButton = CustomButton()
            weekdayButton.frame = CGRect(x: x, y: y, width: buttonSize.width, height: buttonSize.height)
            weekdayButton.accessibilityIdentifier = "Day\(weekday.rawValue)Button"
            weekdayButton.value = weekday
            weekdayButton.setCornerRadius(corderRadius: 7)
            weekdayButton.setSmartSelectionColor()
            weekdayButton.setTitle(weekday.name, for: .normal)
            weekdayButton.titleLabel?.font = AppEngine.shared.userSetting.smallFont
            weekdayButton.isSelected = false
            accrodingToWeekDaysView.addSubview(weekdayButton)
            
            numberOfButtonsAddedToCurrentRow += 1
            
            if numberOfButtonsAddedToCurrentRow >= maxmumNumberOfButtonInOneRow {
                y += verticalGap + buttonSize.height
                x = 0
                numberOfButtonsAddedToCurrentRow = 0
            } else {
                x += buttonSize.width + horizentalGap
            }
            
           
        }
    }
    
    private func addAccrodingToDaysView() {
        let instructionView = super.contentView.getSubviewBy(idenifier: "InstructionView")!
        let segmentedControl = super.contentView.getSubviewBy(idenifier: "SegmentedControl")!
        let accordingToDaysView = UIView()
        accordingToDaysView.accessibilityIdentifier = "AccordingToDaysView"
        accordingToDaysView.backgroundColor = .clear
        accordingToDaysView.isHidden = true
        super.contentView.addSubview(accordingToDaysView)
        super.contentView.layoutIfNeeded()
        
        accordingToDaysView.translatesAutoresizingMaskIntoConstraints = false
        accordingToDaysView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 40).isActive = true
        accordingToDaysView.leftAnchor.constraint(equalTo: super.contentView.leftAnchor, constant: 20).isActive = true
        accordingToDaysView.rightAnchor.constraint(equalTo: super.contentView.rightAnchor, constant: -20).isActive = true
        accordingToDaysView.bottomAnchor.constraint(equalTo: instructionView.topAnchor, constant: -20).isActive = true
        
        let pickerView = UIPickerView()
        pickerView.accessibilityIdentifier = "PickerView"
        accordingToDaysView.addSubview(pickerView)
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        pickerView.topAnchor.constraint(equalTo: accordingToDaysView.topAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: accordingToDaysView.bottomAnchor).isActive = true
        pickerView.centerXAnchor.constraint(equalTo: accordingToDaysView.centerXAnchor).isActive = true
        
        
        let leftLabel = UILabel()
        leftLabel.text = "每周"
        leftLabel.accessibilityIdentifier = "LeftLabel"
        leftLabel.textColor = .label
        leftLabel.font = AppEngine.shared.userSetting.smallFont
        accordingToDaysView.addSubview(leftLabel)
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        leftLabel.rightAnchor.constraint(equalTo: pickerView.leftAnchor, constant: -10).isActive = true
        leftLabel.centerYAnchor.constraint(equalTo: pickerView.centerYAnchor).isActive = true
        
        let rightLabel = UILabel()
        rightLabel.text = "次"
        rightLabel.accessibilityIdentifier = "RightLabel"
        rightLabel.textColor = .label
        rightLabel.font = AppEngine.shared.userSetting.smallFont
        accordingToDaysView.addSubview(rightLabel)
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.leftAnchor.constraint(equalTo: pickerView.rightAnchor, constant: 10).isActive = true
        rightLabel.centerYAnchor.constraint(equalTo: pickerView.centerYAnchor).isActive = true

    }
    
    

}
