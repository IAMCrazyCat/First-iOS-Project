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
        fadeInOtherSubviews()
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
                let builder = TimeMachineCalendarPageBuilder(interactableCalendarView: self.timeMachineViewController.calendarPages.first!.subviews.first!, calendarViewController: self.timeMachineViewController.calendarViewController!, monthDifference: -index)
                let tempCalendarPage = builder.buildCalendarPage()
                tempCalendarPage.accessibilityIdentifier = "TempCalendarPageView"
                
                self.removeOldTempCalendarPage(superview: self.timeMachineViewController.calendarPages[index])
                self.timeMachineViewController.calendarPages[index].addSubview(tempCalendarPage) // add temp calendar page to that will disapear
            }
           
        }
        
    }
    
    func fadeInOtherSubviews() {
        for subview in self.timeMachineViewController.view.subviews {  // fade out all subvies except calendar view
            if let calendarView = subview.subviews.first,
               let identifier = calendarView.accessibilityIdentifier,
               identifier == "InteractableCalendarView" {

            } else {
                subview.alpha = 0
            }
        }
        
        UIView.animate(withDuration: self.timeMachineViewController.animationSpeed, delay: 0, options: .curveEaseOut, animations: {
            for subview in self.timeMachineViewController.view.subviews {  // fade out all subvies except calendar view
                if let calendarView = subview.subviews.first,
                   let identifier = calendarView.accessibilityIdentifier,
                   identifier == "InteractableCalendarView" {

                } else {
                    subview.alpha = 1
                }
            }
        })
        
    }
    
    func moveDownCalendarView() {
        if let calendarView = self.timeMachineViewController.calendarView{
            calendarView.accessibilityIdentifier = "InteractableCalendarView"
            
            let newCalendarPage = UIView()
            newCalendarPage.backgroundColor = self.setting.calendarPageColor
            newCalendarPage.frame = self.timeMachineViewController.calendarView!.frame
            newCalendarPage.layer.cornerRadius = self.setting.itemCardCornerRadius
            newCalendarPage.setViewShadow()
            newCalendarPage.addSubview(calendarView)
            self.timeMachineViewController.calendarView?.frame.origin = .zero
            self.timeMachineViewController.view.addSubview(newCalendarPage)
            self.timeMachineViewController.calendarPages.append(newCalendarPage)
            self.timeMachineViewController.calendarViewOriginalPosition = self.timeMachineViewController.calendarPages.first?.frame.origin
            
            UIView.animate(withDuration: self.timeMachineViewController.animationSpeed, delay: 0, options: .curveEaseOut, animations: {

                self.timeMachineViewController.calendarPages.first?.frame.origin.y = self.setting.screenFrame.height / 2 -  calendarView.frame.height / 2
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
            newCalendarPage.frame = self.timeMachineViewController.calendarPages[0].frame
            newCalendarPage.transform = CGAffineTransform(scaleX: scale, y: scale)
            newCalendarPage.layer.cornerRadius = self.setting.itemCardCornerRadius
            newCalendarPage.setViewShadow()
            
            
            self.timeMachineViewController.view.insertSubview(newCalendarPage, belowSubview: self.timeMachineViewController.calendarPages[index])
            
            UIView.animate(withDuration: self.timeMachineViewController.animationSpeed, delay: 0, options: .curveEaseOut, animations: {
                newCalendarPage.frame.origin.y -= cordinateYDifference
            
            })
            
            self.timeMachineViewController.calendarPages.append(newCalendarPage)
            cordinateYDifference += self.setting.newCalendarPageCordiateYDifference

        }
    }
    
   
    
    
}
