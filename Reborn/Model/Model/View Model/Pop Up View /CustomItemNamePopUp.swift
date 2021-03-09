//
//  CustomItemNamePopUpView.swift
//  Reborn
//
//  Created by Christian Liu on 8/3/21.
//

import Foundation
import UIKit
class CustomItemNamePopUpView: PopUpImpl {
    
    var textField: UITextField = UITextField()
    var promptLabel: UILabel = UILabel()
    
    init(presentAnimationType: PopUpAnimationType, popUpViewController: PopUpViewController) {
        super.init(presentAnimationType: presentAnimationType, popUpViewController: popUpViewController, type: .customItemNamePopUp)
        
        textField = super.contentView?.getSubviewBy(tag: self.setting.popUpWindowTextFieldTag) as! UITextField
        promptLabel = super.window.getSubviewBy(tag: self.setting.popUpWindowPromptLabelTag) as! UILabel
    }
    
    override func isReadyToDismiss() -> Bool {
        if textField.text != "" {
            return true
        } else {
            self.hidePromptLabel(false)
        }
        return false
    }
    

    
    func hidePromptLabel(_ isHidden: Bool) {
        promptLabel.isHidden = isHidden
    }
    
    override func createWindow() -> UIView {
        return CustomItemNamePopUpViewBuilder(popUpViewController: super.popUpViewController, frame: super.frame).buildView()
    }
    
    override func getStoredData() -> Any {
        if let text = textField.text {
            return text
        }
        
        return ""
    }
    
    override func updateUI() {
        
    }
}
