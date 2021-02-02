//
//  TimeMachineTransitioningDelegate.swift
//  Reborn
//
//  Created by Christian Liu on 2/2/21.
//

import Foundation
import UIKit

final class TimeMachineTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var interactiveDismiss = true
    
    init(from presented: UIViewController, to presenting: UIViewController) {
        super.init()
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TimeMachineViewPresentAnimationController()
    }
        
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return  TimeMachineViewDissmissAnimationController()
    }
    
}
