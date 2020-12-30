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
    
    var middleViewX: CGFloat?
    var middleViewY: CGFloat?
    var middleViewWidth: CGFloat?
    var middleViewHeight: CGFloat?
    
    var scrollViewWidth: CGFloat = 0
    var currentPageX: CGFloat = 0
    
    var backButtonPressed = false
    var numberOfPagedAdded = 0
    var selectedButton: UIButton = UIButton()
    var popUpView: PopUpView? = nil
    var keyboardFrame: CGRect? = nil
    
    var popUpTextfieldText: String = ""
    
    var state1: WaitingForSelection = WaitingForSelection()
    var state2: ReadyToGoNextPage = ReadyToGoNextPage()
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(keyboardShowNotification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        state1.handle1()
    }
    
    @IBAction func nextStepButtonPressed(_ sender: UIButton) {
        
        if nextStepButton.currentTitle == setting.finishButtonTitle {
            self.engine.saveData()
            self.goToHomeView()
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
        self.goToHomeView()
    }
    
    func updateButtons() { // Adding a new page to scrollview
        
        let page = UIView(frame: CGRect(x: currentPageX, y: 0, width: middleViewWidth!, height: middleViewHeight!))

        var column = 1
        var buttonX: CGFloat
        var buttonY: CGFloat = -setting.optionButtonToTopDistance

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
            button.layer.cornerRadius = self.setting.optionButtonCornerRadius
            button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
            button.layer.shadowOffset =  CGSize(width: 0.0, height: 2.0)
            button.layer.shadowOpacity = 1.0
            button.layer.masksToBounds = false
            
            button.setTitle(buttonName, for: .normal)
            button.setTitleColor(self.setting.optionButtonTitleColor, for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.setTitleColor(UIColor.white, for: .selected)
            
            //button.setBackgroundImage(self.setting.optionButtonBgImage, for: .normal)
            //button.setBackgroundImage(self.setting.optionButtonPressedBgImage, for: .highlighted)
            //button.setBackgroundImage(UIImage(), for: .selected)
            button.setBackgroundColor(UIColor.white, cornerRadius: button.layer.cornerRadius, for: .normal)
            button.setBackgroundColor(UserStyleSetting.themeColor!, cornerRadius: button.layer.cornerRadius, for: .selected)
            //button.setBackgroundColor(UIColor.white, for: .normal)
            
            button.titleLabel?.font = self.setting.optionButtonTitleFont
            button.addTarget(self, action: #selector(optionButtonPressed), for: .touchDown)

            switch self.engine.progress {
            case 1:
                if buttonName == self.setting.customButtonTitle {
                button.tag = self.setting.customItemNameButtonTag
            }
            case 2:
                if buttonName == self.setting.customButtonTitle {
                button.tag = self.setting.customTargetButtonTag
            }
            case 3:
                if buttonName == self.setting.customButtonTitle {
                    button.tag = self.setting.customItemNameButtonTag
                }
            case 4:
                if buttonName == self.setting.customButtonTitle {
                    button.tag = self.setting.customItemNameButtonTag
                }
            default: print("")
            }
            page.addSubview(button)

        }
        
       
        self.middleScrollView.contentSize = CGSize(width: self.scrollViewWidth, height: self.middleViewHeight!) // set size

    }
    
    @objc func popUpViewButtonPressed(_ sender: UIButton!) {
        
        if sender.tag == setting.popUpBGViewButtonTag || sender.tag == setting.popUpWindowCancelButtonTag { // dismiss buttons pressed
            print("HERERER")
            self.selectedButton.isSelected = false
            self.nextStepButton.isEnabled = false
            self.popUpView!.disappear(comletion: {_ in
                sender.superview?.removeFromSuperview()
            })
          
        } else if sender.tag == setting.popUpWindowDoneButtonTag { // done button pressed
            
            if self.popUpView?.getTextfieldText() != "" {
                
                self.popUpView?.hidePrompLabel(true)
                
                self.popUpView!.disappear(comletion: {_ in
                    sender.superview?.removeFromSuperview()
                })
            } else {
                self.popUpView?.hidePrompLabel(false)
            }
            
            self.selectedButton.setTitle(self.popUpView?.getTextfieldText(), for: .normal)
        }

    }
    

    
    @objc func optionButtonPressed(_ sender: UIButton! ) { // option button selected action
        
        if sender.tag == setting.customItemNameButtonTag {

            self.showPopUpView()
            
        } else if sender.currentTitle == setting.skipButtonTitle {
            
        } else {
            
        
        }
        
        self.nextStepButton.isEnabled = true
        self.selectedButton.isSelected = false // old selected button become white
        self.selectedButton = sender
        
        sender.isSelected = !sender.isSelected
        
        print(sender.currentTitle!)
        updateUI()
        
    }
    
    @objc func keyboardDidShow(keyboardShowNotification notification: Notification) {
        if let userInfo = notification.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            self.keyboardFrame = keyboardFrame
            self.popUpView?.moveUp(distance: keyboardFrame.height)
            
        }
        
    }
    
    @objc func textFieldTapped(_ sender: UITextField!) {
       
        
    }
    
    
    func hidePopUpView(_ sender: UIButton) {
        self.popUpView!.disappear(comletion: {_ in
            sender.superview?.removeFromSuperview()
        })
    }
    
    func showPopUpView() {
        self.popUpView = AppEngine.shared.generateCutomItemNamePopUp()
        popUpView!.setDismissButtonActions(action: #selector(popUpViewButtonPressed))
        popUpView!.setTextFieldAction(action: #selector(textFieldTapped))
        popUpView!.appear()
        self.view.addSubview(popUpView!.popUpBGView)
    }
    
    
    func addAllPages() {
        
        for _ in 0 ..< engine.getPagesCount() {
            
            updateButtons()
            engine.nextPage()
        }
        
        engine.progress = 1
    }
    
    @IBAction func skipButtonPressed(_ sender: UIButton) {
        goToHomeView()
    }
    
    func goToHomeView() {
        
        self.performSegue(withIdentifier: "goToHomeView", sender: self)
    }
    
    func updateUI() {
    
        questionLabel.text = engine.getCurrentPage().question
        middleScrollView.setContentOffset(CGPoint(x: middleViewWidth! * CGFloat(engine.progress) - middleViewWidth!, y: 0), animated: true) //Slide to right Buttons page
        

        UIView.animate(withDuration: setting.progressBarAnimationSpeed) {
            self.progressView.setProgress(Float(self.engine.progress) / Float(self.engine.getPagesCount()), animated: true)
        }
        
        
        nextStepButton.backgroundColor = nextStepButton.isEnabled ? UIColor(named: "ThemeColor"): UIColor(named: "ButtonGray") 
        
        if engine.progress == engine.getPagesCount() {
            nextStepButton.setTitle(setting.finishButtonTitle, for: .normal)
     
        } else {
            nextStepButton.setTitle(setting.nextStepButtonTitle, for: .normal)

        }
    }
    
}
 


