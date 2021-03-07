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
    private var popUpWindow = UIView()
    
    public var item: Item?
    public var type: PopUpType?
    public var animationType: PopUpAnimationType?
    public var dataStartIndex: Int = 0
    public var pikerViewData: Array<Any> = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(keyboardShowNotification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide(keyboardShowNotification:)), name: UIResponder.keyboardDidHideNotification, object: nil)

    }

    
    @objc
    func doneButtonPressed(_ sender: UIButton!) {
       
        
        switch type {
        case .customFrequencyPopUp:
            AppEngine.shared.dismissBottomPopUpAndSave(thenGoBackTo: self)
        case .customTargetDaysPopUp:
            AppEngine.shared.dismissBottomPopUpAndSave(thenGoBackTo: self)
        case .customItemNamePopUp:
            if let textField = self.popUpWindow.getSubviewBy(idenifier: "ContentView")?.getSubviewBy(tag: self.setting.popUpWindowTextFieldTag) as? UITextField {
                
                if textField.text != "" {
                    AppEngine.shared.dismissBottomPopUpAndSave(thenGoBackTo: self)
                } else {
                    
                    self.hidePromptLabel(false)
                }
            }
        case .customThemeColorPopUp:
            AppEngine.shared.dismissBottomPopUpAndSave(thenGoBackTo: self)
        default:
            AppEngine.shared.dismissBottomPopUpWithoutSave(thenGoBackTo: self)
        }
            
    }
    
    func hidePromptLabel(_ isHidden: Bool) {
       
        
        if let promptLabel = self.popUpWindow.getSubviewBy(tag: self.setting.popUpWindowPromptLabelTag) as? UILabel {
            
            promptLabel.isHidden = isHidden
        }
        
        
    }
    
    @objc
    func cancelButtonPressed(_ sender: UIButton!) {
        AppEngine.shared.dismissBottomPopUpWithoutSave(thenGoBackTo: self)
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
    
    func showTitleLabel() {
        if let titleLabel = self.view.getSubviewBy(idenifier: "ContentView")?.getSubviewBy(idenifier: "TitleLabel") {
            UIView.animate(withDuration: 10, delay: 2, animations: {
                titleLabel.alpha = 0.5
            })
        }
        
    }

    public func getStoredData() -> Any {
        
        var storedData: Any?
        
        switch type {
        case .customFrequencyPopUp:
            
            if let pickerView = popUpWindow.getSubviewBy(idenifier: "ContentView")?.getSubviewBy(tag: self.setting.popUpWindowPickerViewTag) as? UIPickerView {
                storedData = self.pikerViewData[pickerView.selectedRow(inComponent: 0)]
            }
            
        case .customItemNamePopUp:
            
            if let textField = popUpWindow.getSubviewBy(idenifier: "ContentView")?.getSubviewBy(tag: self.setting.popUpWindowTextFieldTag) as? UITextField {
                if let text = textField.text {
                    storedData = text
                }
            }
            
        case .customTargetDaysPopUp:
            
            if let pickerView = popUpWindow.getSubviewBy(idenifier: "ContentView")?.getSubviewBy(tag: self.setting.popUpWindowPickerViewTag) as? UIPickerView {
                storedData = self.pikerViewData[pickerView.selectedRow(inComponent: 0)]
            }
           
        default:
            print("Switch pop up type error, In 'PopUpViewController'")
        }
        
        return storedData ?? "Error"
    }
}

extension PopUpViewController: UIObserver {
    func updateUI() {
        
        let popUpWindowFrame: CGRect
        
        
        switch animationType {
        case .fadeInFromCenter:
            
            let widthProportion: CGFloat = 0.9
            let heightProportion: CGFloat = 0.6
           
            popUpWindowFrame = CGRect(x: (self.view.frame.width - self.view.frame.width * widthProportion) / 2, y: (self.view.frame.height - self.view.frame.height * heightProportion) / 2, width: self.view.frame.width * widthProportion, height: self.view.frame.height * heightProportion)
        case .slideInToBottom:
            popUpWindowFrame = CGRect(x: 0, y: self.view.frame.height - self.setting.popUpWindowHeight, width: setting.screenFrame.width, height: setting.popUpWindowHeight)
        case .slideInToCenter:
            let widthProportion: CGFloat = 0.9
            let heightProportion: CGFloat = 0.5
            popUpWindowFrame =  CGRect(x: (self.view.frame.width - self.view.frame.width * widthProportion) / 2, y: (self.view.frame.height - self.view.frame.height * heightProportion) / 2, width: self.view.frame.width * widthProportion, height: self.view.frame.height * heightProportion)
        case nil:
            popUpWindowFrame = CGRect(x: 0, y: self.view.frame.height - self.setting.popUpWindowHeight, width: setting.screenFrame.width, height: setting.popUpWindowHeight)
        }
        
        switch type {
        case .customFrequencyPopUp:
            popUpWindow = CustomFrequencyPopUpViewBuilder(dataStartIndex: dataStartIndex, popUpViewController: self, frame: popUpWindowFrame).buildView()
        case .customItemNamePopUp:
            popUpWindow = CustomItemNamePopUpViewBuilder(popUpViewController: self, frame: popUpWindowFrame).buildView()
        case .customTargetDaysPopUp:
            popUpWindow = CustomTargetDaysPopUpViewBuilder(dataStartIndex: dataStartIndex, popUpViewController: self, frame: popUpWindowFrame).buildView()
        case .customThemeColorPopUp:
            popUpWindow = CustomThemeColorPopUpViewBuilder(popUpViewController: self, frame: popUpWindowFrame).buildView()
        case .itemCompletedPopUp:
            if item != nil {
                popUpWindow = ItemCompletedPopUpViewBuilder(popUpViewController: self, frame: popUpWindowFrame, item: item!).buildView()
                showTitleLabel()
            }
        case nil:
            break
        }
        
        popUpWindow.accessibilityIdentifier = "PopUpWindow"
        self.view.addSubview(popUpWindow)
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
        case .customFrequencyPopUp:
            return (self.pikerViewData as! Array<Frequency>)[row].dataModel.title
        case .customItemNamePopUp:
            break
        case .customTargetDaysPopUp:
            return (self.pikerViewData as! Array<DataModel>)[row].title
        default:
            print("Switch pop up type error, in 'PopUpViewController' UIPickerViewDelegate")
        }
        
        return "Error"
       
    }
    
   
    
}
