//
//  EnergySettingViewController.swift
//  Reborn
//
//  Created by Christian Liu on 18/3/21.
//

import UIKit

class EnergySettingViewController: UIViewController {

    @IBOutlet weak var dynamicEnergyIconView: UIView!
    @IBOutlet weak var hollowEnergyImageView: UIImageView!
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var energyButton: UIButton!
    @IBOutlet weak var efficiencyLabel: UILabel!
    @IBOutlet weak var newEnergyPromptLabel: UILabel!
    
    let engine: AppEngine = AppEngine.shared
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        if !engine.userSetting.hasViewedEnergyUpdate {
            fadeInOtherViews()
        }
        
        engine.userSetting.hasViewedEnergyUpdate = true
        engine.saveSetting()
        engine.notifyAllUIObservers()
        
    }
    
    func fadeInOtherViews() {
        
        UIView.animate(withDuration: 1, delay: 1, animations: {
            for subview in self.view.subviews {
                subview.alpha = 1
            }
        })
    }
    
    func excuteEnergyChargingAnimation() {
        
        
        let animationSpeed: TimeInterval = self.engine.currentUser.isVip ? 1.5 : 4.5
        self.rotateView(targetView: self.hollowEnergyImageView, duration: animationSpeed)
      
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
    
    private func rotateView(targetView: UIView, duration: Double = 1.0) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: -1/2 * CGFloat.pi)
        }) { finished in
            
            self.rotateView(targetView: targetView, duration: duration)
        }
    }
    
    func updateLabels() {
        self.energyButton.setTitle("× \(self.engine.currentUser.energy)", for: .normal)
        if self.engine.currentUser.isVip {
            self.efficiencyLabel.text = "效能：连续打卡7天 获得1点能量 (高级用户)"
        }
    }
    
    func updateButtons() {
       
        self.purchaseButton.setBackgroundColor(self.engine.userSetting.themeColor.uiColor, for: .normal)
        self.purchaseButton.setTitleColor(self.engine.userSetting.smartLabelColor, for: .normal)
    }

}

extension EnergySettingViewController: UIObserver {
    func updateUI() {
        
        updateButtons()
        updateLabels()
        
    }
    
    
}
