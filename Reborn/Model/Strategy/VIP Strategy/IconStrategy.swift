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
        
        let vipButton = VipIcon.render(by: CGRect(x: iconCell.iconButton.frame.width / 2, y: iconCell.iconButton.frame.height / 2, width: 40, height: 20), scale: 0.7)
        
        if icon.isVipIcon && !AppEngine.shared.currentUser.isVip {
            iconCell.iconButton.alpha = 0.5
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
