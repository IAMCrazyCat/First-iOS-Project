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

        self.layer.shadowColor = SystemSetting.shared.UIViewShadowColor
        self.layer.shadowOffset =  SystemSetting.shared.UIViewShadowOffset
        self.layer.shadowOpacity = SystemSetting.shared.UIViewShadowOpacity
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
    
    func getSubviewBy(idenifier: String) -> UIView? {
        var subviewByEdentifier: UIView? = nil
        
        for subview in self.subviews {
            if subview.accessibilityIdentifier == idenifier {
                subviewByEdentifier = subview
            }
        }
        return subviewByEdentifier
    }
    
    func getSubviewBy(tag: Int) -> UIView? {
        var subviewByTag: UIView? = nil
        
        for subview in self.subviews {
            if subview.tag == tag {
                subviewByTag = subview
            }
        }
        return subviewByTag
    }
    
    func removeAllSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
    func renderItemCard(by item: Item) {
        let builder = ItemCardViewBuilder(item: item, frame: CGRect(x: 0, y: 0, width: self.frame.width - 2 * SystemSetting.shared.mainPadding, height: SystemSetting.shared.itemCardHeight), isInteractable: false)
        let itemCard = builder.buildView()
        itemCard.center = self.center
        self.addSubview(itemCard)
    }
    
    func renderItemCards(withConstraint condition: ItemState?) {
        
        let isRenderingAll = condition == nil ? true : false
        let items = AppEngine.shared.currentUser.items
        var tag: Int = items.count - 1
        var cordinateY: CGFloat = SystemSetting.shared.mainPadding

        while tag >= 0 {
            let item = items[tag]
            if item.state == condition || isRenderingAll {
                let builder = ItemCardViewBuilder(item: item, frame: CGRect(x: SystemSetting.shared.mainPadding, y: cordinateY, width: self.frame.width - 2 * SystemSetting.shared.mainPadding, height: SystemSetting.shared.itemCardHeight), punchInButtonTag: tag, isInteractable: true)
                let itemCard = builder.buildView()
                cordinateY += SystemSetting.shared.itemCardHeight + SystemSetting.shared.itemCardGap
                self.addSubview(itemCard)
                
                
            }
            tag -= 1
        }

      
    }
    
    
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
    
   
    
    

    
}
