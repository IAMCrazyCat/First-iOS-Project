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
    @IBOutlet weak var skipSetUpButton: UIButton!
    
    var engine = SetUpEngine()
    var setting = SystemStyleSetting()
    
    var middleViewX: CGFloat?
    var middleViewY: CGFloat?
    var middleViewWidth: CGFloat?
    var middleViewHeight: CGFloat?
    
    var scrollViewWidth: CGFloat = 0
    var currentPageX: CGFloat = 0
    
    var backButtonPressed = false
    var numberOfPagedAdded = 0
    var selectedButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        middleView.frame = CGRect(x: middleView.frame.origin.x, y: middleView.frame.origin.y, width: view.frame.width, height: middleView.frame.height)
        middleViewX = middleView.frame.origin.x
        middleViewY = middleView.frame.origin.y
        middleViewWidth = middleView.frame.width
        middleViewHeight = middleView.frame.height
        
        //questionLabel.font = questionLabel.font.withSize(setting.FontNormalSize)
        questionLabel.font = setting.questionLabelFont
        nextStepButton.layer.cornerRadius = setting.mainButtonCornerRadius
        nextStepButton.isEnabled = false
        addAllPages()
        updateUI()
    }
    
    @IBAction func nextStepButtonPressed(_ sender: UIButton) {
        
        if nextStepButton.currentTitle == setting.finishButtonTitle {
            self.engine.saveData()
            self.performSegue(withIdentifier: "goToHomeView", sender: self)
        }
        
        self.engine.processSlectedData(buttonTitle: self.selectedButton.currentTitle!)
        self.nextStepButton.isEnabled = false
        self.engine.nextPage()
        self.updateUI()
    }
    
    @IBAction func previousStepButtonPressed(_ sender: UIButton) {
        
        self.selectedButton.isSelected = false
        self.nextStepButton.isEnabled = false
        self.engine.previousPage()
        self.updateUI()
    }
    
    @IBAction func skipSetUpButtonPressed(_ sender: UIButton) {
        
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
            
            if column == 1 { // left side buttons
                buttonX = page.frame.width / 2.0 - self.setting.optionButtonWidth - self.setting.optionButtonHorizontalDistance / 2.0
                buttonY += self.setting.optionButtonVerticalDistance + self.setting.optionButtonHeight
                column += 1
                
            } else { // right side buttons
                buttonX = page.frame.width / 2 + self.setting.optionButtonHorizontalDistance / 2
                column = 1
            }
         
           
            button = UIButton(frame: CGRect(x: buttonX, y: buttonY, width: self.setting.optionButtonWidth, height: self.setting.optionButtonHeight))
            // Button's properties
            button.setTitle(buttonName, for: .normal)
            button.setTitleColor(self.setting.optionButtonTitleColor, for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.setTitleColor(UIColor.white, for: .selected)
            
            button.setBackgroundImage(self.setting.optionButtonBgImage, for: .normal)
            button.setBackgroundImage(self.setting.optionButtonPressedBgImage, for: .highlighted)
            button.setBackgroundImage(self.setting.optionButtonPressedBgImage, for: .selected)
            
            button.titleLabel?.font = self.setting.optionButtonTitleFont
            button.addTarget(self, action: #selector(optionButtonPressed), for: .touchDown)

            
            page.addSubview(button)

        }
        
       
        self.middleScrollView.contentSize = CGSize(width: self.scrollViewWidth, height: self.middleViewHeight!) // set size

    }
    
    @objc func optionButtonPressed(sender: UIButton! ) { // option button selected action
        

        self.nextStepButton.isEnabled = true
        self.selectedButton.isSelected = false
        self.selectedButton = sender
        
        sender.isSelected = !sender.isSelected
       
        print(sender.currentTitle!)
        updateUI()
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
        middleScrollView.setContentOffset(CGPoint(x: middleViewWidth! * CGFloat(engine.progress) - middleViewWidth!, y: 0), animated: true) //Slide to right Buttons page
        

        UIView.animate(withDuration: setting.progressBarAnimationSpeed) {
            self.progressView.setProgress(Float(self.engine.progress) / Float(self.engine.getPagesCount()), animated: true)
        }
        
//        if nextStepButton.isEnabled {
//            nextStepButton.backgroundColor = UIColor(named: "ThemeColor")
//        } else {
//            nextStepButton.backgroundColor = UIColor(named: "ButtonGray")
//        }
        
        nextStepButton.backgroundColor = nextStepButton.isEnabled ? UIColor(named: "ThemeColor"): UIColor(named: "ButtonGray") 
        
        if engine.progress == engine.getPagesCount() {
            nextStepButton.setTitle(setting.finishButtonTitle, for: .normal)
     
        } else {
            nextStepButton.setTitle(setting.nextStepButtonTitle, for: .normal)

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


