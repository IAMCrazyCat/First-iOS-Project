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
        print("TimeMachineDissmissed")
        return TimeMachineViewDismissAnimationController()
    }
}





