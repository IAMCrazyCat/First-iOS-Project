//
//  UIView.swift
//  Reborn
//
//  Created by Christian Liu on 5/1/21.
//

import Foundation
import UIKit
extension UIView {
    func setShadow() {

        self.layer.shadowColor = SystemStyleSetting.shared.UIViewShadowColor
        self.layer.shadowOffset =  SystemStyleSetting.shared.UIViewShadowOffset
        self.layer.shadowOpacity = SystemStyleSetting.shared.UIViewShadowOpacity
        self.layer.masksToBounds = false
    }
    
    func setCornerRadius() {
        
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    func shake(duration: TimeInterval = 0.5, values: [CGFloat] = [-12.0, 12.0, -12.0, 12.0, -6.0, 6.0, -3.0, 3.0, 0.0]) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")

        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)

        animation.duration = duration // You can set fix duration
        animation.values = values  // You can set fix values here also
        self.layer.add(animation, forKey: "shake")
    }
}
