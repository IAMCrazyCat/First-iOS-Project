//
//  GoBackToThePastStrategy.swift
//  Reborn
//
//  Created by Christian Liu on 4/2/21.
//

import Foundation
import UIKit

class GoBackToThePastStrategy: DismissStrategy {
    
    override func performStrategy() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

        dismissOtherCalendarPagesAndMoveThemDown()
    }
  
}
