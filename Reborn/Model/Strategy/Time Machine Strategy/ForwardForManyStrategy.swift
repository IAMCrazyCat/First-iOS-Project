//
//  ThisMonthStrategy.swift
//  Reborn
//
//  Created by Christian Liu on 31/1/21.
//

import Foundation
import UIKit
class ForwardForManyStrategy: TimeMachineAnimationStrategyImpl {
    var timesOfAnimationExcuted: Int = 0
    var numberOfMovingPages: Int = 1
        
    init(timeMachineViewController: TimeMachineViewController, numberOfMovingPages: Int) {
        super.init(timeMachineViewController: timeMachineViewController)
        self.numberOfMovingPages = numberOfMovingPages
    }
    
    override func performStrategy() {
        
        if self.numberOfMovingPages > self.timeMachineViewController.calendarPages.count {
            self.numberOfMovingPages = self.timeMachineViewController.calendarPages.count
        }
    
        if numberOfMovingPages > 0 {
            updateTempCalendarPage()
            updateCalendarPages()
            updateCalendarPagesColor()
        }
        
      
    }
    
    
    override func addNewCalendarPage() {
      
        let newCalendarPage = UIView()
        let scale = CGFloat(pow(Double(self.setting.newCalendarPageSizeDifference), Double(self.timeMachineViewController.calendarPages.count)))
        newCalendarPage.frame = self.timeMachineViewController.calendarPages.first!.frame // new calendar page frame equals to the first page
        newCalendarPage.frame.origin.y =  timeMachineViewController.calendarPages.first!.frame.origin.y - self.setting.newCalendarPageCordiateYDifference * CGFloat(self.timeMachineViewController.calendarPages.count) // move up the new calendar page to its proper position Y
        newCalendarPage.transform =  CGAffineTransform(scaleX: scale, y: scale) // scale it accroding to first page to its proper size
        
        // set style
        newCalendarPage.backgroundColor = AppEngine.shared.userSetting.whiteAndBlackBackground
        newCalendarPage.alpha = 0
        newCalendarPage.layer.cornerRadius = self.setting.itemCardCornerRadius
        newCalendarPage.setShadow(style: .view)

        self.timeMachineViewController.middleView.insertSubview(newCalendarPage, belowSubview: self.timeMachineViewController.calendarPages.last!)
        self.timeMachineViewController.calendarPages.append(newCalendarPage)
    }
    
    override func updateTempCalendarPage() {
        if self.timeMachineViewController.calendarViewController != nil {

            for index in 0 ... self.timeMachineViewController.calendarPages.count - 1 {
                
                let builder = TimeMachineCalendarPageViewBuilder(interactableCalendarView: self.timeMachineViewController.calendarPages.first!.subviews.first!, referenceCalendarPage: self.timeMachineViewController.calendarViewController.currentCalendarPage, monthDifference: -index)
                let tempCalendarPage = builder.buildView()

                
                super.removeOldTempCalendarPage(superview: self.timeMachineViewController.calendarPages[index])
                self.timeMachineViewController.calendarPages[index].addSubview(tempCalendarPage) // add temp calendar page to that will disapear
            }
               
    
           
        }
    }

    override func updateCalendarPages() {

        self.timesOfAnimationExcuted += 1
        self.addNewCalendarPage()
        self.updateCalendarPagesColor()
        
        UIView.animate(withDuration: self.timeMachineViewController.animationSpeed, delay: 0, options: .curveLinear, animations: {
            
               for index in 0 ... self.timeMachineViewController.calendarPages.count - 1 {
                
                let backCalendarPage = self.timeMachineViewController.calendarPages[index]
                let scale: CGFloat = self.setting.newCalendarPageSizeDifference
                backCalendarPage.alpha = 1
                
                if index == 0 {
                
                    // first calendar page disapear
                    backCalendarPage.transform = CGAffineTransform(scaleX: 1 / scale, y: 1 / scale)
                    backCalendarPage.frame.origin.y += self.setting.newCalendarPageCordiateYDifference
                    backCalendarPage.alpha = 0
    
                   
                } else {
                    
                        if self.numberOfMovingPages <= self.timeMachineViewController.calendarPages.count - 1 {
                            // numberOfMovingPages less than pages on screen, the interactableCalendarView should be added to that page
                            if index == self.numberOfMovingPages {
                        
                                if let interactableCalendarView = self.timeMachineViewController.calendarPages.first?.subviews.first {
                                    backCalendarPage.insertSubview(interactableCalendarView, at: backCalendarPage.subviews.count)
                                }
                            }
                                
                        } else {
                            // numberOfMovingPages more than pages on screen, the interactableCalendarView should be added to LAST page
                            if index == self.timeMachineViewController.calendarPages.count - 1 {
                                
                                if let interactableCalendarView = self.timeMachineViewController.calendarPages.first?.subviews.first {
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
            self.timeMachineViewController.calendarPages.first?.removeFromSuperview()
            self.timeMachineViewController.calendarPages.remove(at: 0)

       
            if self.timesOfAnimationExcuted < self.numberOfMovingPages {
                    self.updateCalendarPages()
            }
  
        }
    }
    
    
    
}
