//
//  CustomTargetViewBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 29/12/20.
//

import Foundation
import UIKit

enum PopUpType {
    case customTargetDays
    case customItemName
    case customFrequency
}

class PopUpViewBuilder {
    
    var popUpWindow: UIView
    var setting: SystemStyleSetting
    let popUpType: PopUpType
    var popUpViewController: PopUpViewController?
    
    init(popUpType: PopUpType) {
        self.setting = SystemStyleSetting.shared
        self.popUpWindow = UIView()
        self.popUpType = popUpType
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let popUpViewController = storyboard.instantiateViewController(withIdentifier: "popUpView") as? PopUpViewController {
            self.popUpViewController = popUpViewController
            self.popUpViewController?.type = popUpType
        } else {
            self.popUpViewController = nil
        }
       
        
    }
    
    public func buildPopUpView() -> PopUpViewController? {
        
        popUpViewController?.view.addSubview(popUpWindow)
        
        switch popUpType {
        case .customTargetDays:
            self.buildCustomTargetDaysView()
            return popUpViewController
        case .customItemName:
            self.buildCustomItemNameView()
            return popUpViewController
        case .customFrequency:
            self.buildCustomFrequencyView()
            return popUpViewController
        }
    }
    
    private func buildStandardView() { // common views for pop up window
        createPopUpUIViews()
        addCancelButton()
        addDoneButton()
        
    }
    
    private func buildCustomTargetDaysView(){
        buildStandardView()
        addTitleLabel(title: "自定义目标")
        addTargetPiker()
        addPopUpWindowToBgView()
  
    }
    
    private func buildCustomItemNameView() {
        buildStandardView()
        addTextField()
        addTitleLabel(title: "自定义项目名")
        addPromptLabel()
        addPopUpWindowToBgView()
    }
    
    private func buildCustomFrequencyView() {
        
        buildStandardView()
        addTitleLabel(title: "自定义频率")
        addFrequencyPicker()
        
    }
    
    
    // Building common fetures
    private func createPopUpUIViews() {
        
        // Tag 0
        popUpWindow.backgroundColor = setting.whiteAndBlack
        popUpWindow.frame = CGRect(x: 0, y: 0, width: setting.screenFrame.width, height: setting.popUpWindowHeight)
        popUpWindow.layer.cornerRadius = setting.popUpWindowCornerRadius
        popUpWindow.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        popUpWindow.tag = 0
    }
    
    private func addCancelButton() { // Tag 2
        
        let cancelButton = UIButton()
   
        cancelButton.setBackgroundImage(#imageLiteral(resourceName: "CancelButton"), for: .normal)
        cancelButton.tag = 2
        cancelButton.addTarget(self, action: #selector(popUpViewController?.cancelButtonPressed(_:)), for: .touchDown)
        self.popUpWindow.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        cancelButton.topAnchor.constraint(equalTo: popUpWindow.topAnchor, constant: self.setting.mainDistance).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: popUpWindow.rightAnchor, constant: -self.setting.mainDistance).isActive = true
        
        
    }
    
    private func addDoneButton() { // Tag 3
        let doneButton = UIButton()
        doneButton.backgroundColor = UserStyleSetting.themeColor
        doneButton.setTitle("确定", for: .normal)
        doneButton.layer.cornerRadius = self.setting.mainButtonCornerRadius
        doneButton.tag = setting.popUpWindowDoneButtonTag
        doneButton.addTarget(self, action: #selector(popUpViewController?.doneButtonPressed(_:)), for: .touchDown)
        self.popUpWindow.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.bottomAnchor.constraint(equalTo: self.popUpWindow.bottomAnchor, constant: -self.setting.mainDistance - 20).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: self.popUpWindow.centerXAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: self.setting.mainButtonHeight).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: self.setting.screenFrame.width - 2 * self.setting.mainDistance).isActive = true
        
        
    }
    

    
    
    // ---------------------------------------------------------------------------------
    private func addTargetPiker() {
        
        let picker = UIPickerView()
        picker.backgroundColor = SystemStyleSetting.shared.whiteAndBlack
        picker.tag = self.setting.popUpWindowPickerViewTag
        picker.delegate = popUpViewController
        picker.dataSource = popUpViewController
        popUpViewController?.pikerViewData = PickerViewData.customTargetDays
        popUpWindow.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.widthAnchor.constraint(equalToConstant: self.setting.screenFrame.width - 2 * self.setting.mainDistance).isActive = true
        picker.centerXAnchor.constraint(equalTo: self.popUpWindow.centerXAnchor).isActive = true
        picker.centerYAnchor.constraint(equalTo: self.popUpWindow.centerYAnchor).isActive = true
    }
    
    private func addFrequencyPicker() {
        
        let picker = UIPickerView()
        picker.backgroundColor = SystemStyleSetting.shared.whiteAndBlack
        picker.tag = self.setting.popUpWindowPickerViewTag
        picker.delegate = popUpViewController
        picker.dataSource = popUpViewController
        popUpViewController?.pikerViewData = PickerViewData.customFrequency
        popUpWindow.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.widthAnchor.constraint(equalToConstant: self.setting.screenFrame.width - 2 * self.setting.mainDistance).isActive = true
        picker.centerXAnchor.constraint(equalTo: self.popUpWindow.centerXAnchor).isActive = true
        picker.centerYAnchor.constraint(equalTo: self.popUpWindow.centerYAnchor).isActive = true
    }
    
    private func addTitleLabel(title: String) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UserStyleSetting.fontLarge
        titleLabel.sizeToFit()
        
        self.popUpWindow.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: popUpWindow.topAnchor, constant: 50).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: popUpWindow.leftAnchor, constant: self.setting.mainDistance).isActive = true
    }
    
    
    private func addTextField() {
        let textField = UITextField()
        textField.backgroundColor = self.setting.greyColor
        textField.layer.cornerRadius = self.setting.textFieldCornerRadius
        textField.placeholder = "  请输入自定义名字"
        textField.tag = self.setting.popUpWindowTextFieldTag
        textField.addTarget(self, action: #selector(popUpViewController?.textFieldTapped(_:)), for: .touchDown)
        
        self.popUpWindow.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.widthAnchor.constraint(equalToConstant: self.setting.screenFrame.width - 2 * self.setting.mainDistance).isActive = true
        textField.heightAnchor.constraint(equalToConstant: self.setting.textFieldHeight).isActive = true
        textField.centerXAnchor.constraint(equalTo: self.popUpWindow.centerXAnchor).isActive = true
        textField.centerYAnchor.constraint(equalTo: self.popUpWindow.centerYAnchor, constant: -setting.mainButtonHeight).isActive = true
    }
    
    private func addPromptLabel() {
        let promptLabel = UILabel()
        promptLabel.text = "请输入项目名字"
        promptLabel.font = UserStyleSetting.fontMedium
        promptLabel.sizeToFit()
        promptLabel.textColor = UIColor.red
        promptLabel.tag = self.setting.popUpWindowPromptLabelTag
        promptLabel.isHidden = true
        
        self.popUpWindow.addSubview(promptLabel)
        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        promptLabel.topAnchor.constraint(equalTo: popUpWindow.topAnchor, constant: 180).isActive = true
        promptLabel.leftAnchor.constraint(equalTo: popUpWindow.leftAnchor, constant: self.setting.mainDistance).isActive = true
        
    }
    
    private func addPopUpWindowToBgView() {
        popUpViewController?.view.addSubview(popUpWindow)
    }
    
   
}
