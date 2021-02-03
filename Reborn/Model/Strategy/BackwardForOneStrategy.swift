//
//  NextMonthStrategy.swift
//  Reborn
//
//  Created by Christian Liu on 31/1/21.
//

import Foundation
import UIKit
class BackwardForOneStrategy: PagesBehaviorStrategy {
    
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
        let newCalendarPage = UIView()
        let scale = 1 / self.setting.newCalendarPageSizeDifference // new page is one unit larger than first page
        newCalendarPage.backgroundColor = self.setting.calendarPageColor
        newCalendarPage.frame = self.viewController.calendarPages.first?.frame ?? .zero
        newCalendarPage.frame.origin.y =  self.viewController.calendarPages.first?.frame.origin.y ?? 0 + self.setting.newCalendarPageCordiateYDifference
        newCalendarPage.transform =  CGAffineTransform(scaleX: scale, y: scale) // scale it accroding to first page to its proper size
        
        newCalendarPage.alpha = 0
        newCalendarPage.layer.cornerRadius = self.setting.itemCardCornerRadius
        newCalendarPage.setViewShadow()
        
        self.viewController.view.insertSubview(newCalendarPage, aboveSubview: self.viewController.calendarPages.first ?? UIView())
        self.viewController.calendarPages.insert(newCalendarPage, at: 0)
    }
    
    override func updateTempCalendarPage() {
        
        
        if let calendarView = self.viewController.calendarPages.first?.subviews.first,
        let calendarViewController = self.viewController.calendarViewController {
            
            
            let builder = TimeMachineCalendarPageBuilder(interactableCalendarView: calendarView, calendarViewController: calendarViewController, monthDifference: 0)
            let tempCalendarPage = builder.buildCalendarPage()
            tempCalendarPage.accessibilityIdentifier = "TempCalendarPageView"
            self.removeOldTempCalendarPage(superview: self.viewController.calendarPages[1])
            self.viewController.calendarPages[1].addSubview(tempCalendarPage) // add temp calendar page to that will disapear
            print(self.viewController.calendarPages[1].subviews)
            
            
            for index in 0 ... self.viewController.calendarPages.count - 1 {
                
                let builder = TimeMachineCalendarPageBuilder(interactableCalendarView: self.viewController.calendarPages[1].subviews.first!, calendarViewController: self.viewController.calendarViewController!, monthDifference: -index)
                let tempCalendarPage = builder.buildCalendarPage()
                tempCalendarPage.accessibilityIdentifier = "TempCalendarPageView"
                self.removeOldTempCalendarPage(superview: self.viewController.calendarPages[index])
                self.viewController.calendarPages[index].addSubview(tempCalendarPage) // add temp calendar page to that will disapear
                print(self.viewController.calendarPages[index].subviews)
            }
        }
    }
    
    override func updateCalendarPages() {

        UIView.animate(withDuration: self.viewController.animationSpeed, delay: 0, options: .curveLinear, animations: {
            
               for index in 0 ... self.viewController.calendarPages.count - 1 {
                
                let backCalendarPage = self.viewController.calendarPages[index]
                let scale: CGFloat = self.setting.newCalendarPageSizeDifference
                backCalendarPage.alpha = 1
                
                if index == 0 {
                    
                    
                    if let interactableCalendarView = self.viewController.calendarPages.second?.subviews.first
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
                    
                    if index == self.viewController.calendarPages.count - 1 {

                        backCalendarPage.alpha = 0 // last calendar page disappear

                    }
                   
                }
            }
        }) { _ in

            self.viewController.calendarPages.last!.removeFromSuperview()
            self.viewController.calendarPages.remove(at: self.viewController.calendarPages.count - 1)

           
        }
    
    }
    
    
}
