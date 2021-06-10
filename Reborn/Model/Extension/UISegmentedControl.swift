//
//  UISegmentedControl.swift
//  Reborn
//
//  Created by Christian Liu on 17/2/21.
//

import Foundation
import UIKit
extension UISegmentedControl {
    func setSegmentStyle(normalColor: UIColor, selectedColor: UIColor, dividerColor: UIColor) {
            
        let normalColorImage = UIImage.renderImageWithColor(normalColor, size: CGSize(width: 1.0, height: 1.0))
        let selectedColorImage = UIImage.renderImageWithColor(selectedColor, size: CGSize(width: 1.0, height: 1.0))
        let dividerColorImage = UIImage.renderImageWithColor(dividerColor, size: CGSize(width: 1.0, height: 1.0))
        
        setBackgroundImage(normalColorImage, for: .normal, barMetrics: .default)
        setBackgroundImage(selectedColorImage, for: .selected, barMetrics: .default)
        setDividerImage(dividerColorImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        // 文字在两种状态下的颜色
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], for: .normal)
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], for: .selected)
        
        // 边界颜色、圆角
        self.layer.borderWidth = 0.7
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = dividerColor.cgColor
        self.layer.masksToBounds = true
    }
    
    func setSmartAppearance(withBackgroundStyle backgroundStyle: AppAppearanceMode) {
        let normalText: [NSAttributedString.Key : UIColor]
        
        if backgroundStyle == .darkMode {
            normalText = [NSAttributedString.Key.foregroundColor: UIColor.white]
        } else if backgroundStyle == .lightMode {
            normalText = [NSAttributedString.Key.foregroundColor: UIColor.black]
        } else {
            normalText = [NSAttributedString.Key.foregroundColor: UIColor.label]
        }
        
        let selectedText = [NSAttributedString.Key.foregroundColor: AppEngine.shared.userSetting.smartLabelColor]
        self.selectedSegmentTintColor = AppEngine.shared.userSetting.themeColor.uiColor
        self.setTitleTextAttributes(normalText, for: .normal)
        self.setTitleTextAttributes(selectedText, for: .selected)
    }
    

}
