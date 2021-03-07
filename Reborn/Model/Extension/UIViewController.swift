//
//  File.swift
//  Reborn
//
//  Created by Christian Liu on 2/1/21.
//

import Foundation
import UIKit

extension UIViewController: UIViewControllerTransitioningDelegate  {
    

    private func present(to presenting: PopUpViewController) {
  
        let detailsTransitioningDelegate = PopUpViewTransitioningDelegate(from: self, to: presenting)
        presenting.modalPresentationStyle = .custom
        presenting.transitioningDelegate = detailsTransitioningDelegate
        self.present(presenting, animated:true, completion: nil)
     }
    
    func showPurchaseView() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let purchaseViewController = storyboard.instantiateViewController(withIdentifier: "PurchaseViewController") as? PurchaseViewController {
            self.present(purchaseViewController, animated: true, completion: nil)
        }
       
    }
    
    func show(_ popUpType: PopUpType, animation animationType: PopUpAnimationType = .slideInToBottom, dataStartIndex: Int = 0) {
        
        if popUpType != .itemCompletedPopUp {
            AppEngine.shared.delegate = self as? PopUpViewDelegate
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let popUpViewController = storyboard.instantiateViewController(withIdentifier: "PopUpViewController") as? PopUpViewController {
            
                popUpViewController.dataStartIndex = dataStartIndex
                popUpViewController.type = popUpType
                popUpViewController.animationType = animationType
                popUpViewController.updateUI()
                AppEngine.shared.add(observer: popUpViewController)
                self.present(to: popUpViewController)
            }
        } else {
            print("You should not use this function")
            print("Use 'showItemCompletedPopUp(for: Item)' instead")
        }
       
        
    }
    
    func showItemCompletedPopUp(for item: Item) {
        AppEngine.shared.delegate = self as? PopUpViewDelegate
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let popUpViewController = storyboard.instantiateViewController(withIdentifier: "PopUpViewController") as? PopUpViewController {
        
            popUpViewController.type = .itemCompletedPopUp
            popUpViewController.item = item
            popUpViewController.animationType = .fadeInFromCenter
            popUpViewController.updateUI()
            AppEngine.shared.add(observer: popUpViewController)
            self.present(to: popUpViewController)
        }
    }
    
}

class UpdateStyleMode: UIViewController {
    
}
