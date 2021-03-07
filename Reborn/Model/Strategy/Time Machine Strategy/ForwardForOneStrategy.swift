//
//  LastMonthStrategy.swift
//  Reborn
//
//  Created by Christian Liu on 31/1/21.
//

import Foundation
import UIKit

class ForwardForOneStrategy: TimeMachineAnimationStrategyImpl {
    
    override func updateCalendarPagesColor() {
        var r: CGFloat = 1
        var g: CGFloat = 1
        var b: CGFloat = 1

        for index in 1 ... self.timeMachineViewController.calendarPages.count - 1 {
            
            let calendarPage = self.timeMachineViewController.calendarPages[index]
            calendarPage.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1)
            
            r -= self.setting.calendarPageColorDifference
            g -= self.setting.calendarPageColorDifference
            b -= self.setting.calendarPageColorDifference
           
        }

    }
    
    override func addNewCalendarPage() {
        let newCalendarPage = UIView()
        let scale = CGFloat(pow(Double(self.setting.newCalendarPageSizeDifference), Double(self.timeMachineViewController.calendarPages.count)))

        
        newCalendarPage.frame = timeMachineViewController.calendarPages.first!.frame // new calendar page frame equals to the first page
        newCalendarPage.frame.origin.y =  timeMachineViewController.calendarPages.first!.frame.origin.y - self.setting.newCalendarPageCordiateYDifference * CGFloat(self.timeMachineViewController.calendarPages.count) // move up the new calendar page to its proper position Y
        newCalendarPage.transform =  CGAffineTransform(scaleX: scale, y: scale) // scale it accroding to first page to its proper size
        
        // set style
        newCalendarPage.backgroundColor = self.setting.calendarPageColor
        newCalendarPage.alpha = 0
        newCalendarPage.layer.cornerRadius = self.setting.itemCardCornerRadius
        newCalendarPage.setShadow()

        self.timeMachineViewController.middleView.insertSubview(newCalendarPage, belowSubview: self.timeMachineViewController.calendarPages.last!)
        self.timeMachineViewController.calendarPages.append(newCalendarPage)
    }
    
    override func updateTempCalendarPage() {
        
        if self.timeMachineViewController.calendarViewController != nil {

            for index in 0 ... self.timeMachineViewController.calendarPages.count - 1 {
                let builder = TimeMachineCalendarPageViewBuilder(interactableCalendarView: self.timeMachineViewController.calendarPages.first!.subviews.first!, calendarViewController: self.timeMachineViewController.calendarViewController!, monthDifference: -index + 1)
                let tempCalendarPage = builder.buildCalendarPage()
                tempCalendarPage.accessibilityIdentifier = "TempCalendarPageView"
                super.removeOldTempCalendarPage(superview: self.timeMachineViewController.calendarPages[index])
                self.timeMachineViewController.calendarPages[index].addSubview(tempCalendarPage) // add temp calendar page to that will disapear
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
                
                    // first calendar page disapear
                    backCalendarPage.transform = CGAffineTransform(scaleX: 1 / scale, y: 1 / scale)
                    backCalendarPage.frame.origin.y += self.setting.newCalendarPageCordiateYDifference
                    backCalendarPage.alpha = 0
    
                   
                } else {
                    
                    if index == 1 {
                    
                        // send interacable calendar view to second calendar page
                        if let interactableCalendarView = self.timeMachineViewController.calendarPages.first?.subviews.first {
                            backCalendarPage.insertSubview(interactableCalendarView, at: backCalendarPage.subviews.count)
                        }

                    }
                        
                        backCalendarPage.transform = CGAffineTransform(scaleX: CGFloat(backCalendarPage.transform.currentScale) / scale , y: CGFloat(backCalendarPage.transform.currentScale) / scale)
                        backCalendarPage.frame.origin.y += self.setting.newCalendarPageCordiateYDifference

                    
                    if index == self.timeMachineViewController.calendarPages.count - 1 {
                        
                        
                    }
                   
                }
            }
        }) { _ in
            
            // remove the first calendar page
            self.timeMachineViewController.calendarPages.first?.removeFromSuperview()
            self.timeMachineViewController.calendarPages.remove(at: 0)

        }
    }
    
    
}


