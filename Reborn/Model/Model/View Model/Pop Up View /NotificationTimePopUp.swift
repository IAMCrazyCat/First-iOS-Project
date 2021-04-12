//
//  NotificationTimePopUp.swift
//  Reborn
//
//  Created by Christian Liu on 14/3/21.
//

import Foundation
import UIKit
class NotificationTimePopUp: PopUpImpl {
    public var firstDatePicker: UIDatePicker {
        return super.contentView?.getSubviewBy(idenifier: "DatePicker") as! UIDatePicker
        
    }
    
    public var pikerViewData: Array<Any> = []
    
    init(presentAnimationType: PopUpAnimationType, size: PopUpSize = .large, popUpViewController: PopUpViewController) {

        super.init(presentAnimationType: presentAnimationType, type: .notificationTimePopUp, size: size, popUpViewController: popUpViewController)
        setPickerViewData()
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
                notificationTime.append(CustomTime(hour: components.hour!, minute: components.minute!, second: 0))
            }
        }
        
        return notificationTime
    }
    
    override func updateUI() {
        super.cancelButton?.removeFromSuperview()

    }
    
    func setPickerViewData() {
        
    }
    
}
