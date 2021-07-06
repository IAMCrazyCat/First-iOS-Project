//
//  Selector.swift
//  Reborn
//
//  Created by Christian Liu on 27/12/20.
//

import Foundation
import UIKit

extension UIButton {
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {

        self.layoutIfNeeded()

        let cornerRadius = self.layer.cornerRadius
        let length = 1 + cornerRadius * 2
        let size = CGSize(width: length, height: length)
        let rect = CGRect(origin: .zero, size: size)

        var backgroundImage = UIGraphicsImageRenderer(size: size).image { (context) in
            // Fill the square with the black color for later tinting.
            color.setFill()
            UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).fill()
        }

        // Apply the `color` to the `backgroundImage` as a tint color
        // so that the `backgroundImage` can update its color automatically when the currently active traits are changed.

        backgroundImage = backgroundImage.resizableImage(withCapInsets: UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius))
        if #available(iOS 13.0, *) {
            backgroundImage = backgroundImage.withTintColor(color, renderingMode: .alwaysOriginal)
        }

        self.setBackgroundImage(backgroundImage, for: state)
    }
   
    
    func getData() -> Int? {
        
        
        if var title = self.currentTitle {
            title.removeLast()
            return Int(title)
        } else {
            return nil
        }

    }
    
    
    func proportionallySetSizeWithScreen() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: SystemSetting.shared.screenFrame.height *  SystemSetting.shared.optionButtonHeightRatio).isActive = true
        self.widthAnchor.constraint(equalToConstant:  SystemSetting.shared.screenFrame.width *  SystemSetting.shared.optionButtonWidthRatio).isActive = true
        self.layoutIfNeeded()
    }
    
    func proportionallySetHeightWithScreen() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: SystemSetting.shared.screenFrame.height *  SystemSetting.shared.optionButtonHeightRatio).isActive = true
        self.layoutIfNeeded()
    }
    
    func setOptionButtonAppearance() {
        self.titleLabel?.font = AppEngine.shared.userSetting.smallFont
        self.proportionallySetSizeWithScreen()
        self.setCornerRadius()
        self.setShadow(style: .button)
        self.setBackgroundColor(AppEngine.shared.userSetting.whiteAndBlackContent, for: .normal)
        self.setBackgroundColor(AppEngine.shared.userSetting.themeColor.uiColor, for: .selected)
        self.setTitleColor(.label, for: .normal)
        self.setTitleColor(AppEngine.shared.userSetting.smartLabelColor, for: .selected)
    }
    
    func renderVipIcon() {
        self.accessibilityIdentifier = "VipButton"
        self.setTitle("VIP", for: .normal)
        self.titleLabel?.font = AppEngine.shared.userSetting.smallFont.withSize(13)
        self.setBackgroundColor(.systemRed, for: .normal)
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
    }
    
    func setSmartColor() {
        self.setBackgroundColor(AppEngine.shared.userSetting.themeColor.uiColor, for: .normal)
        self.setBackgroundColor(AppEngine.shared.userSetting.themeColor.uiColor.withAlphaComponent(0.7), for: .highlighted)
        self.setTitleColor(AppEngine.shared.userSetting.smartLabelColor, for: .normal)
        
    }
    
    func setSmartSelectionColor() {
        self.setBackgroundColor(AppEngine.shared.userSetting.themeColor.uiColor, for: .selected)
        self.setBackgroundColor(AppEngine.shared.userSetting.themeColor.uiColor.withAlphaComponent(0.7), for: .highlighted)
        self.setBackgroundColor(SystemSetting.shared.grayColor.withAlphaComponent(0.4), for: .normal)
        self.setTitleColor(AppEngine.shared.userSetting.smartLabelColor, for: .selected)
        self.setTitleColor(.label, for: .normal)
    }
}
