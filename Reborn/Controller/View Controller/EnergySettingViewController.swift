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
        Vibrator.vibrate(withImpactLevel: .medium)
        LoadingAnimation.add(to: self.view, withRespondingTime: 120, proportionallyOnYPosition: 0.38)
        self.titleLabel.text = "请勿离开界面"
        self.rotationSpeed = 0.5
        InAppPurchaseManager.shared.purchaseEnergy(in: self)

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
            print(transaction)
            if transaction.transactionState == .purchased {
                
                print("Thanks for shopping")
                InAppPurchaseManager.shared.puchaseEnergySuccessed()
                
                
                self.rotationSpeed = (self.vipStrategy as! EnergyStrategy).getAnimationSpeed()
                self.titleLabel.text = "充能中"
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                LoadingAnimation.remove()
                
            } else if transaction.transactionState == .failed {
                print("Transaction Failed!")
                InAppPurchaseManager.shared.purchaseEnergyFailed()

                self.rotationSpeed = (self.vipStrategy as! EnergyStrategy).getAnimationSpeed()
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print(errorDescription)
                }
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                LoadingAnimation.remove()
            }
            
        }
        
    }
}
