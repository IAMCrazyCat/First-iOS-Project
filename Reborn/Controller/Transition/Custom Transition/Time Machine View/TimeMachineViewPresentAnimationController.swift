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
        
        let navBarheight = (originalParentViewController.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0) + (originalParentViewController.navigationController?.navigationBar.frame.height ?? 0.0)
        
        toViewController.calendarView = fromView
        toViewController.calendarViewController = fromViewController
        toViewController.calendarViewOriginalPosition = originalParentViewController.topView.frame.origin
        toViewController.topView.heightAnchor.constraint(equalToConstant: navBarheight).isActive = true // Make sure that the topview height is equal to nav bar

        
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        originalParentViewController.topView.alpha = 0
        
        
        
        toViewController.view.backgroundColor = toViewController.view.backgroundColor?.withAlphaComponent(0)
        toViewController.topView.alpha = 0
        toViewController.middleView.backgroundColor = toViewController.middleView.backgroundColor?.withAlphaComponent(0)
        toViewController.bottomView.alpha = 0
        toViewController.presentCalendarPages()
        
       
        
        UIView.animate(withDuration: SystemStyleSetting.shared.timeMachineAnimationSlowSpeed, animations: {
            
            toViewController.view.backgroundColor = toViewController.view.backgroundColor?.withAlphaComponent(1)
            toViewController.topView.alpha = 1
            toViewController.middleView.backgroundColor = toViewController.middleView.backgroundColor?.withAlphaComponent(1)
            toViewController.bottomView.alpha = 1
        }) { _ in
            
            transitionContext.completeTransition(true)
            toViewController.calendarPages.first?.addSubview(fromView)
        }
 
        
    }
    
    
}
