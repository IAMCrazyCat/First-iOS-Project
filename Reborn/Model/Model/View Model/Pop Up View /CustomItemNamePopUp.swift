//
//  CustomItemNamePopUpView.swift
//  Reborn
//
//  Created by Christian Liu on 8/3/21.
//

import Foundation
import UIKit
class CustomItemNamePopUpView: PopUpImpl {
    
    var textField: UITextField? {
        return super.contentView?.getSubviewBy(idenifier: "TextField") as? UITextField
    }
    var promptLabel: UILabel? {
        return super.contentView?.getSubviewBy(idenifier: "PromptLabel") as? UILabel
    }
    
    init(presentAnimationType: PopUpAnimationType, popUpViewController: PopUpViewController) {
        super.init(presentAnimationType: presentAnimationType, popUpViewController: popUpViewController, type: .customItemNamePopUp)
        

    }
    
    override func isReadyToDismiss() -> Bool {
        if textField?.text != "" {
            return true
        } else {
            self.hidePromptLabel(false)
        }
        return false
    }
    

    
    func hidePromptLabel(_ isHidden: Bool) {
        promptLabel?.isHidden = isHidden
    }
    
    override func createWindow() -> UIView {
        return CustomItemNamePopUpViewBuilder(popUpViewController: super.popUpViewController, frame: super.frame).buildView()
    }
    
    override func getStoredData() -> Any {
        if let text = textField?.text {
            return text
        }
        
        return ""
    }
    
    override func updateUI() {
        
    }
}
