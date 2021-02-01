//
//  MonthStrategy.swift
//  Reborn
//
//  Created by Christian Liu on 31/1/21.
//

import Foundation
import UIKit
class PagesBehaviorStrategy: TimeMachineAnimationStrategy {

    let viewController: TimeMachineViewController
    let setting: SystemStyleSetting = SystemStyleSetting.shared
    
    init(viewController: TimeMachineViewController) {
        self.viewController = viewController
    }
    
    public func excuteCalendarPagesAnimation() {
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
