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
    @IBOutlet weak var horizentalScrollView: UIScrollView!
    @IBOutlet weak var horizentalContentView: UIView!
    @IBOutlet weak var verticalScrollView: UIScrollView!
    @IBOutlet weak var verticalContentView: UIView!
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
    @IBOutlet weak var verticalScrollViewContentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var optionButtons: [UIButton]!
    
    let engine: AppEngine = AppEngine.shared
    let setting: SystemSetting = SystemSetting.shared
    var frequency: CustomData? = nil
    var previewItemCardTag: Int? = nil
    var selectedTypeButton: UIButton? = nil
    var selectedTargetDaysButton: UIButton? = nil
    var selectedFrequencyButton: UIButton? = nil
    var lastSelectedButton: UIButton? = nil
    var item: Item = Item(ID: AppEngine.shared.currentUser.getLargestItemID() + 1, name: "(项目名)", days: 1, frequency: .everyday, creationDate: CustomDate.current, type: .undefined)
    var preViewItemCard: UIView = UIView()
    var strategy: NewItemViewStrategy? = nil
    var lastViewController: UIViewController? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
 
        itemNameTextfield.delegate = self
        verticalScrollView.delegate = self
        
        customFrequencyButton.setTitle(setting.customButtonTitle, for: .normal)
        customTargetDaysButton.setTitle(setting.customButtonTitle, for: .normal)
        customTargetDaysButton.tag = setting.customTargetDaysButtonTag
        customFrequencyButton.tag = setting.customFrequencyButtonTag
        
        itemNameTextfield.setPadding()
        itemNameTextfield.tintColor = engine.userSetting.themeColor.uiColor
        itemNameTextfield.addTarget(self, action: #selector(textfieldTextChanged(_:)), for: .editingChanged)
        itemNameTextfield.layer.cornerRadius = setting.textFieldCornerRadius
        
        
        setButtonsAppearance()
        view.layoutIfNeeded()
        verticalScrollViewContentViewHeightConstraint.constant = secondInstructionLabel.frame.origin.y + 40
        
        
        self.strategy?.initializeUI()
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
        self.item.frequency = .everyday
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
            
            self.strategy?.show(.customTargetDaysPopUp)
            
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
        for frequency in Frequency.allCases {
            if sender.currentTitle == frequency.dataModel.title {
                self.item.frequency = frequency
            }
        }
        
        self.updateUI()
        
        if sender.tag == self.setting.customFrequencyButtonTag {
            self.strategy?.show(.customFrequencyPopUp)
        }
    }
    

    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        self.strategy?.doneButtonPressed(sender)
    }
    
    @objc func deleteItemButtonPressed(_ sender: UIButton) {
        showAlert()
    }
    
    
    private func showAlert() {
        let alert = UIAlertController(title: "你真的想删除该项目吗", message: "该项目所有的数据将会被删除，且不能恢复", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "删除", style: .destructive) { _ in
            self.deleteItemWithAnimation()
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        

        self.present(alert, animated: true)
    }
    
    private func deleteItemWithAnimation() {
        
        UIView.animate(withDuration: 1, animations: {
            self.preViewItemCard.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.engine.currentUser.delete(item: self.item)
            self.engine.saveUser()
            self.engine.notifyAllUIObservers()
        }) { _ in
            self.dismiss(animated: true) {
  
                if let parentViewController = self.lastViewController as? ItemDetailViewController {
                    parentViewController.goBackToParentView()
                }
            }
        }
        
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
        self.horizentalContentView.renderItemCard(by: self.item)
        self.previewItemCardTag = self.preViewItemCard.tag
        self.preViewItemCard = self.horizentalContentView.subviews.first!
        Vibrator.vibrate(withImpactLevel: .light)
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
    
    func setButtonsAppearance() {
        doneButton.setTitleColor(self.engine.userSetting.smartThemeColor, for: .normal)
        
        for button in self.optionButtons {
            button.proportionallySetSizeWithScreen()
            button.setCornerRadius()
            button.setShadow()
            button.setBackgroundColor(self.engine.userSetting.themeColor.uiColor, for: .selected)
            button.setTitleColor(self.engine.userSetting.smartLabelColor, for: .selected)
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
            
            guard let selectedData = (self.engine.getStoredDataFromPopUpView() as? CustomData) else { return }

            self.selectedTargetDaysButton?.setTitle(selectedData.title, for: .normal)
            self.item.targetDays = selectedData.data ?? 1
            
            
        } else if self.lastSelectedButton?.tag == setting.customFrequencyButtonTag {
    
            if let storedDataFromPopUpView = self.engine.getStoredDataFromPopUpView() as? Frequency {
                self.selectedFrequencyButton?.setTitle(storedDataFromPopUpView.dataModel.title, for: .normal)
                self.item.frequency = storedDataFromPopUpView
            }
            
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
