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
        
        
        
        
        updateUI()
        
    }
    
    override func createWindow() -> UIView {
        if NotificationManager.shared.isNotificationEnabled() {
            super.size = .small
        } else {
            super.size = .large
        }
        return NotificationTimePopUpViewBuilder(popUpViewController: super.popUpViewController, frame: super.frame, notificationTime: AppEngine.shared.userSetting.notificationTime, notificationTimePopUp: self).buildView()
        
    }
    
    override func getStoredData() -> Any? {
        var notificationTime: Array<CustomTime> = []
        
        for subview in self.timePickerView!.subviews {
            if let datePicker = subview as? UIDatePicker {
                let date = datePicker.date
                let components = Calendar.current.dateComponents([.hour, .minute], from: date)
                notificationTime.append(CustomTime(hour: components.hour!, minute: components.minute!, second: 0, oneTenthSecond: 0))
            }
        }
        return notificationTime
    }
    
    private func updatePickerView() {
        if self.segmentedControl?.selectedSegmentIndex == 0 {
            firstDatePicker?.isHidden = false
            secondDatePicker?.isHidden = true
            firstDatePicker?.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.firstDatePicker?.alpha = 1
            })
        } else if self.segmentedControl?.selectedSegmentIndex == 1 {
            firstDatePicker?.isHidden = true
            secondDatePicker?.isHidden = false
            secondDatePicker?.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.secondDatePicker?.alpha = 1
            })
        }
    }
    
    private func updateContent() {
        super.cancelButton?.isHidden = true
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
