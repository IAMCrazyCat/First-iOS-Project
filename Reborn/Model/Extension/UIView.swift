//
//  UIView.swift
//  Reborn
//
//  Created by Christian Liu on 5/1/21.
//

import Foundation
import UIKit
import SwiftConfettiView
extension UIView {
    func setShadow() {

        self.layer.shadowColor = SystemStyleSetting.shared.UIViewShadowColor
        self.layer.shadowOffset =  SystemStyleSetting.shared.UIViewShadowOffset
        self.layer.shadowOpacity = SystemStyleSetting.shared.UIViewShadowOpacity
        self.layer.masksToBounds = false
    }
    
    func setCornerRadius() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    func shake(duration: TimeInterval = 0.5, values: [CGFloat] = [-12.0, 12.0, -12.0, 12.0, -6.0, 6.0, -3.0, 3.0, 0.0]) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")

        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)

        animation.duration = duration // You can set fix duration
        animation.values = values  // You can set fix values here also
        self.layer.add(animation, forKey: "shake")
    }
    
    func addConfettiEffect() {
        let confettiView = SwiftConfettiView(frame: self.bounds)
       
        confettiView.intensity = 0.5
        confettiView.clipsToBounds = true
        self.addSubview(confettiView)
        confettiView.startConfetti()
    }
    
    func getSubviewByIdentifier(idenifier: String) -> UIView? {
        var subviewByEdentifier: UIView? = nil
        
        for subview in self.subviews {
            if subview.accessibilityIdentifier == idenifier {
                subviewByEdentifier = subview
            }
        }
        return subviewByEdentifier
    }
    
    func renderItemCards(for type: ItemCardsType) {
        
        var items = AppEngine.shared.currentUser.items
        
        switch type {
        case .allItems:
            var tag = items.count - 1
            
            while tag <= items.count {
                let item = items[tag]
//                let builder = ItemCardViewBuilder(item: item, width: self.frame.width - 2 * SystemStyleSetting.shared.mainPadding, height: SystemStyleSetting.shared.itemCardHeight, corninateX: <#T##CGFloat#>, cordinateY: <#T##CGFloat#>, punchInButtonTag: tag, punchInButtonAction: <#T##Selector#>, detailsButtonAction: <#T##Selector#>)
                tag -= 1
            }
            
        case .todayItems:
            break
        case .breakDayItems:
            break
        case .finishedItems:
            break
        }
    }
    
}
