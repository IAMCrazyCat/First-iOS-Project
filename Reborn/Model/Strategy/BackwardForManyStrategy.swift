//
//  StartMonthStrategy.swift
//  Reborn
//
//  Created by Christian Liu on 31/1/21.
//

import Foundation
import UIKit
class BackwardForManyStrategy: PagesBehaviorStrategy {
    
    override func updateCalendarPagesColor() {
        
    }
    
    override func addNewCalendarPage() {
        
    }
    
    override func addTempCalendarPage() {
        if self.viewController.calendarViewController != nil {
           
            
            if self.viewController.userDidGo == .lastMonth {
                
                let builder = TimeMachineCalendarPageBuilder(interactableCalendarView: self.viewController.calendarPages.first!.subviews.first!, calendarViewController: self.viewController.calendarViewController!, monthDifference: 1)
                let tempCalendarPage = builder.buildCalendarPage()
                tempCalendarPage.accessibilityIdentifier = "TempCalendarPageView"
                
                self.removeOldTempCalendarPage(superview: self.viewController.calendarPages.first!)
                self.viewController.calendarPages.first!.addSubview(tempCalendarPage) // add temp calendar page to that will disapear
                
            } else if self.viewController.userDidGo == .nextMonth {
                
                let builder = TimeMachineCalendarPageBuilder(interactableCalendarView: self.viewController.calendarPages[1].subviews.first!, calendarViewController: self.viewController.calendarViewController!, monthDifference: 1)
                let tempCalendarPage = builder.buildCalendarPage()
                tempCalendarPage.accessibilityIdentifier = "TempCalendarPageView"
                self.removeOldTempCalendarPage(superview: self.viewController.calendarPages[1])
                self.viewController.calendarPages[1].addSubview(tempCalendarPage) // add temp calendar page to that will disapear
            }
            
           
        }
    }
    
    override func updateOtherCalendarPages() {
        self.viewController.animationThredIsFinished = false

        UIView.animate(withDuration: self.viewController.animationSpeed, delay: 0, options: .curveLinear, animations: {
            
               for index in 0 ... self.viewController.calendarPages.count - 1 {
                
                let backCalendarPage = self.viewController.calendarPages[index]
                let scale: CGFloat = self.setting.newCalendarPageSizeDifference
                backCalendarPage.alpha = 1
                
                if index == 0 {
                    
                    if self.viewController.userDidGo == .lastMonth {
                        // first calendar page disapear
                        backCalendarPage.transform = CGAffineTransform(scaleX: 1 / scale, y: 1 / scale)
                        backCalendarPage.frame.origin.y += self.setting.newCalendarPageCordiateYDifference
                        backCalendarPage.alpha = 0
                        
                    } else if self.viewController.userDidGo == .nextMonth {
                       
                        let interactableCalendarView = self.viewController.calendarPages[1].subviews.first!
                        backCalendarPage.insertSubview(interactableCalendarView, at: backCalendarPage.subviews.count)
            
                        backCalendarPage.transform = CGAffineTransform(scaleX: CGFloat(backCalendarPage.transform.currentScale) * scale , y:   CGFloat(backCalendarPage.transform.currentScale) * scale)
                        backCalendarPage.frame.origin.y -= self.setting.newCalendarPageCordiateYDifference
                        
                        
                    }
                   
                } else {
                    
                    if index == 1 {
                        
                        if self.viewController.userDidGo == .lastMonth {
                            // send interacable calendar view to second calendar page
                            let interactableCalendarView = self.viewController.calendarPages.first!.subviews.first!
                            //backCalendarPage.addSubview(interactableCalendarView)
                       
                            backCalendarPage.insertSubview(interactableCalendarView, at: backCalendarPage.subviews.count)
                        } else if self.viewController.userDidGo == .nextMonth {

                           
                        }
                        
                        
                    }
                        
                        if self.viewController.userDidGo == .lastMonth {
                            

            
                            backCalendarPage.transform = CGAffineTransform(scaleX: CGFloat(backCalendarPage.transform.currentScale) / scale , y: CGFloat(backCalendarPage.transform.currentScale) / scale)
                            backCalendarPage.frame.origin.y += self.setting.newCalendarPageCordiateYDifference
                            
                        } else if self.viewController.userDidGo == .nextMonth {
                        
                            backCalendarPage.transform = CGAffineTransform(scaleX: CGFloat(backCalendarPage.transform.currentScale) * scale , y:   CGFloat(backCalendarPage.transform.currentScale) * scale)
                            backCalendarPage.frame.origin.y -= self.setting.newCalendarPageCordiateYDifference
                        }
                    
                    
                    
                    if index == self.viewController.calendarPages.count - 1 {
                        
                        if self.viewController.userDidGo == .nextMonth {
                            backCalendarPage.alpha = 0 // last calendar page disappear
                        }
                    }
                   
                }
            }
        }) { _ in
            
            if self.viewController.userDidGo == .lastMonth {
                // remove the first calendar page
                self.viewController.calendarPages.first?.removeFromSuperview()
                self.viewController.calendarPages.remove(at: 0)
                
            } else if self.viewController.userDidGo == .nextMonth {
                //self.backCalendarPages[1].subviews.first!.removeFromSuperview()
                self.viewController.calendarPages.last?.removeFromSuperview()
                self.viewController.calendarPages.remove(at: self.viewController.calendarPages.count - 1)
            }
            
            self.viewController.animationThredIsFinished = true
           
        }
    
    }
    
}
