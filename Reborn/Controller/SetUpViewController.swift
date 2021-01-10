//
//  SetUpViewController.swift
//  Reborn
//
//  Created by Christian Liu on 19/12/20.
//

import UIKit

class SetUpViewController: UIViewController{
    
    

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var nextStepButton: UIButton!
    @IBOutlet weak var middleScrollView: UIScrollView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var skipSetUpButton: UIButton!
    
    var engine = SetUpEngine()
    var setting = SystemStyleSetting()
    

    
    var scrollViewWidth: CGFloat = 0
    var backButtonPressed = false
    var numberOfPagedAdded = 0
    var selectedButton: UIButton = UIButton()
    
    var itemIsSkipped: Bool = false
    static let optionButtonAction = #selector(optionButtonPressed)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        middleView.frame = CGRect(x: middleView.frame.origin.x, y: middleView.frame.origin.y, width: view.frame.width, height: middleView.frame.height)

        questionLabel.font = setting.questionLabelFont
        nextStepButton.layer.cornerRadius = setting.mainButtonCornerRadius
        nextStepButton.isEnabled = false
        
        //addAllPages()
        updateButtons()
        updateUI()
       
    }
    
//    func addAllPages() {
//
//        for _ in 0 ..< engine.getPagesCount() {
//
//            updateButtons()
//            engine.nextPage()
//        }
//
//        engine.progress = 1
//    }
    
    func updateButtons() { // Adding a new page to scrollview
        
        middleView = engine.loadSetUpPages(controller: self)
       
    }
    
   
    
    @IBAction func nextStepButtonPressed(_ sender: UIButton) {

        if nextStepButton.currentTitle == setting.finishButtonTitle {
            self.engine.processSlectedData(pressedButton: self.selectedButton)
            self.engine.createUser(setUpIsSkipped: false)
            self.goToHomeView()
            
        } else if selectedButton.currentTitle == self.setting.skipButtonTitle {
            
            self.engine.nextPage()
            self.engine.nextPage()
            self.deSelectButton()
            self.itemIsSkipped = true
            
        } else {
            
            self.engine.processSlectedData(pressedButton: self.selectedButton)
            self.engine.nextPage()
            self.deSelectButton()
            self.itemIsSkipped = false

        }
        
    }
    
    @IBAction func previousStepButtonPressed(_ sender: UIButton) {
        
        if itemIsSkipped {
            
            self.engine.previousPage()
            self.engine.previousPage()
            self.deSelectButton()
            //
        } else {
            
            self.engine.previousPage()
            self.deSelectButton()
        }
       

    }
    
    func selectButton(button: UIButton) {
        
        self.nextStepButton.isEnabled = true
        self.selectedButton.isSelected = false // old selected button become white
        self.selectedButton = button
        button.isSelected = !button.isSelected
        updateUI()
  
    }
    
    
    func deSelectButton() {
        self.selectedButton.isSelected = false
        self.nextStepButton.isEnabled = false
        self.updateUI()
    }
    
    
    @IBAction func skipSetUpButtonPressed(_ sender: UIButton) {
        self.engine.processSlectedData(pressedButton: self.selectedButton)
        self.engine.createUser(setUpIsSkipped: true)
        self.goToHomeView()
    }
    
    
    @objc func optionButtonPressed(_ sender: UIButton! ) { // option button selected action
        print(sender.tag)
        if sender.tag == self.setting.customItemNameButtonTag {
            
            self.showPopUpView(popUpType: .customItemName)
            
        } else if sender.tag == self.setting.customTargetDaysButtonTag {

            self.showPopUpView(popUpType: .customTargetDays)
        }
        
        self.selectButton(button: sender)
        
        
    }
    
    
    func showPopUpView(popUpType: PopUpType) {

        self.engine.showPopUp(popUpType: popUpType, controller: self)

    }
    
    @IBAction func skipButtonPressed(_ sender: UIButton) {
        goToHomeView()
    }
    
    
    func goToHomeView() {
        
        self.performSegue(withIdentifier: "goToHomeView", sender: self)
    }
    
    func updateUI() {
        // Update question label
        questionLabel.text = engine.getCurrentPage().question
        
        //Slide to right Buttons page
        middleScrollView.setContentOffset(CGPoint(x: middleView.frame.width * CGFloat(engine.progress) - middleView.frame.width, y: 0), animated: true)
        
        // animate progress bar
        UIView.animate(withDuration: setting.progressBarAnimationSpeed) {
            self.progressView.setProgress(Float(self.engine.progress) / Float(self.engine.getPagesCount()), animated: true)
        }
        
        //update button background color
        nextStepButton.backgroundColor = nextStepButton.isEnabled ? UIColor(named: "ThemeColor"): UIColor(named: "ButtonGray") 
        
       
        if engine.progress == engine.getPagesCount() {
            nextStepButton.setTitle(self.setting.finishButtonTitle, for: .normal)
        } else {
            nextStepButton.setTitle(self.setting.nextStepButtonTitle, for: .normal)

        }
    }
    
}

extension SetUpViewController: AppEngineDelegate {
    // delegate extension
    func willDismissView() {
        
    }

    
    func didDismissView() {
        print("DISMISS")
    }
    
    func didSaveAndDismissPopUpView(type: PopUpType) {
        
        switch type {
        case.customFrequency:
            break
        case .customItemName:
            self.selectedButton.setTitle(self.engine.getStoredDataFromPopUpView() as? String, for: .normal)
        case .customTargetDays:
            self.selectedButton.setTitle((self.engine.getStoredDataFromPopUpView() as? DataOption)?.title, for: .normal)
        
        }
       
    }
}

 


