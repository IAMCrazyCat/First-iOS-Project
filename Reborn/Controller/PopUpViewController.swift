//
//  PopUpViewController.swift
//  Reborn
//
//  Created by Christian Liu on 1/1/21.
//

import UIKit

class PopUpViewController: UIViewController {
    
    
    var keyboardFrame: CGRect? = nil
    var height: CGFloat = SystemStyleSetting.shared.popUpWindowHeight
    var presentDuration: Double = SystemStyleSetting.shared.popUpWindowPresentDuration
    var type: PopUpType?
    var pikerViewData: Array<Any> = []
    var keyboardDidShowFully: Bool = false
    var pickerViewSelectedRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(keyboardShowNotification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide(keyboardShowNotification:)), name: UIResponder.keyboardDidHideNotification, object: nil)

    }

    
    @objc
    func doneButtonPressed(_ sender: UIButton!) {
       
        
        switch type {
        case .customFrequency:
            AppEngine.shared.saveAndDismissPopUp(controller: self)
        case .customTargetDays:
            AppEngine.shared.saveAndDismissPopUp(controller: self)
        case .customItemName:
            if let textField = self.getWindowSubviewByTag(tag: SystemStyleSetting.shared.popUpWindowTextFieldTag) as? UITextField {
                
                if textField.text != "" {
                    AppEngine.shared.saveAndDismissPopUp(controller: self)
                } else {
                    
                    self.hidePromptLabel(false)
                }
            }
        default:
            print("Switching type error")
        }
            
            

       
    }
    
    func hidePromptLabel(_ isHidden: Bool) {
       
        
        if let promptLabel = self.getWindowSubviewByTag(tag: SystemStyleSetting.shared.popUpWindowPromptLabelTag) as? UILabel {
            
            promptLabel.isHidden = isHidden
        }
        
        
    }
    
    @objc
    func cancelButtonPressed(_ sender: UIButton!) {
        AppEngine.shared.dismissPopUp(controller: self)
    }

    
    @objc
    func keyboardWillShow(keyboardShowNotification notification: Notification) {

        if let userInfo = notification.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            self.keyboardFrame = keyboardFrame
            
            if !keyboardDidShowFully {
                UIView.animate(withDuration: 0.2, delay: 0.05, options: .curveEaseOut, animations: {
                    self.view.frame.origin.y -= keyboardFrame.height
                })
            }
           
        }
        
        self.keyboardDidShowFully = true
        
    }
    
    @objc
    func keyboardDidHide(keyboardShowNotification notification: Notification) {
        print("KeyboardDidHide")
    }
    
    @objc
    func textFieldTapped(_ sender: UITextField!) {
        self.hidePromptLabel(true)
        
    }
    
    
    private func getWindowSubviewByTag(tag: Int) -> UIView?
    {
        var popUpWindow: UIView? = nil
        for subview in self.view.subviews {
            if subview.tag == SystemStyleSetting.shared.popUpWindowTag {
                popUpWindow = subview
            }
        }
        
        if let _ = popUpWindow {
            for subview in popUpWindow!.subviews {
                print(subview.tag)
                if subview.tag == tag {
                    return subview
                }
            }

        }
        return nil
    }
    
    public func getStoredData() -> Any {
        
        var storedData: Any?
        
        switch type {
        case .customFrequency:
            let pickerView = getWindowSubviewByTag(tag: SystemStyleSetting.shared.popUpWindowPickerViewTag) as! UIPickerView
           
            storedData = self.pikerViewData[pickerView.selectedRow(inComponent: 0)]
        case .customItemName:
            
            let textField = getWindowSubviewByTag(tag: SystemStyleSetting.shared.popUpWindowTextFieldTag) as! UITextField
            
            if let text = textField.text {
                storedData = text
            }
        
        case .customTargetDays:
            let pickerView = getWindowSubviewByTag(tag: SystemStyleSetting.shared.popUpWindowPickerViewTag) as! UIPickerView
           
            storedData = self.pikerViewData[pickerView.selectedRow(inComponent: 0)]
        default:
            print("Switch pop up type error, In 'PopUpViewController'")
        }
        
        return storedData ?? "Error"
    }
}

extension PopUpViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return self.pikerViewData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        switch self.type {
        case .customFrequency:
            return (self.pikerViewData as! Array<DataOption>)[row].title
        case .customItemName:
            break
        case .customTargetDays:
            return (self.pikerViewData as! Array<DataOption>)[row].title
        default:
            print("Switch pop up type error, in 'PopUpViewController' UIPickerViewDelegate")
        }
        
        return "Error"
       
    }
    
   
    
}
