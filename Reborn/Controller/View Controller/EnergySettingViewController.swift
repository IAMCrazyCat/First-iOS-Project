//
//  EnergySettingViewController.swift
//  Reborn
//
//  Created by Christian Liu on 18/3/21.
//

import UIKit
import StoreKit
class EnergySettingViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dynamicEnergyIconView: UIView!
    @IBOutlet weak var hollowEnergyImageView: UIImageView!
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var energyButton: UIButton!
    @IBOutlet weak var efficiencyLabel: UILabel!
    @IBOutlet weak var newEnergyPromptLabel: UILabel!
    
    var rotationSpeed: TimeInterval = 1
    let engine: AppEngine = AppEngine.shared
    var vipStrategy: VIPStrategy!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newEnergyPromptLabel.textColor = ThemeColor.green.uiColor
        vipStrategy = EnergyStrategy(energySettingViewController: self)
        engine.add(observer: self)
  
        excuteEnergyChargingAnimation()
        updateUI()
        
        if !engine.userSetting.hasViewedEnergyUpdate {
            for subview in view.subviews {
                subview.alpha = 0
            }
            dynamicEnergyIconView.alpha = 1
        } else {
            newEnergyPromptLabel.alpha = 0
        }
        
    
        
    }
    
    override func viewDidLayoutSubviews() {
        purchaseButton.setCornerRadius()
        
    }
    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        self.updateUI()
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if !engine.userSetting.hasViewedEnergyUpdate {
            fadeInOtherViews()
        }
        
        engine.userSetting.hasViewedEnergyUpdate = true
        engine.saveSetting()
        engine.notifyAllUIObservers()
        
        
    }
    
    @IBAction func purchaseButtonPressed(_ sender: Any) {
        self.titleLabel.text = "请勿离开界面"
        purchaseEnergy()
    }
    
    func purchaseEnergy() {
        self.rotationSpeed = 0.5
        SKPaymentQueue.default().add(self)
        let productID = "com.crazycat.Reborn.threePointOfEnergy"
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            SystemAlert.present("您暂时无法购买", and: "请检查您的账户设置", from: self)
            print("Can't make payments")
        }
    }
    
    func PurchaseDidFinish() {
        self.engine.purchaseEnergy()
        SystemAlert.present("感谢您的购买", and: "您获得了3点能量", from: self)
        self.titleLabel.text = "充能中"
        
    }
    
    func fadeInOtherViews() {
        
        UIView.animate(withDuration: 1, delay: 1, animations: {
            for subview in self.view.subviews {
                subview.alpha = 1
            }
        })
    }
    
    func excuteEnergyChargingAnimation() {
        
        self.rotationSpeed = (self.vipStrategy as! EnergyStrategy).getAnimationSpeed()
        self.rotateView(targetView: self.hollowEnergyImageView, duration: self.rotationSpeed)
      
//        UIView.animateKeyframes(withDuration: animationSpeed, delay: 0, options: [.repeat], animations: {
//
//
//            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25, animations: {
//                self.hollowEnergyImageView.transform = CGAffineTransform(rotationAngle: -90.0 * CGFloat.pi/180.0)
//            })
//            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
//                self.hollowEnergyImageView.transform = CGAffineTransform(rotationAngle: -180.0 * CGFloat.pi/180.0)
//            })
//            UIView.addKeyframe(withRelativeStartTime: 0.50, relativeDuration: 0.25, animations: {
//                self.hollowEnergyImageView.transform = CGAffineTransform(rotationAngle: -270.0 * CGFloat.pi/180.0)
//            })
//            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25, animations: {
//                self.hollowEnergyImageView.transform = CGAffineTransform(rotationAngle: -360.0 * CGFloat.pi/180.0)
//            })
//
//
//        })
        
        
    }
    
    private func rotateView(targetView: UIView, duration: Double) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: -1/2 * CGFloat.pi)
        }) { finished in
            
            self.rotateView(targetView: targetView, duration: self.rotationSpeed)
        }
    }
    
    func updateLabels() {
        (self.vipStrategy as! EnergyStrategy).updateLabels()
    }
    
    func updateButtons() {
        self.purchaseButton.setSmartColor()
    }
    
    func updateNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor: engine.userSetting.smartLabelColorAndWhiteAndThemeColor]
    }
}

extension EnergySettingViewController: UIObserver {
    func updateUI() {
        updateNavigationBar()
        updateButtons()
        updateLabels()
        
    }
    
    
}

extension EnergySettingViewController: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                
                print("Thanks for shopping")
                SKPaymentQueue.default().finishTransaction(transaction)
                self.rotationSpeed = (self.vipStrategy as! EnergyStrategy).getAnimationSpeed()
                self.PurchaseDidFinish()
                
                
            } else if transaction.transactionState == .failed {
                print("Transaction Failed!")
                SystemAlert.present("购买失败", and: "如有问题请回到个人中心发送反馈邮件，我们会尽快解决", from: self)
                SKPaymentQueue.default().finishTransaction(transaction)
                self.rotationSpeed = (self.vipStrategy as! EnergyStrategy).getAnimationSpeed()
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print(errorDescription)
                }
            }
        }
    }
}
