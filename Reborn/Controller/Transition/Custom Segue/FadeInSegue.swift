//
//  FadeInSegue.swift
//  Reborn
//
//  Created by Christian Liu on 8/1/21.
//

import Foundation
import UIKit

class FadeInSegue: UIStoryboardSegue {
    
    override func perform() {
        destination.transitioningDelegate = self
        destination.modalPresentationStyle = .fullScreen
        source.present(destination, animated: true, completion: nil)
    }
}

extension FadeInSegue: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeInPresentAnimationController()
    }
        
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeInPresentAnimationController()
    }
}

class FadeInPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
   
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let tabBarController = transitionContext.viewController(forKey: .to) as! UITabBarController
        let navigationController = tabBarController.viewControllers![0] as! UINavigationController
        let homeViewController = navigationController.viewControllers.first as! HomeViewController
    

        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
                    
        containerView.addSubview(toView)
        toView.alpha = 0.0
        UIView.animate(withDuration: 0.8, animations: {
            toView.alpha = 1.0
        }) { _ in

            transitionContext.completeTransition(true)
            homeViewController.firstAccessIntialize()
        }
        
        
    }
    
    
}
