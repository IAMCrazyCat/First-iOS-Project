//
//  ViewController.swift
//  Reborn
//
//  Created by Christian Liu on 16/12/20.
//

import UIKit

class WelcomViewController: UIViewController {

    @IBOutlet weak var welcomeTextLabel: UILabel!
    @IBOutlet weak var welcomeTextLabelTwo: UILabel!
    @IBOutlet weak var promtLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var relevantImageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    var timer: Timer?
    var progressNum = 1
    let welcomeTextArray = [
        "欢迎来到重生，\n改变从今天开始",
        "你是否，\n被某种瘾困扰着，\n久久不能自拔",
        "一根香烟，一把游戏，\n一次手瘾，一次懒觉，\n一次熬夜，一次拖延，\n一次酒精的诱惑...",
        "有的时候你会发现，\n\n大脑就好像一个不受控制的小精灵，\n一直追求着那些让它自己快乐的快感...\n\n想坚持的事，大脑却不断地提醒你，\n这很痛苦，我不要去做...",
        "但是，自由，\n不是随心所欲，\n而是自我主宰"
    ]
    let welcomeTextArrayTwo = ["自律即是自由，\n期待遇见更好的你"]
    let progressTwoImageArray: Array<UIImage> = [#imageLiteral(resourceName: "Cigratte"), #imageLiteral(resourceName: "Game"), #imageLiteral(resourceName: "Musturbate")]
    var progressTwoImageNum = 0
    
    var setting = StyleSetting()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        progressLabel.font = progressLabel.font.withSize(setting.FontNormalSize) // Initialize Style settings
        startButton.layer.cornerRadius = setting.mainButtonCornerRadius
        
        welcomeTextLabel.alpha = 0
        welcomeTextLabelTwo.alpha = 0
        promtLabel.alpha = 0
        relevantImageView.alpha = 0
        promtLabel.alpha = 0
        skipButton.isHidden = true
        
        
        startButton.alpha = 0
        startButton.isHidden = true
        updateUI()
    }
    

    
    func switchProgressTwoImage() {
        
       
        UIView.animate(withDuration: 2, animations: {
            
            if self.progressNum == 3 {
                self.relevantImageView.image = self.progressTwoImageArray[self.progressTwoImageNum]
                self.relevantImageView.alpha = 1
            }
        }, completion: { finished in
            
            if self.progressTwoImageNum < self.progressTwoImageArray.count - 1 {
                
                self.progressTwoImageNum += 1
            } else {
                self.progressTwoImageNum = 0
            }
            
            if self.progressNum == 3 {
            
                self.relevantImageView.alpha = 0
               
                self.switchProgressTwoImage()
            }
        })

        
       
    }
    

    @IBAction func screenButtonPressed(_ sender: UIButton) {
        
        if progressNum < 5 {
            progressNum += 1
            updateUI()
        }
    }
    
    @IBAction func skipButtonPressed(_ sender: UIButton) {
        progressNum = 5
        updateUI()
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToSetUpView", sender: self)
    }
    
    func updateUI() {
        
        welcomeTextLabel.alpha = 0
        welcomeTextLabel.text = self.welcomeTextArray[self.progressNum - 1]
        UIView.animate(withDuration: 3, animations: {
            self.welcomeTextLabel.alpha = 1
        })
        
        progressLabel.text = "\(progressNum)/5"
        
        switch progressNum {
        case 1:
            UIView.animate(withDuration: 3, animations: {
                self.welcomeTextLabel.alpha = 1
            })
            
            UIView.animate(withDuration: 5, animations: {
                self.promtLabel.alpha = 1
                
            }, completion: { finish in
                
                UIView.animate(withDuration: 2, animations: {
                    self.promtLabel.alpha = 0
                    
                }) })
           
        case 2:
            skipButton.isHidden = false
        case 3:
            switchProgressTwoImage()
        case 4:
            relevantImageView.image = #imageLiteral(resourceName: "Brain")
            relevantImageView.alpha = 1
        case 5:
            relevantImageView.isHidden = true
            skipButton.isHidden = true
            welcomeTextLabelTwo.text = welcomeTextArrayTwo[0]
            UIView.animate(withDuration: 4, animations: {
                self.welcomeTextLabelTwo.alpha = 1
            })
            UIView.animate(withDuration: 4, animations: {
                self.startButton.isHidden = false
                self.startButton.alpha = 1
            })
        
        default: print("error")
        }
       
    }
}

