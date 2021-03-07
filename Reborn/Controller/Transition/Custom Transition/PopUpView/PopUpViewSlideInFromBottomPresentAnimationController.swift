//
//  PopUpViewAnimator.swift
//  Reborn
//
//  Created by Christian Liu on 2/1/21.
//

import Foundation
import UIKit
class PopUpViewSlideInFromBottomPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var originFrame = CGRect.zero
  
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return SystemSetting.shared.popUpWindowPresentShortDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        print(transitionContext.containerView)
        
        let toViewController = transitionContext.viewController(forKey: .to)!
        transitionContext.containerView.addSubview(toViewController.view)
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        let initialFrame = CGRect(origin: CGPoint(x: 0, y: SystemSetting.shared.screenFrame.height), size: finalFrame.size)
        
        toViewController.view.frame = initialFrame
        
       
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .curveEaseOut, animations: {

            toViewController.view.frame = finalFrame
        }) { _ in


            UIView.animate(withDuration: SystemSetting.shared.popUpWindowBounceDuration, delay: 0.0, options: .curveEaseOut, animations: {
                toViewController.view.frame = CGRect(x: finalFrame.origin.x, y: finalFrame.origin.y + 15, width: finalFrame.width, height: finalFrame.height)
            }) { _ in
                transitionContext.completeTransition(true)
            }

        }
    }
    

}
