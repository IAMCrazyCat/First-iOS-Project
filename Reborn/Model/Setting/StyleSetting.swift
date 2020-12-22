//
//  Settings.swift
//  Reborn
//
//  Created by Christian Liu on 19/12/20.
//

import Foundation
import UIKit

struct StyleSetting{
    
    let FontNormalSize: CGFloat = 21
    let mainButtonCornerRadius: CGFloat = 25
    
    // for set up page buttons
    let optionButtonWidth: CGFloat = 150
    let optionButtonHeight: CGFloat = 50
    let optionButtonVerticalDistance: CGFloat = 20
    let optionButtonHorizontalDistance: CGFloat = 20
    let optionButtonTitleColor: UIColor = UIColor.black
    let optionButtonTitleFont: UIFont = UIFont(name: ".SFUIText-Medium", size: 15)!
    let optionButtonBgImage: UIImage = #imageLiteral(resourceName: "OptionButton")
    let optionButtonPressedBgImage: UIImage = #imageLiteral(resourceName: "OptionButtonPressed")
    let optionButtonDisabledBgImage: UIImage = #imageLiteral(resourceName: "OptionButtonDisabled")
    let questionLabelFont: UIFont = UIFont(name: ".SFUIText-Medium", size: 17)!
    let progressBarAnimationSpeed = 0.2
    
    
    let nextStepButtonTitle: String = "下一步"
    let finishButtonTitle: String = "完成"

}

