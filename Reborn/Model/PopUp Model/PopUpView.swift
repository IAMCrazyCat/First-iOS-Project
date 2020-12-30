//
//  PopUpView.swift
//  Reborn
//
//  Created by Christian Liu on 29/12/20.
//

import Foundation
import UIKit

struct PopUpView {
    let popUpBGView: UIView
    var popUpWindow: UIView? = nil
    let setting: SystemStyleSetting



    
    init(popUpView: UIView) {
        self.popUpBGView = popUpView
        self.setting = SystemStyleSetting.shared
        
        for subview in popUpView.subviews {
            if subview.tag == setting.popUpWindowTag {
                self.popUpWindow = subview
            }
        }
        
        
    }
    
    func setDismissButtonActions(action: Selector) {
        
       
        if let cancelButton = self.getWindowSubviewByTag(tag: self.setting.popUpWindowCancelButtonTag) as? UIButton {
            cancelButton.addTarget(self, action: action, for: .touchDown)
        }
        
        
        if let BGViewButton = self.getBGViewSubviewByTag(tag: self.setting.popUpBGViewButtonTag) as? UIButton {
            print("FIND")
            BGViewButton.addTarget(self, action: action, for: .touchDown)
        }
        
        
        if let doneButton = self.getWindowSubviewByTag(tag: self.setting.popUpWindowDoneButtonTag) as? UIButton {
            doneButton.addTarget(self, action: action, for: .touchDown)
        }
        
      
        
       
    }
    
    func setTextFieldAction(action: Selector){
        
        if let textfield = self.getWindowSubviewByTag(tag: self.setting.popUpWindowTextFieldTag) as? UITextField {
            textfield.addTarget(self, action: action, for: .touchDown)
        }
        
  

    }
    
    func getTextfieldText() -> String {
        var textFieldText = "错误"
        
        if let textfield = self.getWindowSubviewByTag(tag: self.setting.popUpWindowTextFieldTag) as? UITextField{
            textFieldText =  textfield.text ?? ""
        }
       
        return textFieldText
    }
    
    func hidePrompLabel(_ isHidden: Bool) {
        
        if let promptLabel = self.getWindowSubviewByTag(tag: self.setting.popUpWindowPromptLabelTag) as? UILabel {
            promptLabel.isHidden = isHidden == true ?  true : false
        }
        
      
    }
    
    

    
    func moveUp(distance: CGFloat) {
        
           
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
    
            self.popUpWindow!.frame.origin.y -= distance
        })
        
        
    }
    
    func appear() {

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.popUpBGView.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
            self.popUpWindow!.frame.origin.y -= self.popUpWindow!.frame.height
        }, completion: {_ in
               
               UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                self.popUpWindow!.frame.origin.y += 15
               })

        })
    }

    
    func disappear(comletion: @escaping ((Bool) -> Void)) {
        
 
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.popUpBGView.backgroundColor = UIColor.gray.withAlphaComponent(0)
            self.popUpWindow!.frame.origin.y += self.popUpWindow!.frame.height
        }, completion: {_ in
               
               UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                self.popUpWindow!.frame.origin.y -= 15
               }, completion: comletion)

        })

    }
    
    func getWindowSubviewByTag(tag: Int) -> UIView?
    {
        for subview in self.popUpWindow!.subviews {
            print(subview.tag)
            if subview.tag == tag {
                return subview
            }
        }
        return nil
    }
    
    func getBGViewSubviewByTag(tag: Int) -> UIView? {
        for subview in self.popUpBGView.subviews {
   
            if subview.tag == tag {
                return subview
            }
        }
        return nil
    }
    
    
}
