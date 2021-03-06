//
//  Settings.swift
//  Reborn
//
//  Created by Christian Liu on 19/12/20.
//

import Foundation
import UIKit

struct SystemSetting {
    
    static let shared = SystemSetting()
    let defaultUserID: String = DeviceManager.getRandomUUID()
    let defaultUserName: String = "努力的人"
    let defaultUserGender: Gender = .undefined
    let defaultUserAvatar: UIImage = #imageLiteral(resourceName: "DefaultAvatar")
    let defaultUserAvatarData: Data = #imageLiteral(resourceName: "DefaultAvatar").pngData() ?? Data()
    let defaultUserEnergy: Int = 1
    let defaultUserItems: Array<Item> = []
    let defaultUserPurchasedType: PurchaseType = .none
    let defaultNonVipEnergyChargingEfficiencyDays: Int = 21
    let defaultVipEnergyChargingEfficiencyDays: Int = 7
    let defaultCreationDate: CustomDate = CustomDate.current

    let nonVipUserMaxItems: Int = 3
    // for all use
    let screenFrame: CGRect = UIScreen.main.bounds
    let mainButtonHeight: CGFloat = 50
    let mainButtonCornerRadius: CGFloat = 25
    let checkButtonCornerRadius: CGFloat = 15
    let itemCardCornerRadius: CGFloat = 15
    let customNavigationBarCornerRadius: CGFloat = 25
    
    let UIViewShadowRadius: CGFloat = 10
    let UIViewShadowColor: CGColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
    let UIViewShadowOffset: CGSize = CGSize(width: 0.0, height: 0)
    let UIViewShadowOpacity: Float = 0.85
    
    let UIButtonShadowRadius: CGFloat = 3
    let UIButtonShadowColor: CGColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
    let UIButtonShadowOffset: CGSize = CGSize(width: 0.0, height: 1.5)
    let UIButtonShadowOpacity: Float = 0.75
    
    let grayColor: UIColor = UIColor(named: "GreyColor")!
    let smartLabelGrayColor: UIColor = UIColor(named: "SmartLabelGrayColor")!
    
    var customTargetDaysButtonTag = 10
    var customItemNameButtonTag = 20
    var customFrequencyButtonTag = 30

    // for welcome page
    let mainDistance: CGFloat = 20
    let mainPadding: CGFloat = 15
    let mainGap: CGFloat = 20
    let FontNormalSize: CGFloat = 21
    
    // for set up page buttons
    let optionButtonToTopDistance: CGFloat = 50
    let optionButtonWidthRatio: CGFloat = 0.35
    let optionButtonHeightRatio: CGFloat = 0.05
    let optionButtonVerticalDistance: CGFloat = 30
    let optionButtonHorizontalDistance: CGFloat = 25
    let optionButtonTitleColor: UIColor = UIColor.black
    let optionButtonTitleFont: UIFont = UIFont.systemFont(ofSize: 15)
    let optionButtonCornerRadius: CGFloat = 25
    
    
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
    //let itemCardBGImage: UIImage = #imageLiteral(resourceName: "ItemCard")
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
    let popUpWindowPresentShortDuration: Double = 0.2
    let popUpWindowPresentMediumDuration: Double = 0.4
    let popUpWindowPresentLongDuration: Double = 0.6
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
    let timeMachineAnimationFastSpeed: TimeInterval = 0.2
    let timeMachineAnimationNormalSpeed: TimeInterval = 0.35
    let timeMachineAnimationSlowSpeed: TimeInterval = 0.8
    
    let contentToScrollViewBottomDistance: CGFloat = 20
    
    let selfDisciplineToolsButtonCornerRadius: CGFloat = 10
    
}

