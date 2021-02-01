//
//  NoWhereStrategy.swift
//  Reborn
//
//  Created by Christian Liu on 31/1/21.
//

import Foundation
import UIKit
class StillStrategy: PagesBehaviorStrategy {
    
    
    override func excuteCalendarPagesAnimation() {
        updateCalendarPagesColor()
        updateTempCalendarPage()
    }
    
    override func updateCalendarPagesColor() {
        var r: CGFloat = 1
        var g: CGFloat = 1
        var b: CGFloat = 1
        

        for index in 0 ... self.viewController.calendarPages.count - 1 {
            
            let calendarPage = self.viewController.calendarPages[index]
            calendarPage.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1)
            
            r -= self.setting.calendarPageColorDifference
            g -= self.setting.calendarPageColorDifference
            b -= self.setting.calendarPageColorDifference
           
        }
    }
    
    override func addNewCalendarPage() {

    }
    
    override func updateTempCalendarPage() {
        
        if self.viewController.calendarViewController != nil {

            for index in 1 ... 3 {
                let builder = TimeMachineCalendarPageBuilder(interactableCalendarView: self.viewController.calendarPages.first!.subviews.first!, calendarViewController: self.viewController.calendarViewController!, monthDifference: -index)
                let tempCalendarPage = builder.buildCalendarPage()
                tempCalendarPage.accessibilityIdentifier = "TempCalendarPageView"
                
                self.removeOldTempCalendarPage(superview: self.viewController.calendarPages[index])
                self.viewController.calendarPages[index].addSubview(tempCalendarPage) // add temp calendar page to that will disapear
            }
           
        }
        
    }
    
    override func updateCalendarPages() {
        
    }
    
   
    
    
}
