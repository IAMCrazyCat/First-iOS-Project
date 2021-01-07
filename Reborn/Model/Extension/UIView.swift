//
//  UIView.swift
//  Reborn
//
//  Created by Christian Liu on 5/1/21.
//

import Foundation
import UIKit
extension UIView {
    func setViewShadow() {

        self.layer.shadowColor = SystemStyleSetting.shared.UIViewShadowColor
        self.layer.shadowOffset =  SystemStyleSetting.shared.UIViewShadowOffset
        self.layer.shadowOpacity = SystemStyleSetting.shared.UIViewShadowOpacity
        self.layer.masksToBounds = false
    }
}
