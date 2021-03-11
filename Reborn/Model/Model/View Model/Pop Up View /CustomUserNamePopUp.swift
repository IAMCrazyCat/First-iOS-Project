//
//  CustomUserNamePopUp.swift
//  Reborn
//
//  Created by Christian Liu on 11/3/21.
//

import Foundation
import UIKit
class CustomUserNamePopUp: PopUpImpl {
    
    var textField: UITextField? {
        return super.contentView?.getSubviewBy(idenifier: "TextField") as? UITextField
    }
    
    var promptLabel: UILabel? {
        return super.contentView?.getSubviewBy(idenifier: "PromptLabel") as? UILabel
    }
    init(presentAnimationType: PopUpAnimationType, popUpViewController: PopUpViewController) {
        super.init(presentAnimationType: presentAnimationType, popUpViewController: popUpViewController, type: .customUserNamePopUp)
    }
   
    
    override func createWindow() -> UIView {
        
        return CustomUserNamePopUpViewBuilder(popUpViewController: super.popUpViewController, frame: super.frame).buildView()
    }
    
    override func getStoredData() -> Any {
        return self.textField?.text ?? "没有名字"
    }
    
    override func updateUI() {
        
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
}
