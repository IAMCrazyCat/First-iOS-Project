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
        
        let containerView = transitionContext.containerView
        
        let toViewController = transitionContext.viewController(forKey: .to) as! ItemDetailViewController
        
        if let toViewController = transitionContext.viewController(forKey: .to) as? ItemDetailViewController {
            
            
//            //toViewController.view.addSubview(toViewController.calendarView!)
//            containerView.addSubview(toViewController.view)
//            toViewController.view.backgroundColor = UIColor.white.withAlphaComponent(0)
//            toViewController.initialize()
//
//            UIView.animate(withDuration: 0.8, animations: {
//                toViewController.view.backgroundColor = UIColor.white.withAlphaComponent(1)
//            }) { _ in
//
//                transitionContext.completeTransition(true)
//                toViewController.calendarPages.first?.addSubview(toViewController.calendarView!)
//            }
            
        }

    }
    
    
}
