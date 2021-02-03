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
    var numberOfMovingPages = 1
        
       
    
    override func performStrategy() {
        
        if let numberOfMovingPages = self.viewController.calendarViewController?.storedMonthInterval {
            self.numberOfMovingPages = abs(numberOfMovingPages)
            
            if self.numberOfMovingPages > self.viewController.calendarPages.count {
                self.numberOfMovingPages = self.viewController.calendarPages.count
            }
            
        }
       
        if numberOfMovingPages > 0 {
            updateTempCalendarPage()
            updateCalendarPages()
            updateCalendarPagesColor()
        }
        
      
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
    
    override func updateTempCalendarPage() {
        if self.viewController.calendarViewController != nil {

            for index in 0 ... self.viewController.calendarPages.count - 1 {
                let builder = TimeMachineCalendarPageBuilder(interactableCalendarView: self.viewController.calendarPages.first!.subviews.first!, calendarViewController: self.viewController.calendarViewController!, monthDifference: -index)
                let tempCalendarPage = builder.buildCalendarPage()
                tempCalendarPage.accessibilityIdentifier = "TempCalendarPageView"
                
                self.removeOldTempCalendarPage(superview: self.viewController.calendarPages[index])
                self.viewController.calendarPages[index].addSubview(tempCalendarPage) // add temp calendar page to that will disapear
            }
               
    
           
        }
    }

    override func updateCalendarPages() {

        self.timesOfAnimationExcuted += 1
        self.addNewCalendarPage()
        self.updateCalendarPagesColor()
        
        UIView.animate(withDuration: self.viewController.animationSpeed, delay: 0, options: .curveLinear, animations: {
            
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
                    
                        if self.numberOfMovingPages <= self.viewController.calendarPages.count - 1 {
                            // numberOfMovingPages less than pages on screen, the interactableCalendarView should be added to that page
                            if index == self.numberOfMovingPages {
                        
                                if let interactableCalendarView = self.viewController.calendarPages.first?.subviews.first {
                                    backCalendarPage.insertSubview(interactableCalendarView, at: backCalendarPage.subviews.count)
                                }
                            }
                                
                        } else {
                            // numberOfMovingPages more than pages on screen, the interactableCalendarView should be added to LAST page
                            if index == self.viewController.calendarPages.count - 1 {
                                
                                if let interactableCalendarView = self.viewController.calendarPages.first?.subviews.first {
                                    backCalendarPage.insertSubview(interactableCalendarView, at: backCalendarPage.subviews.count)
                                }
                            }
                       
                            
                        }
                        
                        backCalendarPage.transform = CGAffineTransform(scaleX: CGFloat(backCalendarPage.transform.currentScale) / scale , y: CGFloat(backCalendarPage.transform.currentScale) / scale)
                        backCalendarPage.frame.origin.y += self.setting.newCalendarPageCordiateYDifference
                }
            }
        }) { _ in
            
            // remove the first calendar page
            self.viewController.calendarPages.first?.removeFromSuperview()
            self.viewController.calendarPages.remove(at: 0)

       
            if self.timesOfAnimationExcuted < self.numberOfMovingPages {
                    self.updateCalendarPages()
            }
  
        }
    }
    
    
    
}
