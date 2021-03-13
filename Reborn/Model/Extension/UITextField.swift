//
//  UITextField.swift
//  Reborn
//
//  Created by Christian Liu on 13/3/21.
//

import Foundation
import UIKit
extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat){
       let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
       self.leftView = paddingView
       self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount: CGFloat) {
    
       let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
       self.rightView = paddingView
       self.rightViewMode = .always
    }
    
    func setPadding() {
        setLeftPaddingPoints(10)
        setRightPaddingPoints(10)
    }
    
    func disableKeyBoard() {
        self.inputView = UIView(frame: .zero)
    }
}
