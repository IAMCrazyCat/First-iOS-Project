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
        for subview in superview.subviews {
            if subview.accessibilityIdentifier == "TempCalendarPageView" {
                subview.removeFromSuperview()
            }
           
        }
    }
    
    internal func updateCalendarPagesColor() {
        
    }
    
    internal func addNewCalendarPage() {
        
    }
    
    internal func updateTempCalendarPage() {
        
    }
    
    internal func updateCalendarPages() {
        
    }
    
}
