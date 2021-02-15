//
//  AddItemViewController.swift
//  Reborn
//
//  Created by Christian Liu on 27/12/20.
//

import UIKit

enum AddItemViewState {
    case adding
    case editing
}

class NewItemViewController: UIViewController {

    @IBOutlet weak var middleContentView: UIView!
    @IBOutlet weak var bottomScrollView: UIScrollView!
    @IBOutlet weak var doneButton: UIButton!
    //ItemName
    @IBOutlet weak var itemNameTextfield: UITextField!
    //Item Type
    @IBOutlet weak var persistingTypeButton: UIButton!
    @IBOutlet weak var quittingTypeButton: UIButton!
    //Item Target
    @IBOutlet weak var sevenDaysButton: UIButton!
    @IBOutlet weak var thirtyDaysButton: UIButton!
    @IBOutlet weak var sixtyDaysButton: UIButton!
    @IBOutlet weak var oneHundredDaysButton: UIButton!
    @IBOutlet weak var oneYearButton: UIButton!
    @IBOutlet weak var customTargetDaysButton: UIButton!
    //Item Frequency
    @IBOutlet weak var everydayFrequencyButton: UIButton!
    @IBOutlet weak var everyTwoDaysFreqencyButton: UIButton!
    @IBOutlet weak var everyWeekFreqencyButton: UIButton!
    @IBOutlet weak var everyMonthFrequencyButton: UIButton!
    @IBOutlet weak var freedomFrequencyButton: UIButton!
    @IBOutlet weak var customFrequencyButton: UIButton!
    
    @IBOutlet weak var firstInstructionLabel: UILabel!
    @IBOutlet weak var secondInstructionLabel: UILabel!
    @IBOutlet weak var typeIcon: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomScrollViewContentViewHeightConstraint: NSLayoutConstraint!
    
    let engine: AppEngine = AppEngine.shared
    let setting: SystemStyleSetting = SystemStyleSetting.shared
    var frequency: DataOption? = nil
    var previewItemCardTag: Int? = nil
    var selectedTypeButton: UIButton? = nil
    var selectedTargetDaysButton: UIButton? = nil
    var selectedFrequencyButton: UIButton? = nil
    var lastSelectedButton: UIButton? = nil
    var item: Item = Item(name: "(项目名)", days: 1, finishedDays: 0, frequency: DataOption(title: "", data: 1), creationDate: AppEngine.shared.currentDate, type: .undefined)
    var preViewItemCard: UIView = UIView()
    var UIStrategy: NewItemViewStrategy? = nil
        
    override func viewDidLoad() {
        super.viewDidLoad()
        itemNameTextfield.delegate = self
        bottomScrollView.delegate = self
        
        customFrequencyButton.setTitle(setting.customButtonTitle, for: .normal)
        customTargetDaysButton.setTitle(setting.customButtonTitle, for: .normal)
        customTargetDaysButton.tag = setting.customTargetDaysButtonTag
        customFrequencyButton.tag = setting.customFrequencyButtonTag
        itemNameTextfield.addTarget(self, action: #selector(textfieldTextChanged(_:)), for: .editingChanged)
        itemNameTextfield.layer.cornerRadius = setting.textFieldCornerRadius
        
        for subview in view.viewWithTag(4)!.subviews { // all buttons
            if let button = subview as? UIButton {
               
                button.setSizeAccrodingToScreen()
                button.setCornerRadius()
                button.setShadow()
                button.setBackgroundColor(UserStyleSetting.themeColor, for: .selected)
                button.setTitleColor(.white, for: .selected)

            }
        }
        
        view.layoutIfNeeded()
        bottomScrollViewContentViewHeightConstraint.constant = secondInstructionLabel.frame.origin.y + 40
        
        
        self.UIStrategy?.initializeUI()
        self.updateUI()
        
    }
    

    
    @objc func textfieldTextChanged(_ sender: UITextField!) {
        self.item.name = sender.text ?? ""
        self.updateUI()

    }
    
    @IBAction func typeButtonPressed(_ sender: UIButton) {
        self.deSelectButton()
        
        for type in ItemType.allCases {
            if type.rawValue == sender.currentTitle {
                self.item.type = type
            }
        }
        
        self.selectedFrequencyButton = nil
        self.item.frequency = DataOption(title: "", data: 0)
        self.selectedTypeButton = sender
        self.lastSelectedButton = sender
        self.selectButton()
        self.updateUI()
    }
    
    
    @IBAction func targetDaysButtonPressed(_ sender: UIButton) {
        self.deSelectButton()
        self.selectedTargetDaysButton = sender
        self.lastSelectedButton = sender
        self.selectButton()
        if sender.tag == self.setting.customTargetDaysButtonTag {
            
            self.UIStrategy?.showPopUp(popUpType: .customTargetDays)
            
        } else {
            self.item.targetDays = sender.getData() ?? 1
            self.updateUI()
        }

    }
    
    @IBAction func frequencyButtonPressed(_ sender: UIButton) {
        self.deSelectButton()
        self.selectedFrequencyButton = sender
        self.lastSelectedButton = sender
    
        self.selectButton()
        
        switch sender.currentTitle {
        case "每天":
            self.item.frequency = DataOption(title: sender.currentTitle!, data: 0)
        case "每两天":
            self.item.frequency = DataOption(title: sender.currentTitle!, data: 1)
        case "每周":
            self.item.frequency = DataOption(title: sender.currentTitle!, data: 6)
        case "每月":
            self.item.frequency = DataOption(title: sender.currentTitle!, data: 30)
        case "自由打卡":
            self.item.frequency = DataOption(title: sender.currentTitle!, data: nil)
        default:
            break
        }
        
        self.updateUI()
        
        if sender.tag == self.setting.customFrequencyButtonTag {
            self.UIStrategy?.showPopUp(popUpType: .customFrequency)
        }
    }
    

    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        self.UIStrategy?.doneButtonPressed(sender)
    }
    
    func updateInstructionLabels() {
        
        if self.item.type == .quitting {
            self.firstInstructionLabel.text = "戒除项目需要您坚持每天打卡"
            self.secondInstructionLabel.isHidden = true
        } else {
            self.firstInstructionLabel.text = "频率计划外为休息日，无需打卡"
            self.secondInstructionLabel.isHidden = false
        }
    }
    
    func updateFrequencyButtons() {
        
        
        if self.item.type == .quitting {
            UIView.animate(withDuration: 0.3, animations: {
                
  
                self.everyTwoDaysFreqencyButton.alpha = 0
                self.everyWeekFreqencyButton.alpha = 0
                self.everyMonthFrequencyButton.alpha = 0
                self.freedomFrequencyButton.alpha = 0
                self.customFrequencyButton.alpha = 0
                
            }) { _ in
                self.everyTwoDaysFreqencyButton.isHidden = true
                self.everyWeekFreqencyButton.isHidden = true
                self.everyMonthFrequencyButton.isHidden = true
                self.freedomFrequencyButton.isHidden = true
                self.customFrequencyButton.isHidden = true
            }
            
        } else {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.everyTwoDaysFreqencyButton.isHidden = false
                self.everyWeekFreqencyButton.isHidden = false
                self.everyMonthFrequencyButton.isHidden = false
                self.freedomFrequencyButton.isHidden = false
                self.customFrequencyButton.isHidden = false
                
                self.everyTwoDaysFreqencyButton.alpha = 1
                self.everyWeekFreqencyButton.alpha = 1
                self.everyMonthFrequencyButton.alpha = 1
                self.freedomFrequencyButton.alpha = 1
                self.customFrequencyButton.alpha = 1
                
               
            })
        }
        
        
        
        
       
        
        
       
        
    }
    
    func selectButton() {
        self.selectedTypeButton?.isSelected = true
        self.selectedTargetDaysButton?.isSelected = true
        self.selectedFrequencyButton?.isSelected = true
    }
    
    func deSelectButton() {
        self.selectedTypeButton?.isSelected = false
        self.selectedTargetDaysButton?.isSelected = false
        self.selectedFrequencyButton?.isSelected = false
    }
    
    func removeOldPreviewItemCard() {
        if self.previewItemCardTag != nil {
            
            for subview in self.view.viewWithTag(2)!.subviews {
                if subview.tag == self.previewItemCardTag {
                    subview.removeFromSuperview() // remove old card
                }
            }
        }
    }
    
    func updatePreViewItemCard() {
        self.view.layoutIfNeeded()
        let witdh: CGFloat =  self.setting.screenFrame.width - 2 * self.setting.mainPadding
        let height: CGFloat = self.setting.itemCardHeight
        let cordinateX: CGFloat = self.middleContentView.frame.width / 2 - witdh / 2
        let cordinateY: CGFloat = self.middleContentView.frame.height / 2 - height / 2
        
        let builder = ItemCardViewBuilder(item: self.item, width: witdh, height: height, cordinateX: cordinateX, cordinateY: cordinateY)
  
        Vibrator.vibrate(withImpactLevel: .light)
        
        self.preViewItemCard = builder.buildView()
        self.previewItemCardTag = self.preViewItemCard.tag
 
        self.middleContentView.addSubview(self.preViewItemCard)
    }
    
    func excuteItemCardAimation() {
        
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.4, animations: {
                self.preViewItemCard.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.4, animations: {
                self.preViewItemCard.layer.transform = CATransform3DMakeScale(1.05, 1.05, 1)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.2, animations: {
                self.preViewItemCard.layer.transform = CATransform3DMakeScale(1, 1, 1)
            })
            
        }) { _ in
            
        }
       
    }
    
   
    
    func updateUI() {
        
        updateFrequencyButtons()
        updateInstructionLabels()
        removeOldPreviewItemCard()
        excuteItemCardAimation()
        updatePreViewItemCard()
    }
}

extension NewItemViewController: PopUpViewDelegate { // Delegate extension
 
    func didDismissPopUpViewWithoutSave() {
        print("PopUpDidDismiss")
    }
    
    func didSaveAndDismissPopUpView(type: PopUpType) {
        
        if self.lastSelectedButton?.tag == setting.customTargetDaysButtonTag {
            
            guard let selectedData = (self.engine.getStoredDataFromPopUpView() as? DataOption) else { return }
            
            self.selectedTargetDaysButton?.setTitle(selectedData.title, for: .normal)
            self.item.targetDays = selectedData.data ?? 1
            
            
        } else if self.lastSelectedButton?.tag == setting.customFrequencyButtonTag {
            
    
            self.selectedFrequencyButton?.setTitle((self.engine.getStoredDataFromPopUpView() as? DataOption)?.title, for: .normal)
            self.item.frequency = self.engine.getStoredDataFromPopUpView() as? DataOption ?? DataOption(data: 0)
        }
        
        self.updateUI()
    }
    
}

extension NewItemViewController: UIScrollViewDelegate, UITextFieldDelegate {
    // scrollView delegate function
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.itemNameTextfield.resignFirstResponder()
    }
    
    // keyboard delegate function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.itemNameTextfield.resignFirstResponder()
        return true
    }
}
