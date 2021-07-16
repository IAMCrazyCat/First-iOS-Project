//
//  CustomUserNamePopUp.swift
//  Reborn
//
//  Created by Christian Liu on 11/3/21.
//

import Foundation
import UIKit
class CustomUserInformationPopUp: PopUpImpl {
    
    var textField: UITextField? {
        return super.contentView?.getSubviewBy(idenifier: "TextField") as? UITextField
    }
    
    var promptLabel: UILabel? {
        return super.contentView?.getSubviewBy(idenifier: "PromptLabel") as? UILabel
    }
    
    var maleButton: UIButton? {
        return super.contentView?.getSubviewBy(idenifier: "MaleButton") as? UIButton
    }
    
    var femaleButton: UIButton? {
        return super.contentView?.getSubviewBy(idenifier: "FemaleButton") as? UIButton
    }
    
    var otherButton: UIButton? {
        return super.contentView?.getSubviewBy(idenifier: "OtherButton") as? UIButton
    }
    
    var secretButton: UIButton? {
        return super.contentView?.getSubviewBy(idenifier: "SecretButton") as? UIButton
    }
    
    
    
    var selectedGender: Gender = AppEngine.shared.currentUser.gender
    
    
    init(presentAnimationType: PopUpAnimationType, size: PopUpSize = .small, popUpViewController: PopUpViewController) {
        super.init(presentAnimationType: presentAnimationType, type: .customUserInformationPopUp, size: size, popUpViewController: popUpViewController)
        maleButton?.addTarget(self, action: #selector(self.genderButtonPressed(_:)), for: .touchUpInside)
        femaleButton?.addTarget(self, action: #selector(self.genderButtonPressed(_:)), for: .touchUpInside)
        otherButton?.addTarget(self, action: #selector(self.genderButtonPressed(_:)), for: .touchUpInside)
        secretButton?.addTarget(self, action: #selector(self.genderButtonPressed(_:)), for: .touchUpInside)
    }
   
    
    override func createWindow() -> UIView {
        return CustomUserInformationPopUpViewBuilder(userName: AppEngine.shared.currentUser.name, userGender: AppEngine.shared.currentUser.gender, popUpViewController: super.popUpViewController, frame: super.frame).buildView()
    }
    
    override func getStoredData() -> Any {
        return [self.textField?.text ?? "没有名字", self.selectedGender.name]
    }
    
    override func updateUI() {
        textField?.delegate = super.popUpViewController
    }
    
    override func isReadyToDismiss() -> Bool {
        if self.textField?.text != "" {
            return true
        } else {
            self.hidePromptLabel(false)
        }
        return false
    }
    

    
    func hidePromptLabel(_ isHidden: Bool) {
        self.promptLabel?.isHidden = isHidden
    }
    
    @objc func genderButtonPressed(_ sender: UIButton!) {
        maleButton?.isSelected = false
        femaleButton?.isSelected = false
        otherButton?.isSelected = false
        secretButton?.isSelected = false
        sender.isSelected = true
        
        for gender in Gender.allCases {
            if gender.name == sender.currentTitle {
                self.selectedGender = gender
            }
        }
    }
}
