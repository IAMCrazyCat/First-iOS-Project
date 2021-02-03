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
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
       
        
        guard
            let fromViewConroller =  transitionContext.viewController(forKey: .from) as? CalendarViewController,
            let toViewController = transitionContext.viewController(forKey: .to) as? TimeMachineViewController,
            let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to)
        else {
            print("Found nil when unwrapping guard attributes, location: 'TimeMachineViewPresentAnimation Line \(#line)'")
            transitionContext.completeTransition(false)
            return
        }
        
        let navBarheight = (fromViewConroller.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0) + (fromViewConroller.navigationController?.navigationBar.frame.height ?? 0.0)
 
        toViewController.calendarView = fromView
        toViewController.calendarViewController = fromViewConroller
        toViewController.calendarViewPosition = CGPoint(x: fromViewConroller.topView.frame.origin.x, y: fromViewConroller.topView.frame.origin.y + navBarheight)
        
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        
        toViewController.view.backgroundColor = UIColor.white.withAlphaComponent(0)
        toViewController.initialize()
        
        UIView.animate(withDuration: 0.8, animations: {
            toViewController.view.backgroundColor = UIColor.white.withAlphaComponent(1)
        }) { _ in
            
            transitionContext.completeTransition(true)
            toViewController.calendarPages.first?.addSubview(fromView)
        }
 
        
    }
    
    
}
