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
    @IBOutlet var functionNumberButtons: [UIButton]!
    @IBOutlet var functionViews: [UIView]!
    
    var lastViewController: UIViewController?
    let engine: AppEngine = AppEngine.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        SKPaymentQueue.default().add(self)
        avatarView.contentMode = .scaleAspectFill
        
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        avatarView.setCornerRadius()
        purchaseButton.setCornerRadius()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
        
        let productID = "com.crazycat.Reborn.FullFuctionalities"
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            print("Can't make payments")
        }
    }
    
    func updateUserAvatar() {
        avatarView.image = engine.currentUser.getAvatarImage()
    }
    
    func updateAllButtons() {
        for button in functionNumberButtons {
            button.setBackgroundColor(self.engine.userSetting.themeColor.uiColor, for: .normal)
            button.setTitleColor(self.engine.userSetting.smartLabelColor, for: .normal)
        }
        
        purchaseButton.setBackgroundColor(self.engine.userSetting.themeColor.uiColor, for: .normal)
        purchaseButton.setTitleColor(self.engine.userSetting.smartLabelColor, for: .normal)
    }
   

}

extension PurchaseViewController: UIObserver {
    func updateUI() {
        updateVIPFouctionViews()
        updateUserAvatar()
        updateAllButtons()
    }
}

extension PurchaseViewController: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                
                print("Thanks for shopping")
                SKPaymentQueue.default().finishTransaction(transaction)
                self.engine.purchaseApp()
                
                if let userCenterViewController = self.lastViewController as? UserCenterViewController {
                    userCenterViewController.excuteVipButtonAnimation()
                }
                
                self.dismiss(animated: true, completion: {
                    
                })
                
            } else if transaction.transactionState == .failed {
                print("Transaction Failed!")
                SKPaymentQueue.default().finishTransaction(transaction)
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print(errorDescription)
                }
            }
        }
    }
    
    
    
}
