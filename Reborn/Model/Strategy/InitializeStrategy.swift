//
//  NoWhereStrategy.swift
//  Reborn
//
//  Created by Christian Liu on 31/1/21.
//

import Foundation
import UIKit
class InitializeStrategy: PagesBehaviorStrategy {
    
    
    override func performStrategy() {
        moveDownCalendarView()
       
        
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
    
    override func updateTempCalendarPage() {
        
        if let calendarView = self.viewController.calendarPages.first?.subviews.first,
        let calendarViewController = self.viewController.calendarViewController {

            for index in 1 ... 3 {
                let builder = TimeMachineCalendarPageBuilder(interactableCalendarView: calendarView, calendarViewController: calendarViewController, monthDifference: -index)
                let tempCalendarPage = builder.buildCalendarPage()
                tempCalendarPage.accessibilityIdentifier = "TempCalendarPageView"
                
                self.removeOldTempCalendarPage(superview: self.viewController.calendarPages[index])
                self.viewController.calendarPages[index].addSubview(tempCalendarPage) // add temp calendar page to that will disapear
            }
           
        }
        
    }
    
    func moveDownCalendarView() {
        if let calendarView = self.viewController.calendarView{
            
            let newCalendarPage = UIView()
            newCalendarPage.backgroundColor = self.setting.calendarPageColor
            newCalendarPage.frame = self.viewController.calendarView!.frame
            newCalendarPage.layer.cornerRadius = self.setting.itemCardCornerRadius
            newCalendarPage.setViewShadow()
            newCalendarPage.addSubview(calendarView)
            
            self.viewController.calendarView?.frame.origin = .zero
            self.viewController.view.addSubview(newCalendarPage)
            self.viewController.calendarPages.append(newCalendarPage)
   
            UIView.animate(withDuration: self.viewController.animationSpeed, delay: 0, options: .curveEaseOut, animations: {

                self.viewController.calendarPages.first?.frame.origin.y = self.setting.screenFrame.height / 2 -  calendarView.frame.height / 2
            }) { _ in

                self.addOtherCalendarPagesAndMoveThemUp()
                self.updateTempCalendarPage()
                self.updateCalendarPagesColor()
              
            }
        }
    }
    
    func addOtherCalendarPagesAndMoveThemUp() {
        var scale: CGFloat = 1
        var cordinateYDifference = self.setting.newCalendarPageCordiateYDifference
        
        for index in 0 ... self.setting.numberOfCalendarPages - 2 {

            scale *= self.setting.newCalendarPageSizeDifference
            let newCalendarPage = UIView()
            newCalendarPage.backgroundColor = self.setting.calendarPageColor
            newCalendarPage.frame = self.viewController.calendarPages[0].frame
            newCalendarPage.transform = CGAffineTransform(scaleX: scale, y: scale)
            newCalendarPage.layer.cornerRadius = self.setting.itemCardCornerRadius
            newCalendarPage.setViewShadow()
            
            
            self.viewController.view.insertSubview(newCalendarPage, belowSubview: self.viewController.calendarPages[index])
            
            UIView.animate(withDuration: self.viewController.animationSpeed, delay: 0, options: .curveEaseOut, animations: {
                newCalendarPage.frame.origin.y -= cordinateYDifference
            
            })
            
            self.viewController.calendarPages.append(newCalendarPage)
            cordinateYDifference += self.setting.newCalendarPageCordiateYDifference

        }
    }
    
   
    
    
}
