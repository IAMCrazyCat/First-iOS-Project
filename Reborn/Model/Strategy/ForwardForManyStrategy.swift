//
//  ThisMonthStrategy.swift
//  Reborn
//
//  Created by Christian Liu on 31/1/21.
//

import Foundation
import UIKit
class ForwardForManyStrategy: PagesBehaviorStrategy {
    var timesOfAnimationExcuted: Int = 0
    
    override func updateCalendarPages() {
        addTempCalendarPage()
        updateOtherCalendarPages()
        updateCalendarPagesColor()
    }
    
    override func updateCalendarPagesColor() {
        var r: CGFloat = 1
        var g: CGFloat = 1
        var b: CGFloat = 1

        for index in 1 ... self.viewController.calendarPages.count - 1 {
            
            let calendarPage = self.viewController.calendarPages[index]
            calendarPage.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1)
            
            r -= self.setting.calendarPageColorDifference
            g -= self.setting.calendarPageColorDifference
            b -= self.setting.calendarPageColorDifference
           
        }

    }
    
    override func addNewCalendarPage() {
      
        let newCalendarPage = UIView()
        let scale = CGFloat(pow(Double(self.setting.newCalendarPageSizeDifference), Double(self.viewController.calendarPages.count)))

        
        newCalendarPage.frame = viewController.calendarPages.first!.frame // new calendar page frame equals to the first page
        newCalendarPage.frame.origin.y =  viewController.calendarPages.first!.frame.origin.y - self.setting.newCalendarPageCordiateYDifference * CGFloat(self.viewController.calendarPages.count) // move up the new calendar page to its proper position Y
        newCalendarPage.transform =  CGAffineTransform(scaleX: scale, y: scale) // scale it accroding to first page to its proper size
        
        // set style
        newCalendarPage.backgroundColor = self.setting.calendarPageColor
        newCalendarPage.alpha = 0
        newCalendarPage.layer.cornerRadius = self.setting.itemCardCornerRadius
        newCalendarPage.setViewShadow()

        self.viewController.view.insertSubview(newCalendarPage, belowSubview: self.viewController.calendarPages.last!)
        self.viewController.calendarPages.append(newCalendarPage)
    }
    
    override func addTempCalendarPage() {
//        if self.viewController.calendarViewController != nil {
//
//
//            if self.viewController.userDidGo == .lastMonth {
//
//                let builder = TimeMachineCalendarPageBuilder(interactableCalendarView: self.viewController.calendarPages.first!.subviews.first!, calendarViewController: self.viewController.calendarViewController!, userDidGo: self.viewController.userDidGo)
//                let tempCalendarPage = builder.buildCalendarPage()
//                tempCalendarPage.accessibilityIdentifier = "TempCalendarPageView"
//
//                self.removeOldTempCalendarPage(superview: self.viewController.calendarPages.first!)
//                self.viewController.calendarPages.first!.addSubview(tempCalendarPage) // add temp calendar page to that will disapear
//
//            } else if self.viewController.userDidGo == .nextMonth {
//
//                let builder = TimeMachineCalendarPageBuilder(interactableCalendarView: self.viewController.calendarPages[1].subviews.first!, calendarViewController: self.viewController.calendarViewController!, userDidGo: self.viewController.userDidGo)
//                let tempCalendarPage = builder.buildCalendarPage()
//                tempCalendarPage.accessibilityIdentifier = "TempCalendarPageView"
//                self.removeOldTempCalendarPage(superview: self.viewController.calendarPages[1])
//                self.viewController.calendarPages[1].addSubview(tempCalendarPage) // add temp calendar page to that will disapear
//            }
//
//
//        }
    }

    func reupdatePages() {
        self.timesOfAnimationExcuted += 1
        self.addNewCalendarPage()
        self.updateCalendarPagesColor()
        
        UIView.animate(withDuration: self.viewController.animationSpeed - 0.2, delay: 0, options: .curveLinear, animations: {
            
               for index in 0 ... self.viewController.calendarPages.count - 1 {
                
                let backCalendarPage = self.viewController.calendarPages[index]
                let scale: CGFloat = self.setting.newCalendarPageSizeDifference
                backCalendarPage.alpha = 1
                
                if index == 0 {
                
                    // first calendar page disapear
                    backCalendarPage.transform = CGAffineTransform(scaleX: 1 / scale, y: 1 / scale)
                    backCalendarPage.frame.origin.y += self.setting.newCalendarPageCordiateYDifference
                    backCalendarPage.alpha = 0
    
                   
                } else {
                    
                    if index == self.viewController.calendarPages.count - 1 {
                    
                        // send interacable calendar view to second calendar page

                        if let interactableCalendarView = self.viewController.calendarPages.first?.subviews.first {
                            backCalendarPage.insertSubview(interactableCalendarView, at: backCalendarPage.subviews.count)
                        }
                        
                      

                    }
                        
                        backCalendarPage.transform = CGAffineTransform(scaleX: CGFloat(backCalendarPage.transform.currentScale) / scale , y: CGFloat(backCalendarPage.transform.currentScale) / scale)
                        backCalendarPage.frame.origin.y += self.setting.newCalendarPageCordiateYDifference

                    
                    if index == self.viewController.calendarPages.count - 1 {
                        
                        
                    }
                   
                }
            }
        }) { _ in
            
            // remove the first calendar page
            self.viewController.calendarPages.first!.removeFromSuperview()
            self.viewController.calendarPages.remove(at: 0)
            self.viewController.animationThredIsFinished = true
            
            
            
            if self.timesOfAnimationExcuted < 4 {
                self.reupdatePages()
               
               
            }
            
        }

    }
    
    override func updateOtherCalendarPages() {
        self.viewController.animationThredIsFinished = false
        self.reupdatePages()
    }
    
    
    
}
