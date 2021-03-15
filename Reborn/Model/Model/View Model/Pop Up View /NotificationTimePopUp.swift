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
    
    init(presentAnimationType: PopUpAnimationType, popUpViewController: PopUpViewController) {
        super.init(presentAnimationType: presentAnimationType, popUpViewController: popUpViewController, type: .notificationTimePopUp)
        setPickerViewData()
    }
    
    override func createWindow() -> UIView {
        return NotificationTimePopUpViewBuilder(popUpViewController: super.popUpViewController, frame: super.frame, notificationTime: AppEngine.shared.userSetting.notificationTime).buildView()
    }
    
    override func getStoredData() -> Any? {
        var notificationTime: Array<CustomTime> = []
        for subview in super.contentView!.subviews {
            if let datePicker = subview as? UIDatePicker {
                let date = datePicker.date
                let components = Calendar.current.dateComponents([.hour, .minute], from: date)
                notificationTime.append(CustomTime(hour: components.hour!, minute: components.minute!))
            }
        }
      return notificationTime
    }
    
    func setPickerViewData() {
        
    }
    
}
