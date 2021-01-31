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
    let screenFrame: CGRect = UIScreen.main.bounds
    let mainButtonHeight: CGFloat = 50
    let mainButtonCornerRadius: CGFloat = 25
    let checkButtonCornerRadius: CGFloat = 15
    let optionButtonCornerRadius: CGFloat = 25
    let itemCardCornerRadius: CGFloat = 25
    let UIViewShadowColor: CGColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
    let UIViewShadowOffset: CGSize = CGSize(width: 0.0, height: 1.5)
    let UIViewShadowOpacity: Float = 1.0
    
    let greyColor: UIColor = UIColor(named: "GreyColor")!
    let whiteAndBlack: UIColor = UIColor(named: "WhiteAndBlack")!
    
    var customTargetDaysButtonTag = 10
    var customItemNameButtonTag = 20
    var customFrequencyButtonTag = 30
    

    
    // for welcome page
    let mainDistance: CGFloat = 20
    let mainPadding: CGFloat = 15
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
    
    let homeViewVerticalScrollViewTag: Int = -1
    let homeViewHorizentalScrollViewTag: Int = -2
    let itemCardIdentifier = "ItemCard"
    let itemCardBGImage: UIImage = #imageLiteral(resourceName: "ItemCard")
    let progressBarLengthToRightEdgeOffset: CGFloat = 90
    let itemCardHeight: CGFloat = 120
    let itemCardCenterObjectsToEdgeOffset: CGFloat = 70
    let itemCardGap: CGFloat = 15
    
    
    
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
    let popUpWindowPickerViewTag: Int = 6
    
    let popUpWindowPresentDuration: Double = 0.2
    let popUpWindowBounceDuration: Double = 0.25
    
    let calendarHeight: CGFloat = 300
    
    // for details view
    let calendarFunctionButtonCornerRadius: CGFloat = 15
    let itemDetailsViewHeight: CGFloat = 100
    
    // for calendar view
    let carlendarDaySelectionButtonSize: CGFloat = 40
    let calendarDaySelectionButtonCornerRadius: CGFloat = 15
    
    // for time machine
    let calendarPageColor: UIColor = .white
    let newCalendarPageCordiateYDifference: CGFloat = 40
    let newCalendarPageSizeDifference: CGFloat = 0.95
    let calendarPageColorDifference: CGFloat = 0.02
    let numberOfCalendarPages: Int = 4 // at least 2
    let timeMachineAnimationFastSpeed: TimeInterval = 0.1
    let timeMachineAnimationNormalSpeed: TimeInterval = 0.35
    
    
}

