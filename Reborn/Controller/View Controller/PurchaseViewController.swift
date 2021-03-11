//
//  PurchaseViewController.swift
//  Reborn
//
//  Created by Christian Liu on 6/3/21.
//

import UIKit
import StoreKit

class PurchaseViewController: UIViewController {

    
    @IBOutlet var avatarView: UIImageView!
    @IBOutlet var middleScrollView: UIScrollView!
    @IBOutlet var middleContentView: UIView!
    @IBOutlet var middleContentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var VIPFounctionOneView: UIView!
    @IBOutlet var VIPFounctionTwoView: UIView!
    @IBOutlet var VIPFounctionThreeView: UIView!
    @IBOutlet var VIPFounctionFourView: UIView!
    @IBOutlet var VIPFounctionFiveView: UIView!
    
    @IBOutlet var purchaseButton: UIButton!
    
    let engine: AppEngine = AppEngine.shared
    var functionViews: Array<UIView> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SKPaymentQueue.default().add(self)
        
        
        functionViews.append(VIPFounctionOneView)
        functionViews.append(VIPFounctionTwoView)
        functionViews.append(VIPFounctionThreeView)
        functionViews.append(VIPFounctionFourView)
        functionViews.append(VIPFounctionFiveView)
        
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        avatarView.setCornerRadius()
        purchaseButton.setCornerRadius()
    }
    
    func updateVIPFouctionViews() {
        
        for view in functionViews {
            for subview in view.subviews {
                if let button = subview as? UIButton {
                    button.proportionallySetSizeWithScreen()
                    button.setCornerRadius()
                }
            
            }
        }
    }
    
    
    @IBAction func purchaseButtonPressed(_ sender: UIButton) {
        purchaseApp()
    }
    
    func purchaseApp() {
        let productID = "com.crazycat.Reborn.VIPAccount"
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            print("Can't make payments")
        }
    }
    
    
    func updateUI() {
        updateVIPFouctionViews()
    }

}

extension PurchaseViewController: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                
                print("Thanks for shopping")
                SKPaymentQueue.default().finishTransaction(transaction)
                self.engine.purchaseApp()
                
            } else if transaction.transactionState == .failed {
                
                SKPaymentQueue.default().finishTransaction(transaction)
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print(errorDescription)
                }
            }
        }
    }
    
    
    
}
