//
//  NoWhereStrategy.swift
//  Reborn
//
//  Created by Christian Liu on 31/1/21.
//

import Foundation
import UIKit
class PresentStrategy: PagesBehaviorStrategy {
    
    
    override func performStrategy() {
        
        moveDownCalendarView()
    }
    
    override func updateCalendarPagesColor() {
        var r: CGFloat = 1
        var g: CGFloat = 1
        var b: CGFloat = 1
        

        for index in 0 ... self.timeMachineViewController.calendarPages.count - 1 {
            
            let calendarPage = self.timeMachineViewController.calendarPages[index]
            calendarPage.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1)
            
            r -= self.setting.calendarPageColorDifference
            g -= self.setting.calendarPageColorDifference
            b -= self.setting.calendarPageColorDifference
           
        }
    }
    
    override func updateTempCalendarPage() {
        
        if self.timeMachineViewController.calendarViewController != nil {

            for index in 1 ... 3 {
                let builder = TimeMachineCalendarPageViewBuilder(interactableCalendarView: self.timeMachineViewController.calendarPages.first!.subviews.first!, calendarViewController: self.timeMachineViewController.calendarViewController!, monthDifference: -index)
                let tempCalendarPage = builder.buildCalendarPage()
                tempCalendarPage.accessibilityIdentifier = "TempCalendarPageView"
                
                self.removeOldTempCalendarPage(superview: self.timeMachineViewController.calendarPages[index])
                self.timeMachineViewController.calendarPages[index].addSubview(tempCalendarPage) // add temp calendar page to that will disapear
            }
           
        }
        
    }
    
    
    func moveDownCalendarView() {
        if let calendarView = self.timeMachineViewController.calendarView {
            calendarView.accessibilityIdentifier = "InteractableCalendarView"
            calendarView.frame.origin = .zero
            
            let newCalendarPage = UIView()
            newCalendarPage.backgroundColor = self.setting.calendarPageColor
            newCalendarPage.frame.size = calendarView.frame.size
            newCalendarPage.frame.origin = self.timeMachineViewController.calendarViewOriginalPosition ?? .zero
            newCalendarPage.layer.cornerRadius = self.setting.itemCardCornerRadius
            newCalendarPage.setShadow()
            newCalendarPage.addSubview(calendarView)
            self.timeMachineViewController.middleView.addSubview(newCalendarPage)
            self.timeMachineViewController.calendarPages.append(newCalendarPage)
            self.timeMachineViewController.view.layoutIfNeeded()
            
            UIView.animate(withDuration: self.setting.timeMachineAnimationSlowSpeed, delay: 0, options: .curveEaseOut, animations: {
        
                self.timeMachineViewController.calendarPages.first?.frame.origin.y = self.timeMachineViewController.middleView.frame.height / 2  - self.timeMachineViewController.calendarPages.first!.frame.height / 2
                //self.timeMachineViewController.calendarPages.first?.frame.origin.y = self.timeMachineViewController.bottomView.frame.origin.y - self.timeMachineViewController.calendarPages.first!.frame.height
                
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
            newCalendarPage.frame = self.timeMachineViewController.calendarPages.first!.frame
            newCalendarPage.transform = CGAffineTransform(scaleX: scale, y: scale)
            newCalendarPage.layer.cornerRadius = self.setting.itemCardCornerRadius
            newCalendarPage.setShadow()
            
            
            self.timeMachineViewController.middleView.insertSubview(newCalendarPage, belowSubview: self.timeMachineViewController.calendarPages[index])
            
            UIView.animate(withDuration: self.timeMachineViewController.animationSpeed, delay: 0, options: .curveEaseOut, animations: {

                newCalendarPage.frame.origin.y -= cordinateYDifference
            
            }) { _ in
                
                
            }
            
            self.timeMachineViewController.calendarPages.append(newCalendarPage)
            cordinateYDifference += self.setting.newCalendarPageCordiateYDifference

        }
    }
    
}
