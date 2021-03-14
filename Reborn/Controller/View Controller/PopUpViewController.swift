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
    
    public var popUp: PopUpImpl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppEngine.shared.add(observer: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(keyboardShowNotification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide(keyboardShowNotification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        popUp?.updateUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        popUp?.excuteAnimation()
    }
    
    @objc
    func doneButtonPressed(_ sender: UIButton!) {
       
        if popUp != nil, popUp!.isReadyToDismiss() {
            AppEngine.shared.dismissBottomPopUpAndSave(thenGoBackTo: self)
        }
    }
    
   
    
    @objc
    func cancelButtonPressed(_ sender: UIButton!) {
        AppEngine.shared.dismissBottomPopUpWithoutSave(thenGoBackTo: self)
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
            self.view.addSubview(self.popUp!.createWindow())
        }
        
        
    }
    
    
}

extension PopUpViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if let popUp = self.popUp as? CustomFrequencyPopUp {
            return popUp.pikerViewData.count
        } else if let popUp = self.popUp as? CustomTargetDaysPopUp {
            return popUp.pikerViewData.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if let popUp = self.popUp as? CustomFrequencyPopUp {
            let pickerviewData = popUp.pikerViewData as! Array<Frequency>

            return pickerviewData[row].dataModel.title
        } else if let popUp = self.popUp as? CustomTargetDaysPopUp {
            let pickerviewData = popUp.pikerViewData as! Array<CustomData>
            return pickerviewData[row].title
        }
        
        return "Error Picker view dsta"

    }
    
   
    
}
