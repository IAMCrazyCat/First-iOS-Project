//
//  NotificationTimePopUp.swift
//  Reborn
//
//  Created by Christian Liu on 14/3/21.
//

import Foundation
import UIKit
class NotificationTimePopUp: PopUpImpl {
    private var firstDatePicker: UIDatePicker {
        return super.contentView?.getSubviewBy(idenifier: "DatePicker1") as! UIDatePicker
        
    }
    
    private var secondDatePicker: UIDatePicker {
        return super.contentView?.getSubviewBy(idenifier: "DatePicker2") as! UIDatePicker
        
    }
    
    private var segmentedControl: UISegmentedControl? {
        return super.contentView?.getSubviewBy(idenifier: "SegmentedControl") as? UISegmentedControl
    }
    
    public var pikerViewData: Array<Any> = []
    
    init(presentAnimationType: PopUpAnimationType, size: PopUpSize = .large, popUpViewController: PopUpViewController) {

        super.init(presentAnimationType: presentAnimationType, type: .notificationTimePopUp, size: size, popUpViewController: popUpViewController)
        super.cancelButton?.isHidden = true
        segmentedControl?.addTarget(self, action: #selector(self.segmentedControlValueChanged(_:)), for: .valueChanged)
        secondDatePicker.isHidden = true
    }
    
    override func createWindow() -> UIView {
        if AppEngine.shared.isNotificationEnabled() {
            super.size = .small
        } else {
            super.size = .large
        }
        return NotificationTimePopUpViewBuilder(popUpViewController: super.popUpViewController, frame: super.frame, notificationTime: AppEngine.shared.userSetting.notificationTime, notificationIsEnabled: AppEngine.shared.isNotificationEnabled()).buildView()
        
    }
    
    override func getStoredData() -> Any? {
        var notificationTime: Array<CustomTime> = []
        
        for subview in super.contentView!.subviews {
            if let datePicker = subview as? UIDatePicker {
                let date = datePicker.date
                let components = Calendar.current.dateComponents([.hour, .minute], from: date)
                notificationTime.append(CustomTime(hour: components.hour!, minute: components.minute!, second: 0, oneTenthSecond: 0))
            }
        }
        for test in notificationTime {
            print("\(test.hour):\(test.minute)")
        }
        
        return notificationTime
    }
    
    private func updatePickerView() {
        if self.segmentedControl?.selectedSegmentIndex == 0 {
            firstDatePicker.isHidden = false
            secondDatePicker.isHidden = true
            firstDatePicker.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.firstDatePicker.alpha = 1
            })
        } else if self.segmentedControl?.selectedSegmentIndex == 1 {
            firstDatePicker.isHidden = true
            secondDatePicker.isHidden = false
            secondDatePicker.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.secondDatePicker.alpha = 1
            })
        }
    }
    
    override func updateUI() {
        updatePickerView()
    }
    
    @objc
    private func segmentedControlValueChanged(_ sender: UISegmentedControl!) {
        Vibrator.vibrate(withImpactLevel: .light)
        updateUI()
    }
    
}
