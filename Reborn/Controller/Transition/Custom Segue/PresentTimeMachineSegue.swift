//
//  TimeMachineSegue.swift
//  Reborn
//
//  Created by Christian Liu on 27/1/21.
//

import Foundation
import UIKit

class PresentTimeMachineSegue: UIStoryboardSegue {
    
    override func perform() {
        destination.transitioningDelegate = self
        destination.modalPresentationStyle = .fullScreen
        source.present(destination, animated: true, completion: nil)
    }
}

extension PresentTimeMachineSegue: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TimeMachineViewPresentAnimationController()
    }
        
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TimeMachineViewPresentAnimationController()
    }
}

class TimeMachineViewPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
   
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        let tabBarController = transitionContext.viewController(forKey: .to) as! UITabBarController
//        let navigationController = tabBarController.viewControllers![0] as! UINavigationController
//        let toViewController = navigationController.viewControllers.first as! TimeMachineViewController
    
        
        //let fromViewController = transitionContext.viewController(forKey: .from) as! CalendarViewController
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: .to) as! TimeMachineViewController
        

        print("transition")
        if toViewController.calendarView != nil {

            //toViewController.view.addSubview(toViewController.calendarView!)
            containerView.addSubview(toViewController.view)
            toViewController.inlitialize()
        }
        
        toViewController.view.backgroundColor = UIColor.white.withAlphaComponent(0)
        
        UIView.animate(withDuration: 0.8, animations: {
            toViewController.view.backgroundColor = UIColor.white.withAlphaComponent(1)
        }) { _ in
            
            transitionContext.completeTransition(true)
 
        }
        
        
    }
    
    
}

