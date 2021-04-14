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
    var setting = SystemSetting()

    var scrollViewWidth: CGFloat = 0
    var backButtonPressed = false
    var numberOfPagedAdded = 0
    var selectedButton: UIButton = UIButton()
    var itemIsSkipped: Bool = false
    var pageView: UIView? {
        return self.middleScrollView.getSubviewBy(tag: self.engine.getCurrentPage().ID)
    }
    var textField: UITextField? {
        return self.middleScrollView.getSubviewBy(tag: 5)?.getSubviewBy(idenifier: "TextField") as? UITextField
    }
    static let optionButtonAction = #selector(optionButtonPressed)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(keyboardShowNotification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide(keyboardShowNotification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        middleView.frame = CGRect(x: middleView.frame.origin.x, y: middleView.frame.origin.y, width: view.frame.width, height: middleView.frame.height)

        questionLabel.font = setting.questionLabelFont
        nextStepButton.setCornerRadius()
        nextStepButton.isEnabled = false
        
        //addAllPages()
        loadSetUpPages()
        updateUI()
        
        textField?.delegate = self
    }
    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        self.updateUI()
//    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    

    @IBAction func nextStepButtonPressed(_ sender: UIButton) {
    
        
        
        
        if self.engine.getCurrentPage().ID != 5 {
            
            if sender.currentTitle == setting.finishButtonTitle {
                self.engine.save(data: self.selectedButton.currentTitle ?? "")
                self.engine.createUser(setUpIsSkipped: false)
                self.goToHomeView()
                
            } else if selectedButton.currentTitle == self.setting.skipButtonTitle {
                
                self.engine.nextPage()
                self.engine.nextPage()
                self.deSelectButton()
                self.itemIsSkipped = true
                
            } else {
                self.engine.save(data: self.selectedButton.currentTitle ?? "")
                self.engine.nextPage()
                self.deSelectButton()
                self.itemIsSkipped = false
            }
            
        } else {
            
            if let text = self.textField?.text, text != "" {
              
                self.engine.save(data: text)
                self.engine.nextPage()
                self.deSelectButton()
                self.itemIsSkipped = false
                
            }
            
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
    
    func loadSetUpPages(){
        
        let layoutGuideView = self.middleView!
        var pageNum = 0
        
        for page in self.engine.pages {
            print(CGFloat(pageNum) * layoutGuideView.frame.width)
            let builder = SetUpPageViewBuilder(page: page, pageCordinateX: CGFloat(pageNum) * layoutGuideView.frame.width, layoutGuideView: layoutGuideView)
            self.middleScrollView.addSubview(builder.buildSetUpPage())
            self.middleScrollView.contentSize = CGSize(width: CGFloat(self.engine.pages.count) * layoutGuideView.frame.width, height: layoutGuideView.frame.height) // set size
            pageNum += 1
            
        }
    
        middleView = layoutGuideView
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
    
        self.engine.createUser(setUpIsSkipped: true)
        self.goToHomeView()
    }
    
    @IBAction func skipButtonPressed(_ sender: UIButton) {
        goToHomeView()
    }
    
    @objc func optionButtonPressed(_ sender: UIButton! ) { // option button selected action
        print(sender.tag)
        if sender.tag == self.setting.customItemNameButtonTag {
            
            self.present(.customItemNamePopUp)

            
        } else if sender.tag == self.setting.customTargetDaysButtonTag {

            self.present(.customTargetDaysPopUp)

        }
        
        self.selectButton(button: sender)
        
        
    }
    
    @objc
    func keyboardWillShow(keyboardShowNotification notification: Notification) {

        print("KeyBoardWillShow")
        
    }
    
    @objc
    func keyboardDidHide(keyboardShowNotification notification: Notification) {
        print("KeyboardDidHide")
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
        nextStepButton.backgroundColor = nextStepButton.isEnabled ? AppEngine.shared.userSetting.themeColor.uiColor : SystemSetting.shared.grayColor.withAlphaComponent(0.5)
        
       
        if engine.progress == engine.getPagesCount() {
            nextStepButton.setTitle(self.setting.finishButtonTitle, for: .normal)
        } else {
            nextStepButton.setTitle(self.setting.nextStepButtonTitle, for: .normal)

        }
    }
    
}

extension SetUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
   
        self.nextStepButton.isEnabled = textField.text == "" ? false : true
        self.updateUI()
        return true
    }
}


extension SetUpViewController: PopUpViewDelegate {
    // delegate extension
    func willDismissView() {
        
    }

    
    func didDismissPopUpViewWithoutSave(_ type: PopUpType) {
        self.deSelectButton()
    }
    
    func didSaveAndDismiss(_ type: PopUpType) {
        

        switch type {
        case .customItemNamePopUp:
            self.selectedButton.setTitle(self.engine.getStoredDataFromPopUpView() as? String, for: .normal)
        case .customTargetDaysPopUp:
            self.selectedButton.setTitle((self.engine.getStoredDataFromPopUpView() as? CustomData)?.title, for: .normal)
        default:
            break
        }
       
    }
}

 


