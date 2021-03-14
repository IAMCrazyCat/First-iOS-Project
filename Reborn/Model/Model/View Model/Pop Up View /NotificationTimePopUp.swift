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
        return super.contentView?.getSubviewBy(idenifier: "FirstDatePicker") as! UIDatePicker
        
    }
    
    public var pikerViewData: Array<Any> = []
    
    init(presentAnimationType: PopUpAnimationType, popUpViewController: PopUpViewController) {
        super.init(presentAnimationType: presentAnimationType, popUpViewController: popUpViewController, type: .notificationTimePopUp)
        setPickerViewData()
    }
    
    override func createWindow() -> UIView {
        return NotificationTimePopUpViewBuilder(popUpViewController: super.popUpViewController, frame: super.frame).buildView()
    }
    
    override func getStoredData() -> Any? {
        let date = self.firstDatePicker.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        return CustomTime(hour: components.hour!, minute: components.minute!)
    }
    
    func setPickerViewData() {
        firstDatePicker.datePickerMode = .time
    }
    
}
