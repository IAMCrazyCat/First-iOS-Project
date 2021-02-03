//
//  DismissStrategy.swift
//  Reborn
//
//  Created by Christian Liu on 3/2/21.
//

import Foundation
import UIKit

class DismissStrategy: PagesBehaviorStrategy {
    
    override func performStrategy() {
        dismissOtherCalendarPagesAndMoveThemDown()
    }
    
    func dismissOtherCalendarPagesAndMoveThemDown() {
        
        let scale: CGFloat = 1
        var cordinateYDifference = self.setting.newCalendarPageCordiateYDifference
        
        for index in 1 ... self.timeMachineViewController.calendarPages.count - 1 {
            let calendarPage = self.timeMachineViewController.calendarPages[index]
            
            
            UIView.animate(withDuration: self.timeMachineViewController.animationSpeed, delay: 0, options: .curveEaseOut, animations: {
                calendarPage.transform = CGAffineTransform(scaleX: scale, y: scale)
                calendarPage.frame.origin.y += cordinateYDifference
                calendarPage.alpha = 0
                
            }) { _ in
                
                calendarPage.removeFromSuperview()
                self.moveUpCalendarView()
                self.fadeOutOtherSubviews()
            }
            
            cordinateYDifference += self.setting.newCalendarPageCordiateYDifference

        }
       
    }
    
    func moveUpCalendarView() {
        if let calendarView = self.timeMachineViewController.calendarPages.first, let originalPosition = self.timeMachineViewController.calendarViewOriginalPosition {
            UIView.animate(withDuration: SystemStyleSetting.shared.timeMachineAnimationNormalSpeed, delay: 0, options: .curveEaseOut, animations: {
                calendarView.frame.origin.y = originalPosition.y
            })
        }
    }
    
    func fadeOutOtherSubviews() {
        
        UIView.animate(withDuration: SystemStyleSetting.shared.timeMachineAnimationSlowSpeed, delay: 0, options: .curveEaseOut, animations: {
            for subview in self.timeMachineViewController.view.subviews {  // fade out all subvies except calendar view
                if let calendarView = subview.subviews.first,
                   let identifier = calendarView.accessibilityIdentifier,
                   identifier == "InteractableCalendarView" {

                } else {
                    subview.alpha = 0
                }
            }
        })
        
    }
}
