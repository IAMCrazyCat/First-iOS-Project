//
//  NotificationTimePopUp.swift
//  Reborn
//
//  Created by Christian Liu on 14/3/21.
//

import Foundation
import UIKit
class NotificationTimePopUp: PopUpImpl {
    
    private var timePickerView: UIView? {
        return super.contentView?.getSubviewBy(idenifier: "TimePickerView")
    }
    
    private var instructionView: UIView? {
        return super.contentView?.getSubviewBy(idenifier: "InstructionView")
    }
    
    private var firstDatePicker: UIDatePicker? {
        return timePickerView?.getSubviewBy(idenifier: "DatePicker1") as? UIDatePicker
        
    }
    
    private var secondDatePicker: UIDatePicker? {
        return timePickerView?.getSubviewBy(idenifier: "DatePicker2") as? UIDatePicker
        
    }
    
    private var segmentedControl: UISegmentedControl? {
        return timePickerView?.getSubviewBy(idenifier: "SegmentedControl") as? UISegmentedControl
    }
    


    
    public var pikerViewData: Array<Any> = []
    
    init(presentAnimationType: PopUpAnimationType, size: PopUpSize = .large, popUpViewController: PopUpViewController) {

        super.init(presentAnimationType: presentAnimationType, type: .notificationTimePopUp, size: size, popUpViewController: popUpViewController)

        if AppEngine.shared.userSetting.notificationTime.isEmpty {
            self.segmentedControl?.selectedSegmentIndex = 0
        } else {
            self.segmentedControl?.selectedSegmentIndex = 1
        }
        updateUI()
        
    }
    
    override func createWindow() -> UIView {
        if NotificationManager.shared.isNotificationEnabled() {
            super.size = .small
        } else {
            super.size = .large
        }
        if AppEngine.shared.userSetting.notificationTime.isEmpty {
            return NotificationTimePopUpViewBuilder(popUpViewController: super.popUpViewController, frame: super.frame, notificationTime: [CustomTime(hour: 21, minute: 0, second: 0, oneTenthSecond: 0)], notificationTimePopUp: self).buildView()
           
        } else {
            return NotificationTimePopUpViewBuilder(popUpViewController: super.popUpViewController, frame: super.frame, notificationTime: AppEngine.shared.userSetting.notificationTime, notificationTimePopUp: self).buildView()
        }
       
        
    }
    
    override func getStoredData() -> Any? {
        var notificationTime: Array<CustomTime> = []
        
        if self.segmentedControl?.selectedSegmentIndex == 1 {
            if let date = firstDatePicker?.date {
                let components = Calendar.current.dateComponents([.hour, .minute], from: date)
                notificationTime.append(CustomTime(hour: components.hour!, minute: components.minute!, second: 0, oneTenthSecond: 0))
            }
        }
        return notificationTime
    }
    
    private func updatePickerView() {
       
        if self.segmentedControl?.selectedSegmentIndex == 0 {
            firstDatePicker?.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.3, animations: {
                self.firstDatePicker?.alpha = 0.3
            })
        } else if self.segmentedControl?.selectedSegmentIndex == 1 {
            firstDatePicker?.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.3, animations: {
                self.firstDatePicker?.alpha = 1
            })
        }
    }
    
    private func updateContent() {
   
        super.cancelButton?.isHidden = true
        self.secondDatePicker?.isHidden = true
        self.timePickerView?.isHidden = !NotificationManager.shared.isNotificationEnabled()
        self.instructionView?.isHidden = NotificationManager.shared.isNotificationEnabled()
    }
    
    override func updateUI() {
        updatePickerView()
        updateContent()
    }
    
    @objc
    public func segmentedControlValueChanged(_ sender: UISegmentedControl!) {
        Vibrator.vibrate(withImpactLevel: .light)
        updateUI()
    }
    
}
