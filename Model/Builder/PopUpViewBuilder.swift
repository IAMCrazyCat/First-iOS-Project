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

class PopUpViewBuilder: Builder {
    
    private var outPutView: UIView
    private var setting: SystemStyleSetting
    private let popUpType: PopUpType
    private var popUpViewController: PopUpViewController?
    private var dataStartIndex: Int
    init(popUpType: PopUpType, dataStartIndex: Int = 0, popUpViewController: PopUpViewController) {
        self.setting = SystemStyleSetting.shared
        self.outPutView = UIView()
        self.popUpType = popUpType
        self.dataStartIndex = dataStartIndex
        self.popUpViewController = popUpViewController
    }
    
    public func buildView() -> UIView {
        
        
        
        switch popUpType {
        case .customTargetDays:
            self.buildCustomTargetDaysView()
        case .customItemName:
            self.buildCustomItemNameView()
        case .customFrequency:
            self.buildCustomFrequencyView()

        }
        
        return outPutView
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
        outPutView.backgroundColor = setting.whiteAndBlack
        outPutView.frame = CGRect(x: 0, y: 0, width: setting.screenFrame.width, height: setting.popUpWindowHeight)
        outPutView.layer.cornerRadius = setting.popUpWindowCornerRadius
        outPutView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        outPutView.tag = 0
    }
    
    private func addCancelButton() { // Tag 2
        
        let cancelButton = UIButton()
   
        cancelButton.setBackgroundImage(#imageLiteral(resourceName: "CancelButton"), for: .normal)
        cancelButton.tag = 2
        cancelButton.addTarget(self, action: #selector(popUpViewController?.cancelButtonPressed(_:)), for: .touchDown)
        self.outPutView.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        cancelButton.topAnchor.constraint(equalTo: outPutView.topAnchor, constant: self.setting.mainDistance).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: outPutView.rightAnchor, constant: -self.setting.mainDistance).isActive = true
        
        
    }
    
    private func addDoneButton() { // Tag 3
        let doneButton = UIButton()
        doneButton.backgroundColor = UserStyleSetting.themeColor
        doneButton.setTitle("确定", for: .normal)
        doneButton.layer.cornerRadius = self.setting.mainButtonCornerRadius
        doneButton.tag = setting.popUpWindowDoneButtonTag
        doneButton.addTarget(self, action: #selector(popUpViewController?.doneButtonPressed(_:)), for: .touchDown)
        self.outPutView.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.bottomAnchor.constraint(equalTo: self.outPutView.bottomAnchor, constant: -self.setting.mainDistance - 20).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: self.outPutView.centerXAnchor).isActive = true
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
        
        var dataArray = PickerViewData.customTargetDays
        if dataStartIndex > 0 {
            for _ in 0 ... dataStartIndex - 1 {
                
                if dataArray.count > 0 {
                    dataArray.removeFirst()
                }
                
            }
        }
        
        popUpViewController?.pikerViewData = dataArray
        outPutView.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.widthAnchor.constraint(equalToConstant: self.setting.screenFrame.width - 2 * self.setting.mainDistance).isActive = true
        picker.centerXAnchor.constraint(equalTo: self.outPutView.centerXAnchor).isActive = true
        picker.centerYAnchor.constraint(equalTo: self.outPutView.centerYAnchor).isActive = true
    }
    
    private func addFrequencyPicker() {
        
        let picker = UIPickerView()
        picker.backgroundColor = SystemStyleSetting.shared.whiteAndBlack
        picker.tag = self.setting.popUpWindowPickerViewTag
        picker.delegate = popUpViewController
        picker.dataSource = popUpViewController
        
        var dataArray = PickerViewData.customFrequency
        if dataStartIndex > 0 {
            for _ in 0 ... dataStartIndex - 1 {
                if dataArray.count > 0 {
                    dataArray.removeFirst()
                }
            }
        }
        
        popUpViewController?.pikerViewData = dataArray
        outPutView.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.widthAnchor.constraint(equalToConstant: self.setting.screenFrame.width - 2 * self.setting.mainDistance).isActive = true
        picker.centerXAnchor.constraint(equalTo: self.outPutView.centerXAnchor).isActive = true
        picker.centerYAnchor.constraint(equalTo: self.outPutView.centerYAnchor).isActive = true
    }
    
    private func addTitleLabel(title: String) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UserStyleSetting.fontLarge
        titleLabel.sizeToFit()
        
        self.outPutView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: outPutView.topAnchor, constant: 50).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: outPutView.leftAnchor, constant: self.setting.mainDistance).isActive = true
    }
    
    
    private func addTextField() {
        let textField = UITextField()
        textField.backgroundColor = self.setting.greyColor
        textField.layer.cornerRadius = self.setting.textFieldCornerRadius
        textField.placeholder = "  请输入自定义名字"
        textField.tag = self.setting.popUpWindowTextFieldTag
        textField.addTarget(self, action: #selector(popUpViewController?.textFieldTapped(_:)), for: .touchDown)
        
        self.outPutView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.widthAnchor.constraint(equalToConstant: self.setting.screenFrame.width - 2 * self.setting.mainDistance).isActive = true
        textField.heightAnchor.constraint(equalToConstant: self.setting.textFieldHeight).isActive = true
        textField.centerXAnchor.constraint(equalTo: self.outPutView.centerXAnchor).isActive = true
        textField.centerYAnchor.constraint(equalTo: self.outPutView.centerYAnchor, constant: -setting.mainButtonHeight).isActive = true
    }
    
    private func addPromptLabel() {
        let promptLabel = UILabel()
        promptLabel.text = "请输入项目名字"
        promptLabel.font = UserStyleSetting.fontMedium
        promptLabel.sizeToFit()
        promptLabel.textColor = UIColor.red
        promptLabel.tag = self.setting.popUpWindowPromptLabelTag
        promptLabel.isHidden = true
        
        self.outPutView.addSubview(promptLabel)
        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        promptLabel.topAnchor.constraint(equalTo: outPutView.topAnchor, constant: 180).isActive = true
        promptLabel.leftAnchor.constraint(equalTo: outPutView.leftAnchor, constant: self.setting.mainDistance).isActive = true
        
    }
    
    private func addPopUpWindowToBgView() {
        popUpViewController?.view.addSubview(outPutView)
    }
    
   
}
