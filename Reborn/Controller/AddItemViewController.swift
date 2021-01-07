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
    
    
    let engine = AppEngine.shared
    
    var itemName: String = "项目名"
    var itemType: ItemType = ItemType.UNDEFINED
    var targetDays: Int = 1
    var frequency: DataOption? = nil
    
    var previewItemCardTag: Int? = nil
    
    var selectedTypeButton: UIButton? = nil
    var selectedTargetDaysButton: UIButton? = nil
    var selectedFrequencyButton: UIButton? = nil
    
    var lastSelectedButton: UIButton? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itemNameTextfield.delegate = self
        self.itemNameTextfield.returnKeyType = UIReturnKeyType.done
        self.bottomScrollView.delegate = self
        
        self.customFrequencyButton.setTitle(SystemStyleSetting.shared.customButtonTitle, for: .normal)
        self.customTargetDaysButton.setTitle(SystemStyleSetting.shared.customButtonTitle, for: .normal)
        self.customTargetDaysButton.tag = SystemStyleSetting.shared.customTargetDaysButtonTag
        self.customFrequencyButton.tag = SystemStyleSetting.shared.customFrequencyButtonTag
        self.itemNameTextfield.addTarget(self, action: #selector(self.textfieldTextChanged(_:)), for: .editingChanged)
        
        for subview in view.viewWithTag(4)!.subviews {
            if let button = subview as? UIButton {
                button.layer.cornerRadius = SystemStyleSetting.shared.optionButtonCornerRadius
                button.setViewShadow()
                button.setBackgroundColor(UserStyleSetting.themeColor, cornerRadius: button.layer.cornerRadius, for: .selected)
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
        if sender.tag == SystemStyleSetting.shared.customTargetDaysButtonTag {
            
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
        if sender.tag == SystemStyleSetting.shared.customFrequencyButtonTag {
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
    
    
    
    @IBAction func addItemButtonPressed(_ sender: UIButton) {
        
        var newItem: Item
        
        switch self.itemType {
        
        case .QUITTING:
           newItem = QuittingItem(name: self.itemName, days: self.targetDays, finishedDays: 0, creationDate: self.engine.currentDate)
           
        case .PERSISTING:
            newItem = PersistingItem(name: self.itemName, days: self.targetDays, finishedDays: 0, creationDate: self.engine.currentDate)
        default:
            newItem = Item(name: self.itemName, days: self.targetDays, finishedDays: 0, creationDate: self.engine.currentDate, type: .UNDEFINED)
        }
        
        if let _ = self.frequency {
            newItem.setFreqency(frequency: frequency!)
        }
        self.engine.addItem(newItem: newItem)
        self.engine.dismissAddItemView(controller: self)
   
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
    
    func updatePreViewItemCard(name: String, type: ItemType, days: Int) {
        
        if self.previewItemCardTag != nil {
            
            for subview in view.viewWithTag(2)!.subviews {
                if subview.tag == self.previewItemCardTag {
                    subview.removeFromSuperview()
                }
            }
        }
        
        var item: Item
        
        switch type {
        case .QUITTING:
            
            item = QuittingItem(name: name, days: days, finishedDays: 0, creationDate: self.engine.currentDate)

        case .PERSISTING:
            
            item = PersistingItem(name: name, days: days, finishedDays: 0, creationDate: self.engine.currentDate)

        default:
            
            item = Item(name: name, days: days, finishedDays: 0, creationDate: self.engine.currentDate, type: .UNDEFINED)

        }
        
        if self.frequency != nil {
            item.setFreqency(frequency: frequency!)
        }
    
        let preViewItemCard = engine.generateNewItemCard(item: item)
        self.previewItemCardTag = preViewItemCard.tag
 
        preViewItemCard.center = middleContentView.center
        self.middleContentView.addSubview(preViewItemCard)
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.4, animations: {
                preViewItemCard.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.4, animations: {
                preViewItemCard.layer.transform = CATransform3DMakeScale(1.05, 1.05, 1)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.2, animations: {
                preViewItemCard.layer.transform = CATransform3DMakeScale(1, 1, 1)
            })
            
            
        }) { _ in
            
        }
    

    }
    
    
    
    func updateUI() {
        
        updatePreViewItemCard(name: self.itemName, type: self.itemType, days: self.targetDays)
    }
}

extension AddItemViewController: AppEngineDelegate, UIScrollViewDelegate, UITextFieldDelegate { // Delegate extension
    
    func didDismissView() {
        print("DISMISS")
    }
    
    func didSaveAndDismissPopUpView(type: PopUpType) {
        
        if self.lastSelectedButton?.tag == SystemStyleSetting.shared.customTargetDaysButtonTag {
            self.selectedTargetDaysButton?.setTitle((self.engine.getStoredDataFromPopUpView() as? DataOption)?.title, for: .normal)
            self.targetDays = (self.engine.getStoredDataFromPopUpView() as? DataOption)?.data ?? 1
            
        } else if self.lastSelectedButton?.tag == SystemStyleSetting.shared.customFrequencyButtonTag {
            
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
