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

class ButtomPopUpBuilder {
    
    var popUpBgView: UIView
    var popUpWindow: UIView
    var width: CGFloat
    var setting: SystemStyleSetting
    let popUpType: PopUpType
    init(popUpType: PopUpType) {
        self.setting = SystemStyleSetting.shared
        self.width = setting.viewFrame.width
        self.popUpBgView = UIView()
        self.popUpWindow = UIView()
        self.popUpType = popUpType
      
        
    }
    
    public func buildPopUpView() -> PopUpView {
        
        switch popUpType {
        case .customTargetDays:
            self.buildCustomTargetDaysView()
            return PopUpView(popUpView: popUpBgView)
        case .customItemName:
            self.buildCustomItemNameView()
            return PopUpView(popUpView: popUpBgView, pikerViewDataArray: PickerViewData.customTargetDays)
        case .customFrequency:
            self.buildCustomFrequencyView()
            return PopUpView(popUpView: popUpBgView)
        }
    }
    
    public func buildStandardView() { // common views for pop up window
        createPopUpUIViews()
        addPopUpBgViewButton()
        addCancelButton()
        addDoneButton()
        
    }
    
    private func buildCustomTargetDaysView(){
        buildStandardView()
        addTitleLabel(title: "自定义日期")
        
        addPopUpWindowToBgView()
  
    }
    
    private func buildCustomItemNameView() {
        buildStandardView()
        addTextField()
        addTitleLabel(title: "自定义项目")
        addPromptLabel()
        addPopUpWindowToBgView()
    }
    
    private func buildCustomFrequencyView() {
        createPopUpUIViews()
        addFrequencyOptionButtons()
        addCancelButton()
        addDoneButton()
        
    }
    
    
    // Building common fetures
    private func createPopUpUIViews() {
        
        popUpBgView.frame = CGRect(x: 0, y: 0, width: setting.viewFrame.width, height: setting.viewFrame.height)
        popUpBgView.backgroundColor = UIColor.gray.withAlphaComponent(0)
        
        // Tag 0
        popUpWindow.backgroundColor = UIColor.white
        popUpWindow.frame = CGRect(x: 0, y: setting.viewFrame.height, width: self.width, height: setting.popUpWindowHeight)
        popUpWindow.layer.cornerRadius = setting.popUpWindowCornerRadius
        popUpWindow.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        popUpWindow.tag = 0
    }
    
    private func addPopUpBgViewButton() { // Tag 1
        let popUpBgViewButton = UIButton()
        popUpBgViewButton.frame = self.popUpBgView.frame
        self.popUpBgView.addSubview(popUpBgViewButton)
        popUpBgViewButton.tag = setting.popUpBGViewButtonTag
    }
    
  
    
    private func addCancelButton() { // Tag 2
        let cancelButton = UIButton()
        cancelButton.setBackgroundImage(#imageLiteral(resourceName: "CancelButton"), for: .normal)
        self.popUpWindow.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        cancelButton.topAnchor.constraint(equalTo: popUpWindow.topAnchor, constant: self.setting.mainDistance).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: popUpWindow.rightAnchor, constant: -self.setting.mainDistance).isActive = true
        cancelButton.tag = 2
        
    }
    
    private func addDoneButton() { // Tag 3
        let doneButton = UIButton()
        doneButton.backgroundColor = UserStyleSetting.themeColor
        doneButton.setTitle("确定", for: .normal)
        doneButton.layer.cornerRadius = self.setting.mainButtonCornerRadius
        self.popUpWindow.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.bottomAnchor.constraint(equalTo: self.popUpWindow.bottomAnchor, constant: -self.setting.mainDistance - 20).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: self.popUpWindow.centerXAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: self.setting.mainButtonHeight).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: self.setting.viewFrame.width - 2 * self.setting.mainDistance).isActive = true
        
        doneButton.tag = setting.popUpWindowDoneButtonTag
    }
    
    
    
    // ---------------------------------------------------------------------------------
    private func addTargetPiker() {
        
        let picker = UIPickerView()
        picker.tag = self.setting.popUpWindowPickerView
        popUpWindow.addSubview(picker)
    }
    
    private func addFrequencyOptionButtons() {
        
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
        
        self.popUpWindow.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.widthAnchor.constraint(equalToConstant: self.setting.viewFrame.width - 2 * self.setting.mainDistance).isActive = true
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
        popUpBgView.addSubview(popUpWindow)
    }
    
   
}
