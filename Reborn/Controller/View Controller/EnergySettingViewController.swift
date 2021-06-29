//
//  EnergySettingViewController.swift
//  Reborn
//
//  Created by Christian Liu on 18/3/21.
//

import UIKit
import StoreKit
class EnergySettingViewController: UIViewController {

    @IBOutlet weak var howToRecheckButton: UIButton!
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
        
        howToRecheckButton.setTitleColor(engine.userSetting.smartVisibleThemeColor, for: .normal)
        newEnergyPromptLabel.textColor = ThemeColor.green.uiColor
        vipStrategy = EnergyStrategy(energySettingViewController: self)
        engine.add(observer: self)
  
        //excuteEnergyChargingAnimation()
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
        updatePurchaseButton()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        
        if !engine.userSetting.hasViewedEnergyUpdate {
            fadeInOtherViews()
        }
        
        engine.userSetting.hasViewedEnergyUpdate = true
        engine.saveSetting()
        //engine.notifyAllUIObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        engine.notifyUIObservers(withIdentifier: "UserCenterViewController")
    }
    
    @IBAction func purchaseButtonPressed(_ sender: Any) {
        Vibrator.vibrate(withImpactLevel: .medium)
        LoadingAnimation.add(to: self.view, withRespondingTime: 60, proportionallyOnYPosition: 0.38)
        self.titleLabel.text = "请勿离开界面"
        self.rotationSpeed = 0.5
        InAppPurchaseManager.shared.add(self)
        InAppPurchaseManager.shared.purchase(.energy)
        

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
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = -CGFloat.pi * 2
        rotationAnimation.duration = duration * 3
        rotationAnimation.repeatCount = .infinity
        targetView.layer.add(rotationAnimation, forKey: nil)
//        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
//            targetView.transform = targetView.transform.rotated(by: -1/2 * CGFloat.pi)
//        }) { finished in
//
//            self.rotateView(targetView: targetView, duration: self.rotationSpeed)
//        }
    }
    
    func updateLabels() {
        (self.vipStrategy as! EnergyStrategy).updateLabels()
    }
    
    func updateButtons() {
        self.purchaseButton.setSmartColor()
    }
    
    func updateNavigationBar() {
        self.setNavigationBarAppearance()
    }
    
    func updatePurchaseButton() {
        self.purchaseButton.setCornerRadius()
        self.purchaseButton.setSmartColor()
    }
}

extension EnergySettingViewController: UIObserver {
    func updateUI() {
        updateNavigationBar()
        updateButtons()
        updateLabels()
        updatePurchaseButton()
        excuteEnergyChargingAnimation()
    }
    
    
}

extension EnergySettingViewController: InAppPurchaseObserver {
    func puchaseSuccessed() {
        SystemAlert.present("购买成功", and: "您获得了3点能量，快去使用时光机器吧", from: self)
        self.rotationSpeed = (self.vipStrategy as! EnergyStrategy).getAnimationSpeed()
        self.titleLabel.text = "充能中"
        LoadingAnimation.remove()
    }
    
    func puchaseFailed() {
        SystemAlert.present("购买失败", and: "请重新尝试，如有问题请在 个人中心-反馈 发送邮件", from: self)
        self.rotationSpeed = (self.vipStrategy as! EnergyStrategy).getAnimationSpeed()
        LoadingAnimation.remove()
    }
    
    
}
