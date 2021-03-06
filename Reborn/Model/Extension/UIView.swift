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
    
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }

    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    enum ShadowStyle {
        case button
        case view
    }
    func setShadow(style: ShadowStyle) {
        
        switch style {
        case .button:
            self.layer.shadowColor = SystemSetting.shared.UIButtonShadowColor
            self.layer.shadowOffset =  SystemSetting.shared.UIButtonShadowOffset
            self.layer.shadowRadius = SystemSetting.shared.UIButtonShadowRadius
            self.layer.shadowOpacity = SystemSetting.shared.UIButtonShadowOpacity
        case .view:
            self.layer.shadowColor = SystemSetting.shared.UIViewShadowColor
            self.layer.shadowOffset =  SystemSetting.shared.UIViewShadowOffset
            self.layer.shadowRadius = SystemSetting.shared.UIViewShadowRadius
            self.layer.shadowOpacity = SystemSetting.shared.UIViewShadowOpacity
        }

      
        self.layer.masksToBounds = false
    }
    
    func setCornerRadius(rounded: Bool = false, corderRadius: CGFloat? = nil) {
        self.layoutIfNeeded()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = corderRadius != nil ? corderRadius! : (rounded ? (self.frame.height / 2).rounded(toPlaces: 0) : self.frame.height / 2)

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
    
    func showConfettiAnimationAtBack(isRemovedOnCompletion: Bool = false) {
       
        let confettiAnimationView = ConfettiAnimationView(frame: self.bounds)
        confettiAnimationView.accessibilityIdentifier = "ConfettiAnimationView"
        confettiAnimationView.layer.cornerRadius = self.layer.cornerRadius
        confettiAnimationView.layer.masksToBounds = true
        self.insertSubview(confettiAnimationView, at: 0)
        confettiAnimationView.excuteAnimation()
        if isRemovedOnCompletion {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIView.animate(withDuration: 0.5, animations: {
                    confettiAnimationView.alpha = 0
                }) { _ in
                    confettiAnimationView.removeFromSuperview()
                }
            }
        }
    }
    
    func showConfettiAnimationInFront(isRemovedOnCompletion: Bool = false) {
        let confettiAnimationView = ConfettiAnimationView(frame: self.bounds)
        confettiAnimationView.accessibilityIdentifier = "ConfettiAnimationView"
        confettiAnimationView.layer.cornerRadius = self.layer.cornerRadius
        confettiAnimationView.layer.masksToBounds = true
        self.addSubview(confettiAnimationView)
        confettiAnimationView.excuteAnimation()
        if isRemovedOnCompletion {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIView.animate(withDuration: 0.5, animations: {
                    confettiAnimationView.alpha = 0
                }) { _ in
                    confettiAnimationView.removeFromSuperview()
                }
            }
        }
    }
    
    func getSubviewBy(idenifier: String) -> UIView? {
        var subviewByIdentifier: UIView? = nil
        
        for subview in self.subviews {
            if subview.accessibilityIdentifier == idenifier {
                subviewByIdentifier = subview
            }
        }
        return subviewByIdentifier
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
    
    func removeSubviewBy(idenifier: String){
        var subviewByIdentifier: UIView? = nil
        
        for subview in self.subviews {
            if subview.accessibilityIdentifier == idenifier {
                subviewByIdentifier = subview
            }
        }
        subviewByIdentifier?.removeFromSuperview()
    }
    
    func removeAllSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
    func renderItemCard(by item: Item) {
        self.removeAllSubviews()
        let builder = ItemCardViewBuilder(item: item, frame: CGRect(x: 0, y: 0, width: self.frame.width - 2 * SystemSetting.shared.mainPadding, height: SystemSetting.shared.itemCardHeight), isInteractable: false)
        let itemCard = builder.buildView()
        itemCard.center = self.center
        self.addSubview(itemCard)
    }
    
    func renderItemCards(withCondition condition: ItemsFilterCondition, animated: Bool) {
        
        switch condition {
        case .all: self.renderItemCards(withState: nil, animated: animated)
        case .completed: self.renderItemCards(withState: .completed, animated: animated)
        case .duringBreak: self.renderItemCards(withState: .duringBreak, animated: animated)
        case .inProgress: self.renderItemCards(withState: .inProgress, animated: animated)
        }
    }
    
    
    
    private func renderItemCards(withState state: ItemState?, animated: Bool) {
        self.removeAllSubviews()
        AppEngine.shared.currentUser.sortItems()
        let isRenderingAll = state == nil ? true : false
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
            var itemNumber = 1
            while tag >= 0 {
                let item = items[tag]
                if item.state == state || isRenderingAll {
                    let builder = ItemCardViewBuilder(item: item, frame: CGRect(x: SystemSetting.shared.mainPadding, y: cordinateY, width: self.frame.width - 2 * SystemSetting.shared.mainPadding, height: SystemSetting.shared.itemCardHeight), isInteractable: true)
                    let itemCard = builder.buildView()
                    cordinateY += SystemSetting.shared.itemCardHeight + SystemSetting.shared.itemCardGap
                    self.frame.size.height = itemCard.frame.maxY
                    
                    
                    if animated {
                        let originalAlpha = itemCard.alpha
                        itemCard.alpha /= 2
                        itemCard.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                        self.addSubview(itemCard)
                        UIView.animate(withDuration: 0.3, delay: TimeInterval(Double(itemNumber - 1) * 0.1), options: .curveEaseOut, animations: {
                            itemCard.transform = CGAffineTransform(scaleX: 1, y: 1)
                            itemCard.alpha = originalAlpha
                        })
                       
                    } else {
                        self.addSubview(itemCard)
                    }
                    
                    itemNumber += 1
                    noConditionedItemFound = false
                    
                }
                
               
                tag -= 1
            }

        }
       
        if userHasNoItem {
            promptButton.setTitle("点击右上角添加你的第一个目标", for: .normal)
        } else if noConditionedItemFound {
            
            switch state {
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
        
        promptButton.titleLabel?.font = AppEngine.shared.userSetting.smallFont
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
