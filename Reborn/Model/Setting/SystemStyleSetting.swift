//
//  Settings.swift
//  Reborn
//
//  Created by Christian Liu on 19/12/20.
//

import Foundation
import UIKit

struct SystemStyleSetting{
    
    static let shared = SystemStyleSetting()
    
    // for whole app use
    let viewFrame: CGRect = UIScreen.main.bounds
    let mainButtonHeight: CGFloat = 50
    let mainButtonCornerRadius: CGFloat = 25
    let checkButtonCornerRadius: CGFloat = 15
    let optionButtonCornerRadius: CGFloat = 25

    let greyColor: UIColor = UIColor(named: "GreyColor")!
    
    let customItemNameButtonTag = 1
    let customTargetButtonTag = 2
    let customFrequencyButtonTag = 3
    
    // for welcome page
    let mainDistance: CGFloat = 20
    let FontNormalSize: CGFloat = 21

    
    // for set up page buttons
    let optionButtonToTopDistance: CGFloat = 50
    let optionButtonWidth: CGFloat = 140
    let optionButtonHeight: CGFloat = 45
    let optionButtonVerticalDistance: CGFloat = 30
    let optionButtonHorizontalDistance: CGFloat = 25
    let optionButtonTitleColor: UIColor = UIColor.black
    let optionButtonTitleFont: UIFont = UIFont.systemFont(ofSize: 15)
    let optionButtonBGImage: UIImage = #imageLiteral(resourceName: "OptionButton")
    let optionButtonPressedBgImage: UIImage = #imageLiteral(resourceName: "OptionButtonPressed")
    let optionButtonDisabledBgImage: UIImage = #imageLiteral(resourceName: "OptionButtonDisabled")
    let questionLabelFont: UIFont = UIFont.systemFont(ofSize: 17)
    let progressBarAnimationSpeed = 0.2
    
    let customButtonTitle: String = "自定义"
    let skipButtonTitle: String = "没有(跳过)"
    let nextStepButtonTitle: String = "下一步"
    let finishButtonTitle: String = "完成"
    
    // for homepage
    let itemCardBGImage: UIImage = #imageLiteral(resourceName: "ItemCard")
    let progressBarLengthToRightEdgeOffset: CGFloat = 90
    let itemCardHeight: CGFloat = 130
    let itemCardCenterObjectsOffset: CGFloat = 70
    let itemCardGap: CGFloat = 10
    
    // for builder

    
    // for pop up view
    let textFieldCornerRadius: CGFloat = 5
    let textFieldHeight: CGFloat = 40
    
    let popUpWindowCornerRadius: CGFloat = 30
    let popUpWindowHeight: CGFloat = 400
    
    let popUpWindowTag: Int = 0
    let popUpBGViewButtonTag: Int = 1
    let popUpWindowCancelButtonTag: Int = 2
    let popUpWindowDoneButtonTag: Int = 3
    let popUpWindowTextFieldTag: Int = 4
    let popUpWindowPromptLabelTag: Int = 5
    let popUpWindowPickerView: Int = 6
}

