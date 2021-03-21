//
//  TimeMachineViewDissmissAnimationController.swift
//  Reborn
//
//  Created by Christian Liu on 3/2/21.
//

import Foundation
import UIKit

class TimeMachineViewDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
   
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return SystemSetting.shared.timeMachineAnimationSlowSpeed
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        print("DISMISS")
        
        guard
            let fromViewController =  transitionContext.viewController(forKey: .from) as? TimeMachineViewController,
            let toViewController = transitionContext.viewController(forKey: .to) as? CalendarViewController,
            let originalParentViewController = toViewController.originalParentViewController as? ItemDetailViewController,
            let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to)
        else {
            print("Found nil when unwrapping guard attributes, location: 'TimeMachineViewPresentAnimation Line \(#line)'")
            transitionContext.completeTransition(false)
            return
        }

        
        fromViewController.dismissCalendarPages()
        originalParentViewController.topView.alpha = 0
        
        UIView.animate(withDuration: SystemSetting.shared.timeMachineAnimationSlowSpeed, animations: {
            fromViewController.view.backgroundColor = fromViewController.view.backgroundColor?.withAlphaComponent(0)
            fromViewController.topView.alpha = 0
            fromViewController.middleView.backgroundColor = fromViewController.middleView.backgroundColor?.withAlphaComponent(0)
            fromViewController.bottomView.alpha = 0
            
        }) { _ in
            
            let containerView = transitionContext.containerView
            containerView.addSubview(toView)
            originalParentViewController.topView.alpha = 1
            originalParentViewController.addChild(toViewController)
            originalParentViewController.topView.addSubview(toView)
            transitionContext.completeTransition(true)

           
        }
        

    }
    
    
}
