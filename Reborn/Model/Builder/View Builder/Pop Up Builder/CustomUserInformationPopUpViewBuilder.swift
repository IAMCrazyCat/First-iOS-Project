//
//  CustomUserNamePopUpViewBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 11/3/21.
//

import Foundation
import UIKit
class CustomUserInformationPopUpViewBuilder: PopUpViewBuilder {
    var userName: String
    var userGender: Gender
    
    init(userName: String, userGender: Gender, popUpViewController: PopUpViewController, frame: CGRect) {
        self.userName = userName
        self.userGender = userGender
        super.init(popUpViewController: popUpViewController, frame: frame)
    }
    
    
    override func buildView() -> UIView {
        super.buildView()
        self.setUpUI()
        self.addTextField()
        self.addPromptLabel()
        addGenderButtons()
        return super.outPutView
    }
    
    private func setUpUI() {
        super.titleLabel.text = "编辑个人信息"
    }
   
    private func addTextField() {
        
        let textFieldTitleLabel = UILabel()
        textFieldTitleLabel.text = "名称"
        textFieldTitleLabel.font = AppEngine.shared.userSetting.mediumFont
        textFieldTitleLabel.textColor = .label

        super.contentView.addSubview(textFieldTitleLabel)
        textFieldTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        textFieldTitleLabel.topAnchor.constraint(equalTo: super.contentView.topAnchor, constant: 0).isActive = true
        textFieldTitleLabel.leftAnchor.constraint(equalTo: super.contentView.leftAnchor).isActive = true
        
        let textField = UITextField()
        textField.setPadding()
        textField.tintColor = AppEngine.shared.userSetting.themeColor.uiColor
        textField.accessibilityIdentifier = "TextField"
        textField.backgroundColor = SystemSetting.shared.grayColor.withAlphaComponent(0.3)
        textField.layer.cornerRadius = self.setting.textFieldCornerRadius
        textField.text = "\(self.userName)"
        textField.tag = self.setting.popUpWindowTextFieldTag
        textField.returnKeyType = .done
        textField.addTarget(popUpViewController, action: #selector(popUpViewController.textFieldTapped(_:)), for: .touchDown)
        
        super.contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.widthAnchor.constraint(equalToConstant: super.outPutView.frame.width - 2 * self.setting.mainDistance).isActive = true
        textField.heightAnchor.constraint(equalToConstant: self.setting.textFieldHeight).isActive = true
        textField.leftAnchor.constraint(equalTo: super.contentView.leftAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: textFieldTitleLabel.bottomAnchor, constant: SystemSetting.shared.mainGap).isActive = true
        
       
    }
    
    private func addPromptLabel() {
        let promptLabel = UILabel()
        promptLabel.accessibilityIdentifier = "PromptLabel"
        promptLabel.text = "请输入您的名字"
        promptLabel.font = AppEngine.shared.userSetting.mediumFont
        promptLabel.sizeToFit()
        promptLabel.textColor = UIColor.red
        promptLabel.tag = self.setting.popUpWindowPromptLabelTag
        promptLabel.isHidden = true
        
        super.contentView.addSubview(promptLabel)
        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        promptLabel.topAnchor.constraint(equalTo: super.contentView.getSubviewBy(idenifier: "TextField")!.bottomAnchor, constant: 10).isActive = true
        promptLabel.leftAnchor.constraint(equalTo: super.contentView.leftAnchor).isActive = true
        
    }
    
    private func addGenderButtons() {
        
        let genderTitleLabel = UILabel()
        genderTitleLabel.text = "性别"
        genderTitleLabel.font = AppEngine.shared.userSetting.mediumFont
        genderTitleLabel.textColor = .label

        super.contentView.addSubview(genderTitleLabel)
        genderTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        genderTitleLabel.topAnchor.constraint(equalTo: super.contentView.getSubviewBy(idenifier: "TextField")!.bottomAnchor, constant: SystemSetting.shared.mainGap * 2).isActive = true
        genderTitleLabel.leftAnchor.constraint(equalTo: super.contentView.getSubviewBy(idenifier: "TextField")!.leftAnchor).isActive = true
        

        let maleButton = UIButton()
        maleButton.accessibilityIdentifier = "MaleButton"
        maleButton.setTitle("\(Gender.male.rawValue)", for: .normal)
       
        
        super.contentView.addSubview(maleButton)
        maleButton.translatesAutoresizingMaskIntoConstraints = false
        maleButton.leftAnchor.constraint(equalTo: super.contentView.leftAnchor, constant: 0).isActive = true
        maleButton.topAnchor.constraint(equalTo: genderTitleLabel.bottomAnchor, constant: SystemSetting.shared.mainGap).isActive = true
        maleButton.setOptionButtonAppearance()
        
        
        
        let femaleButton = UIButton()
        femaleButton.accessibilityIdentifier = "FemaleButton"
        femaleButton.setTitle("\(Gender.female.rawValue)", for: .normal)
        
        super.contentView.addSubview(femaleButton)
        femaleButton.translatesAutoresizingMaskIntoConstraints = false
        femaleButton.rightAnchor.constraint(equalTo: super.contentView.rightAnchor, constant: 0).isActive = true
        femaleButton.topAnchor.constraint(equalTo: genderTitleLabel.bottomAnchor, constant: SystemSetting.shared.mainGap).isActive = true
        femaleButton.setOptionButtonAppearance()
        
        
        
        let secretButton = UIButton()
        secretButton.accessibilityIdentifier = "SecretButton"
        secretButton.setTitle("\(Gender.secret.rawValue)", for: .normal)
        
        super.contentView.addSubview(secretButton)
        secretButton.translatesAutoresizingMaskIntoConstraints = false
        secretButton.leftAnchor.constraint(equalTo: super.contentView.leftAnchor, constant: 0).isActive = true
        secretButton.topAnchor.constraint(equalTo: maleButton.bottomAnchor, constant: SystemSetting.shared.mainGap).isActive = true
        secretButton.setOptionButtonAppearance()
        
        
        switch self.userGender {
        case .male:
            maleButton.isSelected = true
        case .female:
            femaleButton.isSelected = true
        default:
            secretButton.isSelected = true
        }
        
       
        
    }
}
