//
//  SelfDisciplineToolsViewController.swift
//  Reborn
//
//  Created by Christian Liu on 31/3/21.
//

import UIKit

class SelfDisciplineToolsViewController: UIViewController {

    
    let setting: SystemSetting = SystemSetting.shared
    let engine: AppEngine = AppEngine.shared
    
    @IBOutlet var toolLabels: [UILabel]!
    @IBOutlet var tomatoClockButton: UIButton!
    
    @IBOutlet var toolButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppEngine.shared.add(observer: self)
        AdStrategy().addAd(to: self)
        updateUI()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    func adjustLabelSizeToFit() {
        for label in toolLabels {
            label.adjustsFontSizeToFitWidth = true
        }
    }
    
    func updateToolButtons() {
        
        for button in toolButtons {
            button.layoutIfNeeded()
            button.layer.cornerRadius = button.frame.height / 8
            button.setShadow()
        }
    }
   
    func updateNavigationBar() {
        self.setNavigationBarAppearance()
    }
    
    @IBAction func toolButtonTouchDown(_ sender: UIButton) {
        Vibrator.vibrate(withImpactLevel: .medium)
        UIView.animate(withDuration: 0.1, animations: {
            sender.superview?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            
        })
    }
    
    @IBAction func toolButtonTouchUpInside(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2, animations: {
            sender.superview?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }) { _ in
            
            switch sender.tag {
            case 1: self.pushViewController(withIentifier: "TomatoClockViewController")
            case 2: self.pushViewController(withIentifier: "BreathViewController")
            case 3: break
            default: break
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                   sender.superview?.transform = CGAffineTransform(scaleX: 0.99, y: 0.99)
               }) { _ in
                
                UIView.animate(withDuration: 0.1) {
                    sender.superview?.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
                
            }
        }

    }
    
    
    
    

}

extension SelfDisciplineToolsViewController: UIObserver {
    
    func updateUI() {
        adjustLabelSizeToFit()
        updateNavigationBar()
        updateToolButtons()
        AdStrategy().removeAd(from: self)
    }
    
    
}
