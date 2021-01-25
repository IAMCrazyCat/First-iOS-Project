//
//  AddItemViewController.swift
//  Reborn
//
//  Created by Christian Liu on 27/12/20.
//

import UIKit

class AddItemViewController: UIViewController {

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
    
    
    let engine: AppEngine = AppEngine.shared
    let setting: SystemStyleSetting = SystemStyleSetting.shared
    var itemName: String = "项目名"
    var itemType: ItemType = ItemType.undefined
    var targetDays: Int = 1
    var frequency: DataOption? = nil
    
    var previewItemCardTag: Int? = nil
    
    var selectedTypeButton: UIButton? = nil
    var selectedTargetDaysButton: UIButton? = nil
    var selectedFrequencyButton: UIButton? = nil
    
    var lastSelectedButton: UIButton? = nil
    
    var item: Item? = nil
    var preViewItemCard: UIView? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itemNameTextfield.delegate = self
        self.bottomScrollView.delegate = self
        
        self.customFrequencyButton.setTitle(setting.customButtonTitle, for: .normal)
        self.customTargetDaysButton.setTitle(setting.customButtonTitle, for: .normal)
        self.customTargetDaysButton.tag = setting.customTargetDaysButtonTag
        self.customFrequencyButton.tag = setting.customFrequencyButtonTag
        self.itemNameTextfield.addTarget(self, action: #selector(self.textfieldTextChanged(_:)), for: .editingChanged)
        self.itemNameTextfield.layer.cornerRadius = setting.textFieldCornerRadius
        
        for subview in view.viewWithTag(4)!.subviews { // all buttons
            if let button = subview as? UIButton {
                button.layer.cornerRadius = setting.optionButtonCornerRadius
                button.setViewShadow()
                button.setBackgroundColor(UserStyleSetting.themeColor, cornerRadius: button.layer.cornerRadius, for: .selected)
                button.setTitleColor(UIColor.white, for: .selected)

            }
        }
        
        self.hideAllFrequencyOptionButtons(true)
        self.updateUI()
        
        
    }
    
   
    func hideAllFrequencyOptionButtons(_ isHidden: Bool) {
        self.everydayOptionButton.isHidden = isHidden
        self.mondayToFridayOptionButton.isHidden = isHidden
        self.weekendOptionButton.isHidden = isHidden
        self.customizeFrequencyButton.isHidden = isHidden
        self.deleteFrequencyButton.isHidden = isHidden
    }
    
    @objc func textfieldTextChanged(_ sender: UITextField!) {
        self.itemName = sender.text ?? ""
        self.updateUI()

    }
    
    @IBAction func typeOptionButtonPressed(_ sender: UIButton) {
        deSelectButton()
        
        for type in ItemType.allCases {
            if type.rawValue == sender.currentTitle {
                self.itemType = type
                
            }
        }
        self.selectedTypeButton = sender
        self.lastSelectedButton = sender
        selectButton()
        updateUI()
    }
    
    
    @IBAction func targetDaysOptionButtonPressed(_ sender: UIButton) {
        deSelectButton()
        self.selectedTargetDaysButton = sender
        self.lastSelectedButton = sender
        selectButton()
        if sender.tag == setting.customTargetDaysButtonTag {
            
            self.engine.showPopUp(popUpType: .customTargetDays, controller: self)
            
        } else {
            self.targetDays = sender.getData() ?? 1
            updateUI()
        }
        
        
    }
    
    @IBAction func frequencyOptionButtonPressed(_ sender: UIButton) {
        deSelectButton()
        self.selectedFrequencyButton = sender
        self.lastSelectedButton = sender
        if sender.tag == setting.customFrequencyButtonTag {
            self.engine.showPopUp(popUpType: .customFrequency, controller: self)
        }
        selectButton()
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
        self.engine.dismissAddItemViewWithoutSave(controller: self)
    }
    
    @IBAction func addItemButtonPressed(_ sender: UIButton) {
        
        if item != nil {
            
            if self.frequency != nil {
                self.item!.setFreqency(frequency: frequency!)
            }
            
            self.engine.dismissAndSaveAddItemView(controller: self)
        }
        
   
    }
    
    
    func selectButton() {
        selectedTypeButton?.isSelected = true
        selectedTargetDaysButton?.isSelected = true
        selectedFrequencyButton?.isSelected = true
    }
    
    func deSelectButton() {
        selectedTypeButton?.isSelected = false
        selectedTargetDaysButton?.isSelected = false
        selectedFrequencyButton?.isSelected = false
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
        
       
        
        switch itemType {
        case .quitting:
            
            self.item = QuittingItem(name: self.itemName, days: self.targetDays, finishedDays: 0, creationDate: self.engine.currentDate)

        case .persisting:
            
            self.item = PersistingItem(name: self.itemName, days: self.targetDays, finishedDays: 0, creationDate: self.engine.currentDate)

        default:
            
            self.item = Item(name: self.itemName, days: self.targetDays, finishedDays: 0, creationDate: self.engine.currentDate, type: .undefined)

        }
        
        if frequency != nil {
            self.item!.setFreqency(frequency: frequency!)
        }
        print(self.item!.frequency)
        excuteItemCardAimation()
        
       
            
        let builder = ItemViewBuilder(item: self.item!, width: self.setting.screenFrame.width - 2 * self.setting.mainPadding, height: self.setting.itemCardHeight, corninateX: 0, cordinateY: 0)
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        self.preViewItemCard = builder.buildItemCardView()
        self.previewItemCardTag = preViewItemCard!.tag
 
        self.preViewItemCard!.center = self.middleContentView.center
        self.middleContentView.addSubview(preViewItemCard!)


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
        updatePreViewItemCard()
        
    }
}

extension AddItemViewController: AppEngineDelegate, UIScrollViewDelegate, UITextFieldDelegate { // Delegate extension
    func willDismissView() {
        
    }
    
    func didDismissView() {
        print("PopUpDidDismiss")
    }
    
    func didSaveAndDismissPopUpView(type: PopUpType) {
        
        if self.lastSelectedButton?.tag == setting.customTargetDaysButtonTag {
            self.selectedTargetDaysButton?.setTitle((self.engine.getStoredDataFromPopUpView() as? DataOption)?.title, for: .normal)
            self.targetDays = (self.engine.getStoredDataFromPopUpView() as? DataOption)?.data ?? 1
            
        } else if self.lastSelectedButton?.tag == setting.customFrequencyButtonTag {
            
            print(self.engine.getStoredDataFromPopUpView())
            self.selectedFrequencyButton?.setTitle((self.engine.getStoredDataFromPopUpView() as? DataOption)?.title, for: .normal)
            self.frequency = self.engine.getStoredDataFromPopUpView() as? DataOption
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
