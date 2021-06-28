//
//  PopUpViewController.swift
//  Reborn
//
//  Created by Christian Liu on 1/1/21.
//

import UIKit

class PopUpViewController: UIViewController {
    
    private let setting: SystemSetting = SystemSetting.shared
    private var keyboardFrame: CGRect?
    private var presentDuration: Double = SystemSetting.shared.popUpWindowPresentShortDuration
    private var keyboardDidShowFully: Bool = false
    private var pickerViewSelectedRow: Int = 0
    
    public var popUp: PopUpImpl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppEngine.shared.add(observer: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(keyboardShowNotification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide(keyboardShowNotification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        popUp?.viewDidLoad()
        updateUI()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        popUp?.viewDidLayoutSubviews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        popUp?.viewDidAppear()
        popUp?.excuteAnimation()
    }
    
    @objc
    func doneButtonPressed(_ sender: UIButton!) {
       
        if popUp != nil, popUp!.isReadyToDismiss() {
            AppEngine.shared.dismissBottomPopUpAndSave(self)
        }
    }
    
   
    
    @objc
    func cancelButtonPressed(_ sender: UIButton!) {
        AppEngine.shared.dismissBottomPopUpWithoutSave(self)
    }

    
    @objc
    func keyboardWillShow(keyboardShowNotification notification: Notification) {
        
        if let animationType = self.popUp?.presentAnimationType, animationType == .slideInToBottom {
            
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
            
       
        
    }
    
    @objc
    func keyboardDidHide(keyboardShowNotification notification: Notification) {
        print("KeyboardDidHide")
    }
    
    @objc
    func textFieldTapped(_ sender: UITextField!) {
        if let popUp = popUp as? CustomItemNamePopUpView {
            popUp.hidePromptLabel(true)
        }
        
    }


    public func getStoredData() -> Any {
        return popUp?.getStoredData() ?? "Error"
    }
}

extension PopUpViewController: UIObserver {
    func updateUI() {
 
        if popUp != nil {
            
            self.view.removeAllSubviews()
            self.popUp!.window = self.popUp!.createWindow()
            self.view.addSubview(self.popUp!.window)
            self.popUp!.updateUI()
        }
        
        
        
    }
    
    
}

extension PopUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension PopUpViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if let pickerViewPopUp = self.popUp as? PickerViewPopUp {
            return  pickerViewPopUp.numberOfComponents()
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if let pickerViewPopUp = self.popUp as? PickerViewPopUp {
            return  pickerViewPopUp.numberOfRowsInComponents()
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if let pickerViewPopUp = self.popUp as? PickerViewPopUp {
            return  pickerViewPopUp.titles()[row]
        } else {
            return "Failed to load data"
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let pickerViewPopUp = self.popUp as? PickerViewPopUp {
            pickerViewPopUp.didSelectRow()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if let pickerViewPopUp = self.popUp as? PickerViewPopUp {
            let pickerLabel = UILabel()
            pickerLabel.textAlignment = .center
            pickerLabel.text = pickerViewPopUp.titles()[row]
            return pickerLabel
        } else {
            return UIView()
        }
      
    }
    
    
   
    
}
