//
//  File.swift
//  Reborn
//
//  Created by Christian Liu on 2/1/21.
//

import Foundation
import UIKit

extension UIViewController: UIViewControllerTransitioningDelegate  {
    
    
    
    func presentBottom(popUpViewController controller: PopUpViewController) {
  
        let detailsTransitioningDelegate = InteractiveModalTransitioningDelegate(from: self, to: controller)
        
      
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = detailsTransitioningDelegate
        self.present(controller, animated:true, completion: nil)
     }
    
        
}
