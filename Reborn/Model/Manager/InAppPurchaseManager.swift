//
//  InAppPuchaseManager.swift
//  Reborn
//
//  Created by Christian Liu on 3/5/21.
//

import Foundation
import TPInAppReceipt
import UIKit
import StoreKit

class InAppPurchaseManager {
    static var shared = InAppPurchaseManager()
    
    var oneMonthProductID = "com.crazycat.Reborn.OneMonthVip"
    var oneYearProductID = "com.crazycat.Reborn.OneYearVip"
    var permanentProductID = "com.crazycat.Reborn.PermanentVip"
    
    init() {
    }
    

    public func getUserPurchaseType() -> PurchaseType {
        if let receipt = try? InAppReceipt.localReceipt() {
            var purchaseType: PurchaseType = .none
            
            if let purchase = receipt.lastAutoRenewableSubscriptionPurchase(ofProductIdentifier: PurchaseType.oneMonth.productID) {
                purchaseType = .oneMonth
            }
            if let purchase = receipt.lastAutoRenewableSubscriptionPurchase(ofProductIdentifier: PurchaseType.oneYear.productID) {
                purchaseType = .oneYear
            }
            
            if receipt.containsPurchase(ofProductIdentifier: PurchaseType.permanent.productID) {
                purchaseType = .permanent
            }
            
            return purchaseType

        } else {
            print("Receipt not found")
            return .none
        }
    }
    
    public func restorePurchase(in viewController: SKPaymentTransactionObserver) {
        SKPaymentQueue.default().add(viewController)
        if SKPaymentQueue.canMakePayments() {
            SKPaymentQueue.default().restoreCompletedTransactions()
        } else {
            self.userIsNotAbleToPurchase()
        }
    }
    
    public func checkUserSubsriptionStatus() {
        DispatchQueue.main.async {
            if let receipt = try? InAppReceipt.localReceipt() {
                self.checkUserPermanentSubsriptionStatus(with: receipt)
                
                for test in receipt.autoRenewablePurchases {
                    print("购买时间 \(test.originalPurchaseDate) 过期时间 \(test.subscriptionExpirationDate)")
                }
                receipt.
                print("有效订阅 \(receipt.hasActiveAutoRenewablePurchases)")
                
            }
        }
        
    }
    
    func refreshRecipt() {
        let receiptURL = Bundle.main.appStoreReceiptURL
        let receipt = NSData(contentsOf: receiptURL!)
        let requestContents: [String: Any] = [
            "receipt-data": receipt!.base64EncodedString(options: []),
            "password": "your iTunes Connect shared secret"
        ]

        let appleServer = receiptURL?.lastPathComponent == "sandboxReceipt" ? "sandbox" : "buy"

        let stringURL = "https://\(appleServer).itunes.apple.com/verifyReceipt"

        print("Loading user receipt: \(stringURL)...")

        Alamofire.request(stringURL, method: .post, parameters: requestContents, encoding: JSONEncoding.default)
            .responseJSON { response in
                if let value = response.result.value as? NSDictionary {
                    print(value)
                } else {
                    print("Receiving receipt from App Store failed: \(response.result)")
                }
        }
    }
    

    private func checkUserPermanentSubsriptionStatus(with receipt: InAppReceipt) {
        if let receipt = try? InAppReceipt.localReceipt() { //Check permsnent subscription
            
            if receipt.containsPurchase(ofProductIdentifier: PurchaseType.permanent.productID) {
                print("User has permament permission")
                if !AppEngine.shared.currentUser.isVip {
                    self.updateAfterAppPurchased(withType: .permanent)
                }
            } else {
                self.checkUserAutoRenewableSubsrption(with: receipt)
                
            }
            
        }
    }
    
    private func checkUserAutoRenewableSubsrption(with receipt: InAppReceipt) {
        if receipt.hasActiveAutoRenewablePurchases {
            print("Subsription still valid")
            if !AppEngine.shared.currentUser.isVip {
                let purchaseType = InAppPurchaseManager.shared.getUserPurchaseType()
                updateAfterAppPurchased(withType: purchaseType)
            }
        } else {
            print("Subsription expired")
            
            if AppEngine.shared.currentUser.isVip {
                self.subsrptionCheckFailed()
            }
        }
    }
    
  
    
    
    private func updateAfterAppPurchased(withType purchaseType: PurchaseType) {
        AppEngine.shared.currentUser.purchasedType = purchaseType
        AppEngine.shared.currentUser.energy += 5
        AppEngine.shared.userSetting.hasViewedEnergyUpdate = false
        AppEngine.shared.saveUser()
        AppEngine.shared.notifyAllUIObservers()
    }
    
    public func updateAfterEnergyPurchased() {
        AppEngine.shared.currentUser.energy += 3
        AppEngine.shared.saveUser()
        AppEngine.shared.notifyAllUIObservers()
    }
    
    public func purchaseApp(with purchaseType: PurchaseType, in viewController: SKPaymentTransactionObserver) {
        SKPaymentQueue.default().add(viewController)
        
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = purchaseType.productID
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            self.userIsNotAbleToPurchase()
        }
    }
    
    public func purchaseEnergy(in viewController: SKPaymentTransactionObserver) {
        SKPaymentQueue.default().add(viewController)
        let productID = "com.crazycat.Reborn.threePointOfEnergy"
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            self.userIsNotAbleToPurchase()
        }
    }
    

}

extension InAppPurchaseManager {
    public func purchaseAppFailed() {
        if let currentVC = UIApplication.shared.getTopViewController() {
            SystemAlert.present("购买失败", and: "请重新尝试，如有问题请在 个人中心-反馈 发送邮件", from: currentVC)
        }
    }
    
    public func purchaseEnergyFailed() {
        if let currentVC = UIApplication.shared.getTopViewController() {
            SystemAlert.present("购买失败", and: "请重新尝试，如有问题请在 个人中心-反馈 发送邮件", from: currentVC)
        }
    }
    
    public func puchaseEnergySuccessed() {
        if let currentVC = UIApplication.shared.getTopViewController() {
            SystemAlert.present("购买成功", and: "您获得了3点能量，快去使用时光机器吧", from: currentVC)
        }
        self.updateAfterEnergyPurchased()
    }
    
    public func puchaseAppSuccessed(withType purchaseType: PurchaseType) {
        if let currentVC = UIApplication.shared.getTopViewController() {
            SystemAlert.present("订阅成功", and: "所有内容已经解锁", from: currentVC)
            
        }
        self.updateAfterAppPurchased(withType: purchaseType)
       
    }
    
    public func subsrptionCheckFailed() {
        let currentVC = UIApplication.shared.getTopViewController()
        currentVC != nil ? SystemAlert.present("订阅验证失败", and: "请检查您的订阅", from: currentVC!) : ()
    
        AppEngine.shared.currentUser.purchasedType = .none
        AppEngine.shared.saveUser()
        AppEngine.shared.notifyAllUIObservers()
    }
    
    public func userIsNotAbleToPurchase() {
        if let currentVC = UIApplication.shared.getTopViewController() {
            SystemAlert.present("您暂时无法购买", and: "请检查您的账户设置", from: currentVC)
        }
        print("Can't make payments")
    }
}
