//
//  NextMonthStrategy.swift
//  Reborn
//
//  Created by Christian Liu on 31/1/21.
//

import Foundation
import UIKit
class BackwardForOneStrategy: TimeMachineAnimationStrategyImpl {

    
    override func addNewCalendarPage() {
        let newCalendarPage = UIView()
        let scale = 1 / self.setting.newCalendarPageSizeDifference // new page is one unit larger than first page
        newCalendarPage.backgroundColor = AppEngine.shared.userSetting.whiteAndBlackBackground
        newCalendarPage.frame = self.timeMachineViewController.calendarPages.first!.frame
        newCalendarPage.frame.origin.y =  self.timeMachineViewController.calendarPages.first!.frame.origin.y + self.setting.newCalendarPageCordiateYDifference
        newCalendarPage.transform =  CGAffineTransform(scaleX: scale, y: scale) // scale it accroding to first page to its proper size
        
        newCalendarPage.alpha = 0
        newCalendarPage.layer.cornerRadius = self.setting.itemCardCornerRadius
        newCalendarPage.setShadow(style: .view)
        
        self.timeMachineViewController.middleView.insertSubview(newCalendarPage, aboveSubview: self.timeMachineViewController.calendarPages.first!)
        self.timeMachineViewController.calendarPages.insert(newCalendarPage, at: 0)
    }
    
    override func updateTempCalendarPage() {
        
        
        if self.timeMachineViewController.calendarViewController != nil {
            
            
            let builder = TimeMachineCalendarPageViewBuilder(interactableCalendarView: self.timeMachineViewController.calendarPages[1].subviews.first!, referenceCalendarPage: self.timeMachineViewController.calendarViewController.currentCalendarPage, monthDifference: 0)
            let tempCalendarPage = builder.buildView()

            super.removeOldTempCalendarPage(superview: self.timeMachineViewController.calendarPages[1])
            self.timeMachineViewController.calendarPages[1].addSubview(tempCalendarPage) // add temp calendar page to that will disapear
            print(self.timeMachineViewController.calendarPages[1].subviews)
            
            
            for index in 0 ... self.timeMachineViewController.calendarPages.count - 1 {
                
                let builder = TimeMachineCalendarPageViewBuilder(interactableCalendarView: self.timeMachineViewController.calendarPages[1].subviews.first!, referenceCalendarPage: self.timeMachineViewController.calendarViewController.currentCalendarPage, monthDifference: -index + 1)
                let tempCalendarPage = builder.buildView()

                super.removeOldTempCalendarPage(superview: self.timeMachineViewController.calendarPages[index])
                self.timeMachineViewController.calendarPages[index].addSubview(tempCalendarPage) // add temp calendar page to that will disapear
                print(self.timeMachineViewController.calendarPages[index].subviews)
            }
        }
    }
    
    override func updateCalendarPages() {

        UIView.animate(withDuration: self.timeMachineViewController.animationSpeed, delay: 0, options: .curveLinear, animations: {
            
               for index in 0 ... self.timeMachineViewController.calendarPages.count - 1 {
                
                let backCalendarPage = self.timeMachineViewController.calendarPages[index]
                let scale: CGFloat = self.setting.newCalendarPageSizeDifference
                backCalendarPage.alpha = 1
                
                if index == 0 {
                    
                    
                    if let interactableCalendarView = self.timeMachineViewController.calendarPages[1].subviews.first
                    {
                        backCalendarPage.insertSubview(interactableCalendarView, at: backCalendarPage.subviews.count)
                        backCalendarPage.transform = CGAffineTransform(scaleX: CGFloat(backCalendarPage.transform.currentScale) * scale , y:   CGFloat(backCalendarPage.transform.currentScale) * scale)
                        backCalendarPage.frame.origin.y -= self.setting.newCalendarPageCordiateYDifference
                    }
                    
  
                } else {
                    
                    if index == 1 {
 
                    }
                          
                        backCalendarPage.transform = CGAffineTransform(scaleX: CGFloat(backCalendarPage.transform.currentScale) * scale , y:   CGFloat(backCalendarPage.transform.currentScale) * scale)
                        backCalendarPage.frame.origin.y -= self.setting.newCalendarPageCordiateYDifference
                    
                    if index == self.timeMachineViewController.calendarPages.count - 1 {

                        backCalendarPage.alpha = 0 // last calendar page disappear

                    }
                   
                }
            }
        }) { _ in

            self.timeMachineViewController.calendarPages.last?.removeFromSuperview()
            self.timeMachineViewController.calendarPages.remove(at: self.timeMachineViewController.calendarPages.count - 1)

           
        }
    
    }
    
    
}
