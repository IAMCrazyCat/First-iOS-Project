//
//  DismissTimeMachineSegue.swift
//  Reborn
//
//  Created by Christian Liu on 31/1/21.
//


import Foundation
import UIKit

class DismissTimeMachineSegue: UIStoryboardSegue {
    
    override func perform() {
        destination.transitioningDelegate = self
        destination.modalPresentationStyle = .fullScreen
        source.dismiss(animated: true, completion: nil)
    }
}

extension DismissTimeMachineSegue: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TimeMachineViewPresentAnimationController()
    }
        
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TimeMachineViewDismissAnimationController()
    }
}

class TimeMachineViewDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
   
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        
    }
    
    
}

