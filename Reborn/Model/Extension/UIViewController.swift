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
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let popUpViewController = storyboard.instantiateViewController(withIdentifier: "PopUpViewController") as? PopUpViewController {
            
            AppEngine.shared.delegate = self as? PopUpViewDelegate
            
            switch popUpType {
            case .customFrequencyPopUp:
                popUpViewController.popUp = CustomFrequencyPopUp(presentAnimationType: animationType, popUpViewController: popUpViewController, dataStartIndex: dataStartIndex)
            case .customItemNamePopUp:
                popUpViewController.popUp = CustomItemNamePopUpView(presentAnimationType: animationType, popUpViewController: popUpViewController)
            case .customTargetDaysPopUp:
                popUpViewController.popUp = CustomTargetDaysPopUp(presentAnimationType: animationType, popUpViewController: popUpViewController, dataStartIndex: dataStartIndex)
            case .customThemeColorPopUp:
                popUpViewController.popUp = CustomThemeColorPopUp(presentAnimationType: animationType, popUpViewController: popUpViewController)
            case .customUserNamePopUp:
                popUpViewController.popUp = CustomUserNamePopUp(presentAnimationType: animationType, popUpViewController: popUpViewController)
            case .itemCompletedPopUp:
                print("You should not use this function")
                print("Use 'showItemCompletedPopUp(for: Item)' instead")
            }
    
            //popUpViewController.updateUI()
            
            self.present(to: popUpViewController)
        }
       
       
        
    }
    
    func showItemCompletedPopUp(for item: Item) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let popUpViewController = storyboard.instantiateViewController(withIdentifier: "PopUpViewController") as? PopUpViewController {
            
            AppEngine.shared.delegate = self as? PopUpViewDelegate
            popUpViewController.popUp = ItemCompletedPopUp(item: item, presentAnimationType: .fadeInFromCenter, popUpViewController: popUpViewController)
            self.present(to: popUpViewController)
        }
    }
    
}

class UpdateStyleMode: UIViewController {
    
}
