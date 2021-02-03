//
//  TimeMachineViewPresentAnimationController.swift
//  Reborn
//
//  Created by Christian Liu on 3/2/21.
//

import Foundation
import UIKit

class TimeMachineViewPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
   
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return SystemStyleSetting.shared.timeMachineAnimationSlowSpeed
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        
        guard
            let fromViewController =  transitionContext.viewController(forKey: .from) as? CalendarViewController,
            let toViewController = transitionContext.viewController(forKey: .to) as? TimeMachineViewController,
            let originalParentViewController = fromViewController.originalParentViewController as? ItemDetailViewController,
            let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to)
        else {
            print("Found nil when unwrapping guard attributes, location: 'TimeMachineViewPresentAnimation Line \(#line)'")
            transitionContext.completeTransition(false)
            return
        }
        
        toViewController.calendarView = fromView
        toViewController.calendarViewController = fromViewController

        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        
        originalParentViewController.topView.alpha = 0
        toViewController.view.backgroundColor = UIColor.white.withAlphaComponent(0)
        toViewController.presentCalendarPages()
        
       
        
        UIView.animate(withDuration: SystemStyleSetting.shared.timeMachineAnimationSlowSpeed, animations: {
            
            toViewController.view.backgroundColor = UIColor.white.withAlphaComponent(1)
        }) { _ in
            
            transitionContext.completeTransition(true)
            toViewController.calendarPages.first?.addSubview(fromView)
        }
 
        
    }
    
    
}
