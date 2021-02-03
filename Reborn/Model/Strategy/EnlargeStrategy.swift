//
//  EnlargeStrategy.swift
//  Reborn
//
//  Created by Christian Liu on 3/2/21.
//

import Foundation
import UIKit

class EnlargeStrategy: PagesBehaviorStrategy {
    override func performStrategy() {
        enlargeCalendarView()
    }
    
    func enlargeCalendarView() {
        if let calendarView = self.timeMachineViewController.calendarPages.first {
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                calendarView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }) { _ in
                UIView.animate(withDuration: 0.15, animations: {
                    calendarView.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
                
            }
        }
    }
}
