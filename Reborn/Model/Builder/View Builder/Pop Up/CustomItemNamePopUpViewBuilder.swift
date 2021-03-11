//
//  CustomItemNamePopUpViewBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 25/2/21.
//

import Foundation
import UIKit

class CustomItemNamePopUpViewBuilder: PopUpViewBuilder {
    
    override func buildView() -> UIView {
        _ = super.buildView()
        self.setUpUI()
        self.addTextField()
        self.addPromptLabel()
        return super.outPutView
    }
    
    private func setUpUI() {
        super.titleLabel.text = "自定义项目名"
    }
   
    private func addTextField() {
        let textField = UITextField()
        textField.accessibilityIdentifier = "TextField"
        textField.backgroundColor = AppEngine.shared.userSetting.whiteAndBlackContent
        textField.layer.cornerRadius = self.setting.textFieldCornerRadius
        textField.placeholder = "  请输入自定义名字"
        textField.tag = self.setting.popUpWindowTextFieldTag
        textField.addTarget(popUpViewController, action: #selector(popUpViewController.textFieldTapped(_:)), for: .touchDown)
        
        super.contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.widthAnchor.constraint(equalToConstant: super.outPutView.frame.width - 2 * self.setting.mainDistance).isActive = true
        textField.heightAnchor.constraint(equalToConstant: self.setting.textFieldHeight).isActive = true
        textField.centerXAnchor.constraint(equalTo: super.contentView.centerXAnchor).isActive = true
        textField.centerYAnchor.constraint(equalTo: super.contentView.centerYAnchor, constant: -setting.mainButtonHeight).isActive = true
    }
    
    private func addPromptLabel() {
        let promptLabel = UILabel()
        promptLabel.accessibilityIdentifier = "PromptLabel"
        promptLabel.text = "请输入项目名字"
        promptLabel.font = AppEngine.shared.userSetting.fontMedium
        promptLabel.sizeToFit()
        promptLabel.textColor = UIColor.red
        promptLabel.tag = self.setting.popUpWindowPromptLabelTag
        promptLabel.isHidden = true
        
        super.contentView.addSubview(promptLabel)
        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        promptLabel.topAnchor.constraint(equalTo: super.contentView.getSubviewBy(idenifier: "TextField")!.bottomAnchor, constant: SystemSetting.shared.mainDistance).isActive = true
        promptLabel.leftAnchor.constraint(equalTo: super.contentView.leftAnchor).isActive = true
        
    }

}
