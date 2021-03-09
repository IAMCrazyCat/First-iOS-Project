//
//  InteractiveModalTransitioningDelegate.swift
//  Reborn
//
//  Created by Christian Liu on 2/1/21.
//

import Foundation
import UIKit

final class PopUpViewTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var interactiveDismiss = true
    
    init(from presented: UIViewController, to presenting: UIViewController) {
        super.init()
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let defaultAnimationController = PopUpViewSlideInFromBottomPresentAnimationController()
        

        guard let presentingViewController = presented as? PopUpViewController,
              let popUpAnimationType = presentingViewController.popUp?.presentAnimationType
              else {
            print("Found nil")
            return defaultAnimationController
        }
        
        switch popUpAnimationType {
            case .fadeInFromCenter:  return PopUpViewFadeInFromCenterPresentAnimationController()
            case .slideInToBottom: return PopUpViewSlideInFromBottomPresentAnimationController()
            case .slideInToCenter: return PopUpViewSlideInFromBottomPresentAnimationController()
        }
    
        
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return PopUpViewPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
}
