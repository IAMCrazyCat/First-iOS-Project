//
//  MonthStrategy.swift
//  Reborn
//
//  Created by Christian Liu on 31/1/21.
//

import Foundation
import UIKit
class TimeMachineAnimationStrategyImpl: TimeMachineAnimationStrategy {

    let timeMachineViewController: TimeMachineViewController
    let setting: SystemSetting = SystemSetting.shared
    
    init(timeMachineViewController: TimeMachineViewController) {
        self.timeMachineViewController = timeMachineViewController 
    }
    
    public func performStrategy() {
        addNewCalendarPage()
        updateTempCalendarPage()
        updateCalendarPages()
        updateCalendarPagesColor()
    }
    
    internal func removeOldTempCalendarPage(superview: UIView) {
        superview.removeSubviewBy(idenifier: "TempCalendarPageView")
    
    }
    
    internal func updateCalendarPagesColor() {

//        if var lastCalendarPageColorValue = self.timeMachineViewController.calendarPages.first?.subviews.first?.backgroundColor?.value, AppEngine.shared.userSetting.uiUserInterfaceStyle != .dark
//        {
//
//            for calendarPage in self.timeMachineViewController.calendarPages {
//                calendarPage.subviews.first?.backgroundColor = UIColor(red: lastCalendarPageColorValue.red - self.setting.calendarPageColorDifference, green: lastCalendarPageColorValue.green - self.setting.calendarPageColorDifference, blue: lastCalendarPageColorValue.blue - self.setting.calendarPageColorDifference, alpha: 1)
//
//                lastCalendarPageColorValue = (calendarPage.subviews.first?.backgroundColor?.value)!
//
//            }
//        }
       

    }
    
    internal func addNewCalendarPage() {
        
    }
    
    internal func updateTempCalendarPage() {
        
    }
    
    internal func updateCalendarPages() {
        
    }
    
}
