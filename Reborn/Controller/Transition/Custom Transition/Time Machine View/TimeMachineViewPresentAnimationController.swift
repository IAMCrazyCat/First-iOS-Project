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
//        let tabBarController = transitionContext.viewController(forKey: .to) as! UITabBarController
//        let navigationController = tabBarController.viewControllers![0] as! UINavigationController
//        let toViewController = navigationController.viewControllers.first as! TimeMachineViewController
    
        
        

       
        guard
            let toViewController = transitionContext.viewController(forKey: .to) as? TimeMachineViewController,
            let toView = transitionContext.view(forKey: .to)
            //let fromViewController = transitionContext.viewController(forKey: .from) as? CalendarViewController
            //let fromView = transitionContext.view(forKey: .from)
        else {
            transitionContext.completeTransition(false)
            return
        }
          
        let containerView = transitionContext.containerView
        //toViewController.view.addSubview(toViewController.calendarView!)
        containerView.addSubview(toView)
        
        toViewController.view.backgroundColor = UIColor.white.withAlphaComponent(0)
        toViewController.initialize()
        
        UIView.animate(withDuration: 0.8, animations: {
            toViewController.view.backgroundColor = UIColor.white.withAlphaComponent(1)
        }) { _ in
            
            transitionContext.completeTransition(true)
            toViewController.calendarPages.first?.addSubview(toViewController.calendarView!)
        }
 
        
    }
    
    
}
