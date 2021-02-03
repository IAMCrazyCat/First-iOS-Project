//
//  TimeMachineViewDissmissAnimationController.swift
//  Reborn
//
//  Created by Christian Liu on 3/2/21.
//

import Foundation
import UIKit

class TimeMachineViewDissmissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
   
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
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
        
       
        
        fromViewController.dississCalendarPages()
        originalParentViewController.topView.alpha = 0
        
        UIView.animate(withDuration: 0.8, animations: {
            fromViewController.view.backgroundColor = UIColor.white.withAlphaComponent(0)
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
