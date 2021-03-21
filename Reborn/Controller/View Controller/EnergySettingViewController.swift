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
    
    let engine: AppEngine = AppEngine.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        engine.add(observer: self)
        
        for subview in view.subviews {
            subview.alpha = 0
        }
        dynamicEnergyIconView.alpha = 1
        
        updateUI()
        
        
        //dynamicEnergyIconView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
//        dynamicEnergyIconView.translatesAutoresizingMaskIntoConstraints = false
//        dynamicEnergyIconView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 80).isActive = true
//        dynamicEnergyIconView.heightAnchor.constraint(equalTo: dynamicEnergyIconView.widthAnchor).isActive = true
//        dynamicEnergyIconView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        dynamicEnergyIconView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        purchaseButton.setCornerRadius()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//        UIView.animate(withDuration: 2, delay: 1, animations: {
//            self.dynamicEnergyIconView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
//            self.dynamicEnergyIconView.frame.origin.y = 0
//            self.dynamicEnergyIconView.frame.origin.x = 0
//
//        })
        
        UIView.animate(withDuration: 1, delay: 1, animations: {
            for subview in self.view.subviews {
                subview.alpha = 1
            }
        })
        
        var animationSpeed: TimeInterval = self.engine.currentUser.vip ? 5 : 10

      
        UIView.animateKeyframes(withDuration: animationSpeed, delay: 0, options: [.repeat], animations: {

            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25, animations: {
                self.hollowEnergyImageView.transform = CGAffineTransform(rotationAngle: -90.0 * CGFloat.pi/180.0)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
                self.hollowEnergyImageView.transform = CGAffineTransform(rotationAngle: -180.0 * CGFloat.pi/180.0)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.50, relativeDuration: 0.25, animations: {
                self.hollowEnergyImageView.transform = CGAffineTransform(rotationAngle: -270.0 * CGFloat.pi/180.0)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25, animations: {
                self.hollowEnergyImageView.transform = CGAffineTransform(rotationAngle: -360.0 * CGFloat.pi/180.0)
            })
            

        })
    }
    

}

extension EnergySettingViewController: UIObserver {
    func updateUI() {
        
        self.energyButton.setTitle("× \(self.engine.currentUser.keys)", for: .normal)
        if self.engine.currentUser.vip {
            self.efficiencyLabel.text = "效能：连续打卡7天 获得1点能量 (高级用户)"
        }
    }
    
    
}
