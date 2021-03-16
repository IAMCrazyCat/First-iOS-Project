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
    init(popUpViewController: PopUpViewController, frame: CGRect, notificationTime: Array<CustomTime>){
        self.notificationTime = notificationTime
        super.init(popUpViewController: popUpViewController, frame: frame)
    }
    
    
    override func buildView() -> UIView {
        _ = super.buildView()
        setUpUI()
        addTimePicker()
        return super.outPutView
    }
    private func setUpUI() {
        super.titleLabel.text = "打卡提醒时间"
    }
    
    func addTimePicker() {
        
        var lastPicker: UIDatePicker? = nil
        var number = 1
        for time in notificationTime {
        
            let picker = UIDatePicker()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "H m"
            let date = dateFormatter.date(from: "\(time.hour) \(time.minute)")
            picker.accessibilityIdentifier = "DatePicker"
            picker.backgroundColor = AppEngine.shared.userSetting.themeColor
            picker.date = date!
            picker.datePickerMode = .time
            self.contentView.addSubview(picker)
            
            
            picker.translatesAutoresizingMaskIntoConstraints = false
            if lastPicker != nil {
            
                picker.leftAnchor.constraint(equalTo: lastPicker!.rightAnchor, constant: 40).isActive = true
                picker.centerYAnchor.constraint(equalTo: lastPicker!.centerYAnchor).isActive = true
            } else {
                picker.leftAnchor.constraint(equalTo: super.contentView.leftAnchor, constant: 20).isActive = true
                picker.centerYAnchor.constraint(equalTo: super.contentView.centerYAnchor).isActive = true
            }
            
//            let label = UILabel()
//            label.textColor = .label
//            label.font = AppEngine.shared.userSetting.smallFont
//            label.text = "第\(number)次通知"
//            label.sizeToFit()
//            self.contentView.addSubview(label)
//            label.translatesAutoresizingMaskIntoConstraints = false
//            label.leftAnchor.constraint(equalTo: picker.leftAnchor).isActive = true
//            label.bottomAnchor.constraint(equalTo: picker.topAnchor, constant: -10).isActive = true
            
            lastPicker = picker
            number += 1
        }
        
        
    }
}
