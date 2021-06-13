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
import Alamofire
import SwiftyStoreKit
import Purchases

protocol InAppPurchaseObserver {
    func puchaseSuccessed()
    func puchaseFailed()
}

class InAppPurchaseManager {
    static var shared = InAppPurchaseManager()
    private var observers = [InAppPurchaseObserver]()
    let sharedSecret = "2add70b904c74e33bf3bdc9681d34b67"
    
    var packages: Array<Purchases.Package> = []
//    var oneMonthPackage: Purchases.Package? = nil
//    var oneYearPackage: Purchases.Package? = nil
//    var permanentPackage: Purchases.Package? = nil
//    var energyPackage: Purchases.Package? = nil
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
    
    func getPriceOf(_ purchaseType: PurchaseType) -> Double? {
        var pakageForFetch: Purchases.Package?
        for pakage in self.packages {
            print(pakage.product.productIdentifier)
            if pakage.product.productIdentifier == purchaseType.productID{
                pakageForFetch = pakage
            }
        }
        if let price = pakageForFetch?.product.price {
            return Double(truncating: price)
        } else {
            return nil
        }
    }
    
    func getLocalCurrencySymbolOf(_ purchaseType: PurchaseType) -> String? {
        var pakageForFetch: Purchases.Package?
        for pakage in self.packages {
            print(pakage.product.productIdentifier)
            if pakage.product.productIdentifier == purchaseType.productID{
                pakageForFetch = pakage
            }
        }
        
        if let price = pakageForFetch?.localizedPriceString {
            var symbol = ""
            var foundSymbol = false
            for i in price {
                if foundSymbol {
                    symbol += i.description
                }
                
                if i == " " {
                    foundSymbol = true
                }
                
            }
            return symbol
        } else {
            return nil
        }
    }
    
    
    func add(_ observer: InAppPurchaseObserver) {
        self.observers.append(observer)
    }
    
    func deleteAll() {
        self.observers.removeAll()
    }
    
    func fetchOfferingFromRevenueCat() {
        Purchases.shared.offerings { (offerings, error) in
            if let offerings = offerings {
              // Display current offering with offerings.current
                let pacakges = offerings.current?.availablePackages
                guard pacakges != nil else { return }
                
                for index in 0 ... pacakges!.count - 1 {
                    let pakage = pacakges![index]
                    let product = pakage.product
//                    let title = product.localizedTitle
//                    let price = product.price
//                    var duration = ""
//                    let subscriptionPeriod = product.subscriptionPeriod
                    
                    self.packages.append(pakage)

                }
                    
            }
        }
    }
    
    
    public func restorePurchase() {
        Purchases.shared.restoreTransactions { (purchaserInfo, error) in
            if purchaserInfo?.entitlements["pro"]?.isActive == true {
                
                self.updateAfterAppPurchased(withType: self.getUserPurchaseType())
                
            } else {
                self.notifyAllObservers(withState: .failed)
            }
        }
    }
    
 
    
    func finishPendingTransactions() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                        print("Pending transaction \(purchase.productId) finished")
                    }
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break
                }
            }
            self.checkUserSubsriptionStatus()
        }
    }
    
    public func checkUserSubsriptionStatus() {
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            guard purchaserInfo != nil else {
                return
                
            }
            
            var transactionIDs = [String]()
            for transcation in purchaserInfo!.nonSubscriptionTransactions {
                transactionIDs.append(transcation.productId)
            }
            
            print("History non-consumable transcations \(transactionIDs)")
            
            if transactionIDs.contains(PurchaseType.permanent.productID) {
                self.subsrptionCheckSuccessed(withPurchasedType: .permanent)
                print("User has permanent subscription")
            } else {
                let activeSubscriptions = purchaserInfo!.activeSubscriptions
                if activeSubscriptions.contains(PurchaseType.oneYear.productID) {
                    self.subsrptionCheckSuccessed(withPurchasedType: .oneYear)
                    print("User has valid annual subscription")
                } else if activeSubscriptions.contains(PurchaseType.oneMonth.productID) {
                    self.subsrptionCheckSuccessed(withPurchasedType: .oneMonth)
                    print("User has valid monthly subscription")

                } else {
                    print("User subscription expired")
                    self.subsrptionCheckFailed()
                }
                
                
                
            }
           
            
        }
    }
    
    func notifyAllObservers(withState state: SKPaymentTransactionState) {
        for observer in self.observers {
            if state == .purchased {
                observer.puchaseSuccessed()
            } else if state == .failed {
                observer.puchaseFailed()
            }
            
        }
        self.deleteAll()
    }
    
    private func updateAfterAppPurchased(withType purchaseType: PurchaseType) {
        self.notifyAllObservers(withState: .purchased)
        AppEngine.shared.currentUser.purchasedType = purchaseType
        AppEngine.shared.currentUser.energy += 5
        AppEngine.shared.userSetting.hasViewedEnergyUpdate = false
        AppEngine.shared.saveUser()
        self.notifyAllObservers(withState: .purchased)
        AppEngine.shared.notifyAllUIObservers()
    }
    
    public func updateAfterEnergyPurchased() {
        self.notifyAllObservers(withState: .purchased)
        AppEngine.shared.currentUser.energy += 3
        AppEngine.shared.saveUser()
        AppEngine.shared.notifyAllUIObservers()
    }
    
    public func purchase(_ purchaseType: PurchaseType) {
        
        var pakageForPurchase: Purchases.Package?
        for pakage in self.packages {
            print(pakage.product.productIdentifier)
            if pakage.product.productIdentifier == purchaseType.productID{
                pakageForPurchase = pakage
            }
        }
        guard pakageForPurchase != nil else {
           return
        }
        
        switch purchaseType {
        case .oneMonth, .oneYear, .permanent:
            
            Purchases.shared.purchasePackage(pakageForPurchase!) { (transaction, purchaserInfo, error, userCancelled) in
              if purchaserInfo?.entitlements["pro"]?.isActive == true {
                self.updateAfterAppPurchased(withType: purchaseType)
                
              } else {
                self.notifyAllObservers(withState: .failed)
              }
            }
        case .energy:

            Purchases.shared.purchasePackage(pakageForPurchase!) { (transaction, purchaserInfo, error, userCancelled) in
              if purchaserInfo?.entitlements["consumable"]?.isActive == true {
                self.updateAfterEnergyPurchased()
                self.notifyAllObservers(withState: .purchased)
              } else {
                self.notifyAllObservers(withState: .failed)
              }
            }
        default: self.notifyAllObservers(withState: .failed)
        }
        
    }
    
    private func subsrptionCheckFailed() {
        
        if AppEngine.shared.currentUser.isVip {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                let currentVC = UIApplication.shared.getCurrentViewController()
                currentVC != nil ? SystemAlert.present("订阅验证失败", and: "请检查您的订阅", from: currentVC!) : ()
            })
            
        
            AppEngine.shared.currentUser.purchasedType = .none
            AppEngine.shared.saveUser()
            AppEngine.shared.notifyAllUIObservers()
        }
       
    }
    
    private func subsrptionCheckSuccessed(withPurchasedType purchasedType: PurchaseType) {

        if !AppEngine.shared.currentUser.isVip {
            self.updateAfterAppPurchased(withType: purchasedType)
        }
    }
    
    public func userIsNotAbleToPurchase() {
        if let currentVC = UIApplication.shared.getCurrentViewController() {
            SystemAlert.present("您暂时无法购买", and: "请检查您的账户设置", from: currentVC)
        }
        print("Can't make payments")
    }

}
