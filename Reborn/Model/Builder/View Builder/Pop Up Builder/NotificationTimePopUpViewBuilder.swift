//
//  NotificationPopUpViewBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 14/3/21.
//

import Foundation
import UIKit
class NotificationTimePopUpViewBuilder: PopUpViewBuilder {
    var notificationTime: Array<CustomTime>
    let notificationTimePopUp: NotificationTimePopUp
    let explanationLabel = UILabel()
    let instructionView = UIView()
    let timePickerView = UIView()
    
    
    init(popUpViewController: PopUpViewController, frame: CGRect, notificationTime: Array<CustomTime>, notificationTimePopUp: NotificationTimePopUp){
        self.notificationTime = notificationTime
        self.notificationTimePopUp = notificationTimePopUp
        super.init(popUpViewController: popUpViewController, frame: frame)
    }
    
    
    
    override func buildView() -> UIView {
        super.buildView()
        setUpUI()
        addTimePickerView()
        addInstructionView()
        return super.outPutView
    }
    
    private func addTimePickerView() {

        timePickerView.accessibilityIdentifier = "TimePickerView"
        timePickerView.frame = super.contentView.bounds
        super.contentView.layoutIfNeeded()
        super.contentView.addSubview(timePickerView)
        
        addSegmentedControl()
        addExplanationLabel()
        addTimePicker()
    }
    
    private func setUpUI() {
        super.titleLabel.text = "固定提醒时间"
    }
    
    private func addInstructionView() {
      
        instructionView.accessibilityIdentifier = "InstructionView"
        instructionView.frame = super.contentView.bounds
        super.contentView.layoutIfNeeded()
        super.contentView.addSubview(instructionView)
        
            
        let goToSettingButton = UIButton()
        goToSettingButton.setTitle("前往设置", for: .normal)
        goToSettingButton.setTitleColor(AppEngine.shared.userSetting.smartVisibleThemeColor, for: .normal)
        goToSettingButton.titleLabel?.font = AppEngine.shared.userSetting.smallFont
        goToSettingButton.addTarget(Actions.shared, action: Actions.goToSystemSettingAction, for: .touchUpInside)
       
        instructionView.addSubview(goToSettingButton)
        
        goToSettingButton.translatesAutoresizingMaskIntoConstraints = false
        goToSettingButton.bottomAnchor.constraint(equalTo: instructionView.bottomAnchor, constant: -super.setting.mainPadding).isActive = true
        goToSettingButton.centerXAnchor.constraint(equalTo: instructionView.centerXAnchor).isActive = true
        goToSettingButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        goToSettingButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        let instructionLabel = UILabel()
        instructionLabel.lineBreakMode = .byWordWrapping
        instructionLabel.numberOfLines = 3
        instructionLabel.font = AppEngine.shared.userSetting.smallFont
        instructionLabel.textAlignment = .center
        instructionLabel.text = "系统通知已关闭，若想启用提醒\n请在 设置-通知-\(App.name) 中打开允许通知"
        instructionLabel.sizeToFit()
        
        instructionView.addSubview(instructionLabel)
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        instructionLabel.centerXAnchor.constraint(equalTo: instructionView.centerXAnchor).isActive = true
        instructionLabel.bottomAnchor.constraint(equalTo: goToSettingButton.topAnchor, constant: -super.setting.mainGap).isActive = true
        
        
        let instructionImageView = UIImageView()
        instructionImageView.image = #imageLiteral(resourceName: "NotificationInstruction")
        instructionImageView.layer.cornerRadius = 15
        instructionImageView.clipsToBounds = true
        instructionImageView.contentMode = .scaleAspectFill

        instructionView.addSubview(instructionImageView)
        
        instructionImageView.translatesAutoresizingMaskIntoConstraints = false
        instructionImageView.leftAnchor.constraint(equalTo: instructionView.leftAnchor, constant: super.setting.mainPadding * 2).isActive = true
        instructionImageView.rightAnchor.constraint(equalTo: instructionView.rightAnchor, constant: -super.setting.mainPadding * 2).isActive = true
        instructionImageView.topAnchor.constraint(equalTo: instructionView.topAnchor, constant: 0).isActive = true
        instructionImageView.bottomAnchor.constraint(equalTo: instructionLabel.topAnchor, constant: -super.setting.mainGap).isActive = true
        
        
        
    }
    
    private func addSegmentedControl() {

        let items : [String] = ["关", "启用"]
            
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.accessibilityIdentifier = "SegmentedControl"
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setSmartAppearance(withBackgroundStyle: .followSystem)
        segmentedControl.addTarget(notificationTimePopUp, action: #selector(notificationTimePopUp.segmentedControlValueChanged(_:)), for: .valueChanged)
        self.timePickerView.addSubview(segmentedControl)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: self.timePickerView.topAnchor, constant: 0).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: self.timePickerView.rightAnchor, constant: -15).isActive = true
    }
    
    private func addTimePicker() {
        
        let segmentedControl = timePickerView.getSubviewBy(idenifier: "SegmentedControl")!
        var number = 1

        for time in notificationTime {
        
            let picker = UIDatePicker()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "H m"
            let date = dateFormatter.date(from: "\(time.hour) \(time.minute)")

            picker.accessibilityIdentifier = "DatePicker\(number)"
            picker.date = date!
            picker.datePickerMode = .time
            if #available(iOS 13.4, *) {
                picker.preferredDatePickerStyle = .wheels
            }
            
            self.timePickerView.addSubview(picker)
            super.contentView.layoutIfNeeded()
            picker.translatesAutoresizingMaskIntoConstraints = false
            picker.leftAnchor.constraint(equalTo: self.timePickerView.leftAnchor).isActive = true
            picker.rightAnchor.constraint(equalTo: self.timePickerView.rightAnchor).isActive = true
            picker.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10).isActive = true
            picker.bottomAnchor.constraint(equalTo: self.explanationLabel.topAnchor).isActive = true

            number += 1
        }

        
    }
 
    
    private func addExplanationLabel() {
       
        explanationLabel.accessibilityIdentifier = "ExplanationLabel"
        explanationLabel.lineBreakMode = .byWordWrapping
        explanationLabel.numberOfLines = 2
        explanationLabel.font = AppEngine.shared.userSetting.smallFont
        explanationLabel.textColor = super.setting.grayColor
        explanationLabel.text = "此提醒属于固定提醒，每天会定时提醒您查看习惯和打卡，关闭此提醒不影响项目的任务提醒"
        
        self.timePickerView.addSubview(explanationLabel)
        explanationLabel.translatesAutoresizingMaskIntoConstraints = false
        explanationLabel.leftAnchor.constraint(equalTo: self.timePickerView.leftAnchor, constant: 5).isActive = true
        explanationLabel.rightAnchor.constraint(equalTo: self.timePickerView.rightAnchor, constant: 5).isActive = true
        explanationLabel.bottomAnchor.constraint(equalTo: self.timePickerView.bottomAnchor).isActive = true
        explanationLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
