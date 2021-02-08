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
    @IBOutlet weak var everydayOptionButton: UIButton!
    @IBOutlet weak var mondayToFridayOptionButton: UIButton!
    @IBOutlet weak var weekendOptionButton: UIButton!
    @IBOutlet weak var customizeFrequencyButton: UIButton!
    
    @IBOutlet weak var addFrequencyButton: UIButton!
    @IBOutlet weak var deleteFrequencyButton: UIButton!
    
    @IBOutlet weak var itemNameTextfield: UITextField!
    @IBOutlet weak var customTargetDaysButton: UIButton!
    @IBOutlet weak var customFrequencyButton: UIButton!
    @IBOutlet weak var bottomScrollView: UIScrollView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var persistingTypeButton: UIButton!
    @IBOutlet weak var quittingTypeButton: UIButton!
    @IBOutlet weak var sevenDaysButton: UIButton!
    @IBOutlet weak var thirtyDaysButton: UIButton!
    @IBOutlet weak var sixtyDaysButton: UIButton!
    @IBOutlet weak var oneHundredDaysButton: UIButton!
    @IBOutlet weak var oneYearButton: UIButton!
    @IBOutlet weak var customTargetButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    let engine: AppEngine = AppEngine.shared
    let setting: SystemStyleSetting = SystemStyleSetting.shared
    var frequency: DataOption? = nil
    var previewItemCardTag: Int? = nil
    var selectedTypeButton: UIButton? = nil
    var selectedTargetDaysButton: UIButton? = nil
    var selectedFrequencyButton: UIButton? = nil
    var lastSelectedButton: UIButton? = nil
    var item: Item = Item(name: "项目名", days: 1, finishedDays: 0, creationDate: AppEngine.shared.currentDate, type: .undefined)
    var preViewItemCard: UIView? = nil
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
                button.setBackgroundColor(UserStyleSetting.themeColor, cornerRadius: button.layer.cornerRadius, for: .selected)
                button.setTitleColor(.white, for: .selected)

            }
        }
        
        hideAllFrequencyOptionButtons(true)
        
        self.UIStrategy?.initializeUI()
        
        
    }
    
   
    func hideAllFrequencyOptionButtons(_ isHidden: Bool) {
        self.everydayOptionButton.isHidden = isHidden
        self.mondayToFridayOptionButton.isHidden = isHidden
        self.weekendOptionButton.isHidden = isHidden
        self.customizeFrequencyButton.isHidden = isHidden
        self.deleteFrequencyButton.isHidden = isHidden
    }
    
    @objc func textfieldTextChanged(_ sender: UITextField!) {
        self.item.name = sender.text ?? ""
        self.updateUI()

    }
    
    @IBAction func typeOptionButtonPressed(_ sender: UIButton) {
        self.deSelectButton()
        
        for type in ItemType.allCases {
            if type.rawValue == sender.currentTitle {
                self.item.type = type
            }
        }
        self.selectedTypeButton = sender
        self.lastSelectedButton = sender
        self.selectButton()
        self.updateUI()
    }
    
    
    @IBAction func targetDaysOptionButtonPressed(_ sender: UIButton) {
        self.deSelectButton()
        self.selectedTargetDaysButton = sender
        self.lastSelectedButton = sender
        self.selectButton()
        if sender.tag == self.setting.customTargetDaysButtonTag {
            
            self.engine.showPopUp(.customTargetDays, from: self)
            
        } else {
            self.item.targetDays = sender.getData() ?? 1
            self.updateUI()
        }

    }
    
    @IBAction func frequencyOptionButtonPressed(_ sender: UIButton) {
        self.deSelectButton()
        self.selectedFrequencyButton = sender
        self.lastSelectedButton = sender
        if sender.tag == self.setting.customFrequencyButtonTag {
            self.engine.showPopUp(.customFrequency, from: self)
        }
        self.selectButton()
    }
    
    
    
    @IBAction func addFrequencyButtonPressed(_ sender: Any) {
        self.addFrequencyButton.isHidden = true
        self.hideAllFrequencyOptionButtons(false)
    }
    
    @IBAction func deleteFrequencyButtonPressed(_ sender: Any) {
        self.addFrequencyButton.isHidden = false
        self.hideAllFrequencyOptionButtons(true)
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.engine.dismissNewItemViewWithoutSave(viewController: self)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        self.UIStrategy?.doneButtonPressed(sender)
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
        self.UIStrategy?.updatePreViewItemCard()
    }
    
    func excuteItemCardAimation() {
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.4, animations: {
                self.preViewItemCard?.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.4, animations: {
                self.preViewItemCard?.layer.transform = CATransform3DMakeScale(1.05, 1.05, 1)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.2, animations: {
                self.preViewItemCard?.layer.transform = CATransform3DMakeScale(1, 1, 1)
            })
            
            
        }) { _ in
            
        }
       
    }
    
    func updateUI() {
        removeOldPreviewItemCard()
        excuteItemCardAimation()
        updatePreViewItemCard()
    }
}

extension NewItemViewController: AppEngineDelegate, UIScrollViewDelegate, UITextFieldDelegate { // Delegate extension
    func willDismissView() {
        
    }
    
    func didDismissView() {
        print("PopUpDidDismiss")
    }
    
    func didSaveAndDismissPopUpView(type: PopUpType) {
        
        if self.lastSelectedButton?.tag == setting.customTargetDaysButtonTag {
            self.selectedTargetDaysButton?.setTitle((self.engine.getStoredDataFromPopUpView() as? DataOption)?.title, for: .normal)
            self.item.targetDays = (self.engine.getStoredDataFromPopUpView() as? DataOption)?.data ?? 1
            
        } else if self.lastSelectedButton?.tag == setting.customFrequencyButtonTag {
            
    
            self.selectedFrequencyButton?.setTitle((self.engine.getStoredDataFromPopUpView() as? DataOption)?.title, for: .normal)
            self.item.frequency = self.engine.getStoredDataFromPopUpView() as? DataOption
        }
        
       
        self.updateUI()
    }
    
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
