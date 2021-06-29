//
//  ItemNotificationTimePopUp.swift
//  Reborn
//
//  Created by Christian Liu on 29/6/21.
//

import Foundation
import UIKit

class ItemNotificationTimePopUp: NotificationTimePopUp {
    private let item: Item
    private let defaultItemNotificationTimes: Array<CustomTime> = [CustomTime(hour: 9, minute: 0, second: 0, oneTenthSecond: 0)]
    
    init(presentAnimationType: PopUpAnimationType, size: PopUpSize = .large, popUpViewController: PopUpViewController, item: Item) {
        self.item = item
        super.init(presentAnimationType: presentAnimationType, size: size, popUpViewController: popUpViewController)
        super.type = .itemNotificationTimePopUp
    }
    
    override func createWindow() -> UIView {
        if item.notificationTimes.count > 0 {
            return NotificationTimePopUpViewBuilder(popUpViewController: super.popUpViewController, frame: super.frame, notificationTime: item.notificationTimes, notificationTimePopUp: self).buildView()
        } else {
            return NotificationTimePopUpViewBuilder(popUpViewController: super.popUpViewController, frame: super.frame, notificationTime: self.defaultItemNotificationTimes, notificationTimePopUp: self).buildView()
        }
       
    }
    
    override func getStoredData() -> Any? {
        var notificationTime: Array<CustomTime> = []
        if let date = super.firstDatePicker?.date {
            let components = Calendar.current.dateComponents([.hour, .minute], from: date)
            notificationTime.append(CustomTime(hour: components.hour!, minute: components.minute!, second: 0, oneTenthSecond: 0))
        }
        return notificationTime
    }
    
    override func setUpUI() {
        super.segmentedControl?.selectedSegmentIndex = 1
        super.segmentedControl?.isHidden = true
        super.secondDatePicker?.isHidden = true
        super.titleLabel?.text = "习惯提醒时间"
        super.explanationLabel?.text = "此提醒属于任务提醒，您可以设置一个时间来提醒您完成这个项目，休息日中您将不会收到提醒"
    }
}
