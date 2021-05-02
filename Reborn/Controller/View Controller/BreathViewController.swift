//
//  BreathViewController.swift
//  Reborn
//
//  Created by Christian Liu on 31/3/21.
//

import UIKit
enum BreathingState {
    case breathing
    case normal
}

class BreathViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var heartImageView: UIImageView!
    @IBOutlet var startBreathingButton: UIButton!
    @IBOutlet var guidingLabel: UILabel!
    @IBOutlet var verticalContentView: UIView!
    
    @IBOutlet var introductionTextView: UITextView!
    @IBOutlet var circleView: UIView!
    
    var stopInitialAnimation: Bool = false
    var state: BreathingState = .normal
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidLayoutSubviews() {
        updateStartBreathButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //excuteCircleAnimation()
        //excuteHeartThrobingAnimation()
    }
    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        self.updateUI()
//    }
    
    @IBAction func startBreathingButtonPressed(_ sender: Any) {
        Vibrator.vibrate(withImpactLevel: .medium)
        startBreathing()
        
        updateUI()
    }
    
    
    
    func startBreathing() {
        self.state = .breathing
        self.stopInitialAnimation = true
       
        
        let _: TimeInterval = 70

        UIView.animate(withDuration: 3, delay: 0, options: .curveEaseOut, animations: {
            self.guidingLabel.text = "调整呼吸节奏"
            self.heartImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            
            UIView.animate(withDuration: 7, animations: {
                self.guidingLabel.text = "放空大脑，注意力集中在呼吸上"
                self.heartImageView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            }) { _ in
                self.inhaleAndExhale(withNumberOfHales: 10)
            }
   
        }

    }
    
    func inhaleAndExhale(withNumberOfHales numberOfHales: Int) {
        
        let haleDuration: TimeInterval = 5
        self.guidingLabel.text = "吸气"
        Vibrator.vibrate(withImpactLevel: .heavy)
        for i in 0 ... numberOfHales {
            
            if i % 2 == 0 {
                UIView.animate(withDuration: haleDuration, delay: Double(i) * haleDuration , options: [.curveEaseInOut], animations: {
                    self.heartImageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                }) { _ in
                    self.guidingLabel.text = "呼气"
                    Vibrator.vibrate(withImpactLevel: .heavy)
                }
            } else {
                UIView.animate(withDuration: haleDuration, delay: Double(i) * haleDuration, options: [.curveEaseInOut], animations: {
                    self.heartImageView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                }) { _ in
                    self.guidingLabel.text = "吸气"
                    Vibrator.vibrate(withImpactLevel: .heavy)
                }
            }
            
        }
        
        UIView.animate(withDuration: 2, delay: Double(numberOfHales + 1) * haleDuration, options: [], animations: {
            self.heartImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            
        }) { _ in
            self.guidingLabel.text = "呼吸完成"
            Vibrator.vibrate(withNotificationType: .success)
            self.state = .normal
            self.updateUI()
        }
    }
 


    
    
    
    func excuteCircleAnimation() {
        
        if !self.stopInitialAnimation {
            
            UIView.animate(withDuration: 3, animations: {
                self.heartImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }) { _ in
                UIView.animate(withDuration: 3, animations: {
                    self.heartImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }) { _ in
                    
                        self.excuteCircleAnimation()
                    
                }
            }
        }
    }
    
    func excuteHeartThrobingAnimation() {
        UIView.animate(withDuration: 0.6, animations: {
            self.heartImageView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.heartImageView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }) { _ in
                self.excuteHeartThrobingAnimation()
            }
        }
    }
    
    func updateBreathingView() {
        
        if self.state == .breathing {
            UIView.animate(withDuration: 5, animations: {
                self.titleLabel.alpha = 0
                self.view.backgroundColor = AppEngine.shared.userSetting.blackBackground
                self.verticalContentView.backgroundColor = AppEngine.shared.userSetting.blackBackground
                self.introductionTextView.alpha = 0
                self.introductionTextView.backgroundColor = AppEngine.shared.userSetting.blackBackground
                self.guidingLabel.textColor = .white
                self.introductionTextView.backgroundColor = AppEngine.shared.userSetting.blackBackground
            })
        } else {
            UIView.animate(withDuration: 5, animations: {
                self.titleLabel.alpha = 1
                self.view.backgroundColor = AppEngine.shared.userSetting.whiteAndBlackBackground
                self.verticalContentView.backgroundColor = AppEngine.shared.userSetting.whiteAndBlackBackground
                self.introductionTextView.backgroundColor = AppEngine.shared.userSetting.whiteAndBlackBackground
                self.introductionTextView.alpha = 1
                self.guidingLabel.textColor = .label
                self.introductionTextView.backgroundColor = AppEngine.shared.userSetting.whiteAndBlackBackground
            })
        }
        
    }
    
    func updateStartBreathButton() {
        
        startBreathingButton.setCornerRadius()
        startBreathingButton.setSmartColor()
        
        startBreathingButton.setTitle(self.state == .breathing ? "呼吸中..." : "开始呼吸", for: .normal)
    }
    


}

extension BreathViewController: UIObserver {
    func updateUI() {
        updateBreathingView()
        updateStartBreathButton()
    }
}
