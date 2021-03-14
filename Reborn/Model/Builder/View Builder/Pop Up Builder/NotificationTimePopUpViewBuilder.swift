//
//  NotificationPopUpViewBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 14/3/21.
//

import Foundation
import UIKit
class NotificationTimePopUpViewBuilder: PopUpViewBuilder {
    
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
        let picker = UIDatePicker()
        picker.accessibilityIdentifier = "FirstDatePicker"
        picker.backgroundColor = AppEngine.shared.userSetting.themeColor

        
        self.contentView.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        //picker.widthAnchor.constraint(equalTo: super.contentView.widthAnchor).isActive = true
        picker.centerXAnchor.constraint(equalTo: super.contentView.centerXAnchor).isActive = true
        picker.centerYAnchor.constraint(equalTo: super.contentView.centerYAnchor).isActive = true
    }
}
