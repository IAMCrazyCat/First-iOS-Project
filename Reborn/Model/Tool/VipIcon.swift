//
//  VipIcon.swift
//  Reborn
//
//  Created by Christian Liu on 28/4/21.
//

import Foundation
import UIKit
struct VipIcon {
    public static func render(by frame: CGRect, scale: CGFloat) -> UIButton {
        let vipButton = UIButton()
        vipButton.accessibilityIdentifier = "VipButton"
        vipButton.frame = frame
        vipButton.titleLabel?.font = AppEngine.shared.userSetting.smallFont.withSize(1)
        vipButton.renderVipIcon()
        vipButton.transform = CGAffineTransform(scaleX: scale, y: scale)
        return vipButton
    }
}
