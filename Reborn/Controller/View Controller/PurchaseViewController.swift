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
    @IBOutlet var bottomView: UIView!
    @IBOutlet var shadowCoverView: UIView!
    @IBOutlet var middleContentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var VIPFounctionOneView: UIView!
    @IBOutlet var VIPFounctionTwoView: UIView!
    @IBOutlet var VIPFounctionThreeView: UIView!
    @IBOutlet var VIPFounctionFourView: UIView!
    @IBOutlet var VIPFounctionFiveView: UIView!
    
    @IBOutlet var purchaseButton: UIButton!
    @IBOutlet var functionNumberButtons: [UIButton]!
    @IBOutlet var functionViews: [UIView]!
    
    @IBOutlet var monthSubscriptionButton: UIButton!
    @IBOutlet var yearSubscriptionButton: UIButton!
    @IBOutlet var permanentSubscriptionButton: UIButton!
    
    @IBOutlet var subscriptionButtons: [UIButton]!
    @IBOutlet var textView: UITextView!
    var selectedSubscriptionButton: UIButton!
    
    var lastViewController: UIViewController?
    let engine: AppEngine = AppEngine.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarView.contentMode = .scaleAspectFill
        selectedSubscriptionButton = monthSubscriptionButton
        updateUI()
        
        bottomView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        bottomView.layer.shadowOffset =  CGSize(width: 0, height: -2)
        bottomView.layer.shadowOpacity = 0.4
        bottomView.layer.shadowRadius = 5
        bottomView.layer.shadowPath = UIBezierPath(rect: bottomView.bounds).cgPath
        bottomView.layer.masksToBounds = false
        shadowCoverView.layer.zPosition = 2
        
        textView.delegate = self
        let instructionText = NSMutableAttributedString(string: "购买须知：一月期和一年期会员属于订阅型会员，订阅到期后会自动续费，您可以随时在系统的订阅管理中取消，了解如何取消订阅")
        instructionText.addAttribute(NSAttributedString.Key.foregroundColor, value: SystemSetting.shared.smartLabelGrayColor, range: NSRange(location: 0, length: 50))
        instructionText.addAttribute(.link, value: "https://support.apple.com/zh-cn/HT202039", range: NSRange(location: 50, length: 8))
        
        textView.attributedText = instructionText
        textView.linkTextAttributes = [
            .foregroundColor: AppEngine.shared.userSetting.smartThemeColor.withAlphaComponent(0.7)
        ]
        
    }
    
    override func viewDidLayoutSubviews() {
        avatarView.setCornerRadius()
        purchaseButton.setCornerRadius()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        middleScrollView.flashScrollIndicators()
    }
    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        self.updateUI()
//    }
   
    
    @IBAction func subscriptionButtonSelected(_ sender: UIButton) {
        Vibrator.vibrate(withImpactLevel: .light)
        for button in self.subscriptionButtons {
            button.isSelected = false
        }
        
        self.selectedSubscriptionButton = sender
        updateSubscriptionButtons()
    }
    
    
    
    @IBAction func purchaseButtonPressed(_ sender: UIButton) {
        
        var productID = ""
        
        if self.selectedSubscriptionButton.tag == 1 {
            productID = "com.crazycat.Reborn.OneMonthVip"
        } else if self.selectedSubscriptionButton.tag == 2 {
            productID = "com.crazycat.Reborn.OneYearVip"
        } else if self.selectedSubscriptionButton.tag == 3 {
            productID = "com.crazycat.Reborn.PermanentVip"
        }
        
        purchaseApp(withProductID: productID)
    }
    
    func updateSubscriptionButtons() {
        
        for button in self.subscriptionButtons {
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 15
            button.layer.borderWidth = 2
           
            button.setBackgroundColor(self.engine.userSetting.whiteAndBlackContent, for: .normal)
            button.setTitleColor(self.engine.userSetting.smartThemeColor, for: .normal)
            button.tintColor = .clear

            if button == self.selectedSubscriptionButton {
                button.isSelected = true
                button.layer.borderColor = self.engine.userSetting.themeColor.uiColor.cgColor
            } else {
                button.isSelected = false
                button.layer.borderColor = self.engine.userSetting.themeColor.uiColor.withAlphaComponent(0.1).cgColor
            }
        }
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
    
    func purchaseApp(withProductID productID: String) {
        SKPaymentQueue.default().add(self)
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            SystemAlert.present("您暂时无法购买", and: "请检查您的账户设置", from: self)
            print("Can't make payments")
        }
    }
    
    func updateUserAvatar() {
        avatarView.image = engine.currentUser.getAvatarImage()
    }
    
    func updateAllButtons() {
        for button in functionNumberButtons {
            button.setSmartColor()
        }
        
        purchaseButton.setSmartColor()
    }
   

}

extension PurchaseViewController: UIObserver {
    func updateUI() {
        updateSubscriptionButtons()
        updateVIPFouctionViews()
        updateUserAvatar()
        updateAllButtons()
        
    }
}

extension PurchaseViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            UIApplication.shared.open(URL)
            return false
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
                    userCenterViewController.purchaseDidFinish()
                }
                
                self.dismiss(animated: true, completion: {
                    
                })
                
            } else if transaction.transactionState == .failed {
                print("Transaction Failed!")
                SystemAlert.present("购买失败", and: "如有问题请回到个人中心发送反馈邮件，我们会尽快解决", from: self)
                SKPaymentQueue.default().finishTransaction(transaction)
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print(errorDescription)
                }
            }
        }
    }
    
    
    
}
