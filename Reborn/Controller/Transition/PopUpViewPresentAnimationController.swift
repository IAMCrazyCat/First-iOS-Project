//
//  PopUpViewAnimator.swift
//  Reborn
//
//  Created by Christian Liu on 2/1/21.
//

import Foundation
import UIKit
class PopUpViewPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var originFrame = CGRect.zero
  
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return SystemStyleSetting.shared.popUpWindowPresentDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        print(transitionContext.containerView)
        
        let popUpViewController = transitionContext.viewController(forKey: .to)!
        transitionContext.containerView.addSubview(popUpViewController.view)
        let finalFrame = transitionContext.finalFrame(for: popUpViewController)
        let initialFrame = CGRect(origin: CGPoint(x: 0, y: SystemStyleSetting.shared.screenFrame.height), size: finalFrame.size)
        
        popUpViewController.view.frame = initialFrame
        
       
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .curveEaseOut, animations: {

            popUpViewController.view.frame = finalFrame
        }) { _ in


            UIView.animate(withDuration: SystemStyleSetting.shared.popUpWindowBounceDuration, delay: 0.0, options: .curveEaseOut, animations: {
                popUpViewController.view.frame = CGRect(x: finalFrame.origin.x, y: finalFrame.origin.y + 15, width: finalFrame.width, height: finalFrame.height)
            }) { _ in
                transitionContext.completeTransition(true)
            }

        }
    }
    

}
