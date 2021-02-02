//
//  File.swift
//  Reborn
//
//  Created by Christian Liu on 2/1/21.
//

import Foundation
import UIKit

extension UIViewController: UIViewControllerTransitioningDelegate  {
    
    func presentBottom(to toViewController: PopUpViewController) {
  
        let detailsTransitioningDelegate = InteractiveModalTransitioningDelegate(from: self, to: toViewController)
        toViewController.modalPresentationStyle = .custom
        toViewController.transitioningDelegate = detailsTransitioningDelegate
        self.present(toViewController, animated:true, completion: nil)
     }
    
        
}
