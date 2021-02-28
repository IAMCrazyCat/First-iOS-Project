//
//  File.swift
//  Reborn
//
//  Created by Christian Liu on 2/1/21.
//

import Foundation
import UIKit

extension UIViewController: UIViewControllerTransitioningDelegate  {
    
    func presentBottom(to presenting: PopUpViewController) {
  
        let detailsTransitioningDelegate = PopUpViewTransitioningDelegate(from: self, to: presenting)
        presenting.modalPresentationStyle = .custom
        presenting.transitioningDelegate = detailsTransitioningDelegate
        self.present(presenting, animated:true, completion: nil)
     }
    
//    public func showCenterPopUp() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let popUpType = PopUpType.customTargetDays
//
//        if let popUpViewController = storyboard.instantiateViewController(withIdentifier: "PopUpViewController") as? PopUpViewController {
//
//            let popUpWindow = PopUpViewBuilder(popUpType: popUpType, popUpViewController: popUpViewController).buildView()
//            popUpViewController.type = popUpType
//            popUpViewController.view.addSubview(popUpWindow)
//            forPresented.presentBottom(to: popUpViewController)
//        }
//    }

    func showBottom(_ popUpType: PopUpType, dataStartIndex: Int = 0) {
        
        AppEngine.shared.delegate = self as? PopUpViewDelegate
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let popUpViewController = storyboard.instantiateViewController(withIdentifier: "PopUpViewController") as? PopUpViewController {
            
            popUpViewController.dataStartIndex = dataStartIndex
            popUpViewController.type = popUpType
            popUpViewController.updateUI()
            AppEngine.shared.register(observer: popUpViewController)
            self.presentBottom(to: popUpViewController)
        }
        
    }
}

class UpdateStyleMode: UIViewController {
    
}
