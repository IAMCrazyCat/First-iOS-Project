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
    var notificationIsEnabled: Bool
    init(popUpViewController: PopUpViewController, frame: CGRect, notificationTime: Array<CustomTime>, notificationIsEnabled: Bool){
        self.notificationTime = notificationTime
        self.notificationIsEnabled = notificationIsEnabled
        super.init(popUpViewController: popUpViewController, frame: frame)
    }
    
    
    
    override func buildView() -> UIView {
        _ = super.buildView()
        setUpUI()
        addTimePicker()
        
        if notificationIsEnabled {
            addExplanationLabel()
        } else {
            addInstruction()
        }
        
        return super.outPutView
    }
    
    private func setUpUI() {
        super.titleLabel.text = "打卡提醒时间"
    }
    
    private func addInstruction() {
        
        let goToSettingButton = UIButton()
        goToSettingButton.setTitle("前往设置", for: .normal)
        goToSettingButton.setTitleColor(AppEngine.shared.userSetting.smartVisibleThemeColor, for: .normal)
        goToSettingButton.titleLabel?.font = AppEngine.shared.userSetting.smallFont
        goToSettingButton.addTarget(Actions.shared, action: Actions.goToSystemSettingAction, for: .touchUpInside)
       
        super.contentView.addSubview(goToSettingButton)
        
        goToSettingButton.translatesAutoresizingMaskIntoConstraints = false
        goToSettingButton.bottomAnchor.constraint(equalTo: super.contentView.bottomAnchor, constant: -super.setting.mainPadding).isActive = true
        goToSettingButton.centerXAnchor.constraint(equalTo: super.contentView.centerXAnchor).isActive = true
        goToSettingButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        goToSettingButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        let instructionLabel = UILabel()
        instructionLabel.lineBreakMode = .byWordWrapping
        instructionLabel.numberOfLines = 3
        instructionLabel.font = AppEngine.shared.userSetting.smallFont
        instructionLabel.textAlignment = .center
        instructionLabel.text = "系统通知已关闭，若想启用提醒\n请在 设置-通知-\(App.name) 中打开允许通知"
        instructionLabel.sizeToFit()
        
        super.contentView.addSubview(instructionLabel)
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        instructionLabel.centerXAnchor.constraint(equalTo: super.contentView.centerXAnchor).isActive = true
        instructionLabel.bottomAnchor.constraint(equalTo: goToSettingButton.topAnchor, constant: -super.setting.mainGap).isActive = true
        
        
        let instructionImageView = UIImageView()
        instructionImageView.image = #imageLiteral(resourceName: "NotificationInstruction")
        instructionImageView.layer.cornerRadius = 15
        instructionImageView.clipsToBounds = true
        instructionImageView.contentMode = .scaleAspectFill

        super.contentView.addSubview(instructionImageView)
        
        instructionImageView.translatesAutoresizingMaskIntoConstraints = false
        instructionImageView.leftAnchor.constraint(equalTo: super.contentView.leftAnchor, constant: super.setting.mainPadding * 2).isActive = true
        instructionImageView.rightAnchor.constraint(equalTo: super.contentView.rightAnchor, constant: -super.setting.mainPadding * 2).isActive = true
        instructionImageView.topAnchor.constraint(equalTo: super.contentView.topAnchor, constant: 0).isActive = true
        instructionImageView.bottomAnchor.constraint(equalTo: instructionLabel.topAnchor, constant: -super.setting.mainGap).isActive = true
        
        
        
    }
    
    private func addTimePicker() {
        
        var lastPicker: UIDatePicker? = nil
        var number = 1
        for time in notificationTime {
        
            let picker = UIDatePicker()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "H m"
            let date = dateFormatter.date(from: "\(time.hour) \(time.minute)")

            picker.accessibilityIdentifier = "DatePicker"
            picker.backgroundColor = AppEngine.shared.userSetting.themeColor.uiColor
            picker.tintColor = AppEngine.shared.userSetting.smartLabelColor
            picker.date = date!
            picker.datePickerMode = .time
            
            if notificationIsEnabled {
                picker.alpha = 1
            } else {
                picker.alpha = 0
            }
            self.contentView.addSubview(picker)
            
            
            picker.translatesAutoresizingMaskIntoConstraints = false
            
            super.contentView.layoutIfNeeded()
            let leftConstant: CGFloat = ((super.contentView.frame.width) - (picker.frame.width * 2 + 80)) / 2 // Only works for two notifications, should be changed in future
            print("???\(leftConstant)")
            if lastPicker != nil {
            
                picker.leftAnchor.constraint(equalTo: lastPicker!.rightAnchor, constant: 80).isActive = true
                picker.centerYAnchor.constraint(equalTo: lastPicker!.centerYAnchor).isActive = true
            } else {
                picker.leftAnchor.constraint(equalTo: super.contentView.leftAnchor, constant: leftConstant).isActive = true
                picker.centerYAnchor.constraint(equalTo: super.contentView.centerYAnchor, constant: -20).isActive = true
            }
            
            let label = UILabel()
            label.textColor = .label
            label.font = AppEngine.shared.userSetting.smallFont
            label.text = "第\(number)次通知"
            label.sizeToFit()
            self.contentView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leftAnchor.constraint(equalTo: picker.leftAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: picker.topAnchor, constant: -10).isActive = true
            
            lastPicker = picker
            number += 1
        }

        
    }
 
    
    private func addExplanationLabel() {
        let explanationLabel = UILabel()
        explanationLabel.lineBreakMode = .byWordWrapping
        explanationLabel.numberOfLines = 2
        explanationLabel.font = AppEngine.shared.userSetting.smallFont
        explanationLabel.textColor = super.setting.grayColor
        explanationLabel.text = "如果没有在进行当中的项目，您将不会收到通知，若想禁用通知，您可以在系统设置里关闭"
        
        super.contentView.addSubview(explanationLabel)
        explanationLabel.translatesAutoresizingMaskIntoConstraints = false
        explanationLabel.leftAnchor.constraint(equalTo: super.contentView.leftAnchor, constant: 5).isActive = true
        explanationLabel.rightAnchor.constraint(equalTo: super.contentView.rightAnchor, constant: 5).isActive = true
        explanationLabel.bottomAnchor.constraint(equalTo: super.contentView.bottomAnchor).isActive = true
        explanationLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
