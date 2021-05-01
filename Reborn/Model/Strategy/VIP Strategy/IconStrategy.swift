//
//  IconStrategy.swift
//  Reborn
//
//  Created by Christian Liu on 28/4/21.
//

import Foundation
import UIKit
class IconStrategy: VIPStrategyImpl {
    
    var iconCell: IconCell
    init(iconCell: IconCell) {
        self.iconCell = iconCell
    }
    
    func setAppearance(with icon: Icon) {

        iconCell.iconButton.setImage(icon.image, for: .normal)
        iconCell.iconButton.accessibilityIdentifier = icon.name
        
        let width: CGFloat = 40
        let height: CGFloat = 20
        let scale: CGFloat = 0.5
        let vipButton = VipIcon.render(by: CGRect(x: iconCell.iconButton.frame.width - width * scale, y: iconCell.iconButton.frame.height - height * scale, width: width, height: height), scale: scale)
        
        if icon.isVipIcon && !AppEngine.shared.currentUser.isVip {
            iconCell.iconButton.alpha = 0.3
            iconCell.iconButton.isUserInteractionEnabled = false
            iconCell.contentView.addSubview(vipButton)
        } else if icon.isVipIcon && AppEngine.shared.currentUser.isVip {
            iconCell.iconButton.isUserInteractionEnabled = true
            iconCell.iconButton.alpha = 1
            iconCell.contentView.addSubview(vipButton)
        } else {
            iconCell.iconButton.alpha = 1
        }
    }
}
