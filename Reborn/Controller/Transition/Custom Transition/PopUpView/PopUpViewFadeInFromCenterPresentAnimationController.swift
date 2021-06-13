//
//  PopUpViewDismissAnimator.swift
//  Reborn
//
//  Created by Christian Liu on 2/1/21.
//

import Foundation
import UIKit

class PopUpViewFadeInFromCenterPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return SystemSetting.shared.popUpWindowPresentMediumDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let toViewController = transitionContext.viewController(forKey: .to)! as! PopUpViewController
        transitionContext.containerView.addSubview(toViewController.view)
        let initialFrame = CGRect(x: SystemSetting.shared.screenFrame.origin.x + 100, y: SystemSetting.shared.screenFrame.origin.y + 20, width: SystemSetting.shared.screenFrame.width - 200, height: SystemSetting.shared.screenFrame.height - 200)
        let finalFrame = transitionContext.finalFrame(for: toViewController)

        
        let popUpWindow = toViewController.popUp?.window
        
        popUpWindow?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        popUpWindow?.alpha = 0.5
        toViewController.view.frame = finalFrame
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .curveEaseOut, animations: {
            popUpWindow?.alpha = 1
            popUpWindow?.transform = CGAffineTransform(scaleX: 1, y: 1)
            
        }) { _ in
            
            transitionContext.completeTransition(true)
            
        }
    }
    
    
}
