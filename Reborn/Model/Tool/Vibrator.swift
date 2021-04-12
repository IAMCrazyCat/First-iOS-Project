//
//  VibrationFeedback.swift
//  Reborn
//
//  Created by Christian Liu on 13/2/21.
//

import Foundation
import UIKit

struct Vibrator {
    
    static func vibrate(withImpactLevel feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: feedbackStyle)
        generator.impactOccurred()
    
    }
    
    static func vibrate(withNotificationType feedbackStyle: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(feedbackStyle)
    }
}
