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
        self.layoutIfNeeded()
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
    
    func addConfettiView() {
        let confettiView = SwiftConfettiView(frame: self.bounds)
        confettiView.type = .random
        confettiView.intensity = 0.5
        confettiView.clipsToBounds = true
        self.addSubview(confettiView)
        confettiView.startConfetti()
    }
    
    func showConfettiAnimationAtBack() {
       
        let confettiAnimationView = ConfettiAnimationView(frame: self.bounds)
        confettiAnimationView.accessibilityIdentifier = "ConfettiAnimationView"
        confettiAnimationView.layer.cornerRadius = self.layer.cornerRadius
        confettiAnimationView.layer.masksToBounds = true
        self.insertSubview(confettiAnimationView, at: 0)
        confettiAnimationView.excuteAnimation()
        
    }
    
    func showConfettiAnimationInFront() {
        let confettiAnimationView = ConfettiAnimationView(frame: self.bounds)
        confettiAnimationView.accessibilityIdentifier = "ConfettiAnimationView"
        confettiAnimationView.layer.cornerRadius = self.layer.cornerRadius
        confettiAnimationView.layer.masksToBounds = true
        self.addSubview(confettiAnimationView)
        confettiAnimationView.excuteAnimation()
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
    
    func renderItemCards(withCondition condition: ItemState?) {
        
        let isRenderingAll = condition == nil ? true : false
        let items = AppEngine.shared.currentUser.items
        var tag: Int = items.count - 1
        var cordinateY: CGFloat = SystemSetting.shared.mainPadding
       
        let promptButton = UIButton()
        
        self.addSubview(promptButton)
        promptButton.translatesAutoresizingMaskIntoConstraints = false
        promptButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        //promptButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        promptButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 100).isActive = true
        
        var noConditionedItemFound: Bool = true
        var userHasNoItem: Bool = true
        if items.count > 0 {
            userHasNoItem = false
            while tag >= 0 {
                let item = items[tag]
                if item.state == condition || isRenderingAll {
                    let builder = ItemCardViewBuilder(item: item, frame: CGRect(x: SystemSetting.shared.mainPadding, y: cordinateY, width: self.frame.width - 2 * SystemSetting.shared.mainPadding, height: SystemSetting.shared.itemCardHeight), punchInButtonTag: tag, isInteractable: true)
                    let itemCard = builder.buildView()
                    cordinateY += SystemSetting.shared.itemCardHeight + SystemSetting.shared.itemCardGap
                    self.frame.size.height = itemCard.frame.maxY
                    self.addSubview(itemCard)
                    noConditionedItemFound = false
                    
                }
                tag -= 1
            }

        }
       
        if userHasNoItem {
            print("HHHHHH")
            promptButton.setTitle("点击右上角添加你的第一个目标", for: .normal)
        } else if noConditionedItemFound {
            
            switch condition {
            case .completed:
                promptButton.setTitle("还没有完成的项目，继续加油", for: .normal)
            case .duringBreak:
                promptButton.setTitle("今天没有休息的项目，记得打卡哦", for: .normal)
            case .inProgress:
                promptButton.setTitle("今天没有项目需要打卡，好好休息", for: .normal)
            default:
                promptButton.setTitle("暂无项目", for: .normal)
            }
            
        }
        
        promptButton.titleLabel?.font = AppEngine.shared.userSetting.fontSmall
        promptButton.setTitleColor(SystemSetting.shared.grayColor, for: .normal)
        
      
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
