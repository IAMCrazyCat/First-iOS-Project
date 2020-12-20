//
//  SetUpViewController.swift
//  Reborn
//
//  Created by Christian Liu on 19/12/20.
//

import UIKit

class SetUpViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var nextStepButton: UIButton!
    @IBOutlet weak var middleScrollView: UIScrollView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var engine = SetUpEngine()
    var setting = StyleSetting()
    
    var middleViewX: CGFloat?
    var middleViewY: CGFloat?
    var middleViewWidth: CGFloat?
    var middleViewHeight: CGFloat?
    
    var scrollViewWidth: CGFloat = 0
    var currentPageX: CGFloat = 0
    
    var backButtonPressed = false
    var numberOfPagedAdded = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.middleView.frame = CGRect(x: middleView.frame.origin.x, y: middleView.frame.origin.y, width: view.frame.width, height: middleView.frame.height)
        self.middleViewX = self.middleView.frame.origin.x
        self.middleViewY = self.middleView.frame.origin.y
        self.middleViewWidth = self.middleView.frame.width
        self.middleViewHeight = self.middleView.frame.height
        
        
        //questionLabel.font = questionLabel.font.withSize(setting.FontNormalSize)
        questionLabel.font = setting.questionLabelFont
        nextStepButton.layer.cornerRadius = setting.mainButtonCornerRadius
        
        addAllPages()
        updateUI()
    }
    
    @IBAction func nextStepButtonPressed(_ sender: UIButton) {
        engine.nextPage()
        updateUI()
    }
    
    @IBAction func previousStepButtonPressed(_ sender: UIButton) {
        engine.previousPage()
        updateUI()
    }
    
    
    func updateButtons() { // Adding a new page to scrollview
        

       
        let page = UIView(frame: CGRect(x: currentPageX, y: 0, width: middleViewWidth!, height: middleViewHeight!))

        var column = 1
        var buttonX: CGFloat
        var buttonY: CGFloat = -setting.optionButtonVerticalDistance
        
        
        self.currentPageX += page.frame.width
        self.scrollViewWidth += page.frame.width
 
        self.middleScrollView.addSubview(page)
        
        for buttonName in self.engine.getCurrentPage().buttons {
            let button: UIButton
            
            if column == 1 {
                buttonX = page.frame.width / 2.0 - self.setting.optionButtonWidth - self.setting.optionButtonHorizontalDistance / 2.0
                buttonY += self.setting.optionButtonVerticalDistance + self.setting.optionButtonHeight
                column += 1
                
            } else {
                buttonX = page.frame.width / 2 + self.setting.optionButtonHorizontalDistance / 2
                column = 1
            }
         
           
            button = UIButton(frame: CGRect(x: buttonX, y: buttonY, width: self.setting.optionButtonWidth, height: self.setting.optionButtonHeight))
            button.setTitle(buttonName, for: .normal)
            button.setTitleColor(self.setting.optionButtonTitleColor, for: .normal)
            button.setBackgroundImage(self.setting.optionButtonBgImage, for: .normal)
            button.titleLabel?.font = self.setting.optionButtonTitleFont
            page.addSubview(button)
        }
        
       
        self.middleScrollView.contentSize = CGSize(width: self.scrollViewWidth, height: self.middleViewHeight!) // set size

    }
    
    func addAllPages() {
        
        for _ in 0 ..< engine.getPagesCount() {
            
            updateButtons()
            engine.nextPage()
        }
        
        engine.progress = 1
    }
        
    func updateUI() {
        questionLabel.text = engine.getCurrentPage().question
        
        
        middleScrollView.setContentOffset(CGPoint(x: middleViewWidth! * CGFloat(engine.progress) - middleViewWidth!, y: 0), animated: true) // Update Buttons page
        

        UIView.animate(withDuration: setting.progressBarAnimationSpeed) {
            self.progressView.setProgress(Float(self.engine.progress) / Float(self.engine.getPagesCount()), animated: true)
        }
        
    }
    
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


