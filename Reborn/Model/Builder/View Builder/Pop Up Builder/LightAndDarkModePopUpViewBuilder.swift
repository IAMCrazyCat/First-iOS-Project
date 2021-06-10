//
//  LightAndDarkModePopUpViewBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 20/3/21.
//

import Foundation
import UIKit


class LightAndDarkModePopUpViewBuilder: PopUpViewBuilder {
    let currentMode: AppAppearanceMode
    
    init(popUpViewController: PopUpViewController, frame: CGRect, currentMode: AppAppearanceMode) {
        self.currentMode = currentMode
        super.init(popUpViewController: popUpViewController, frame: frame)
    }
    
    override func buildView() -> UIView {
        super.buildView()
        self.setUpUI()
        self.addOptionButtons()
        return super.outPutView
    }
    
    
    private func setUpUI() {
        super.titleLabel.text = "配色方案"
    }
    
    private func addOptionButtons() {
        
        let buttonWidth = (super.contentView.frame.width - 2 * super.setting.mainGap) / 3
        let buttonHeight = buttonWidth * (1550 / 828)//super.contentView.frame.height - 2 * super.setting.mainDistance
        let cornerRadius: CGFloat = 10
        let contentMode: UIView.ContentMode = .scaleAspectFill
        let buttonAndLabelHeight: CGFloat = buttonHeight + super.setting.mainGap + 20
        let followSystemButton = UIButton()
        
        followSystemButton.accessibilityIdentifier = "FollowSystemButton"
        followSystemButton.frame = CGRect(x: 0, y: super.contentView.frame.height / 2 - buttonAndLabelHeight / 2, width: buttonWidth, height: buttonHeight)
        followSystemButton.setImage(#imageLiteral(resourceName: "FollowSystem"), for: .normal)
        followSystemButton.imageView?.contentMode = contentMode
        followSystemButton.imageView?.layer.cornerRadius = cornerRadius
        followSystemButton.addTarget(Actions.shared, action: Actions.appApperenceModeChangedAction, for: .touchUpInside)

        super.contentView.addSubview(followSystemButton)
        
        let followSystemLabel = UILabel()
        followSystemLabel.text = "跟随系统"
        followSystemLabel.sizeToFit()
        super.contentView.addSubview(followSystemLabel)
        
        followSystemLabel.translatesAutoresizingMaskIntoConstraints = false
        followSystemLabel.centerXAnchor.constraint(equalTo: followSystemButton.centerXAnchor).isActive = true
        followSystemLabel.topAnchor.constraint(equalTo: followSystemButton.bottomAnchor, constant: super.setting.mainGap).isActive = true
        
        
        
        let lightModeButton = UIButton()
        lightModeButton.accessibilityIdentifier = "LightModeButton"
        lightModeButton.frame = CGRect(x: followSystemButton.frame.maxX + super.setting.mainGap, y: super.contentView.frame.height / 2 - buttonAndLabelHeight / 2, width: buttonWidth, height: buttonHeight)
        lightModeButton.setImage(#imageLiteral(resourceName: "LightMode"), for: .normal)
        lightModeButton.imageView?.contentMode = contentMode
        lightModeButton.imageView?.layer.cornerRadius = cornerRadius
        lightModeButton.addTarget(Actions.shared, action: Actions.appApperenceModeChangedAction, for: .touchUpInside)
        super.contentView.addSubview(lightModeButton)
        
        let lightModeLabel = UILabel()
        lightModeLabel.text = "白天模式"
        lightModeLabel.sizeToFit()
        super.contentView.addSubview(lightModeLabel)
        
        lightModeLabel.translatesAutoresizingMaskIntoConstraints = false
        lightModeLabel.centerXAnchor.constraint(equalTo: lightModeButton.centerXAnchor).isActive = true
        lightModeLabel.topAnchor.constraint(equalTo: lightModeButton.bottomAnchor, constant: super.setting.mainGap).isActive = true
        
        
        
        
        let darkModeButton = UIButton()
        darkModeButton.accessibilityIdentifier = "DarkModeButton"
        darkModeButton.frame = CGRect(x: lightModeButton.frame.maxX + super.setting.mainGap, y: super.contentView.frame.height / 2 - buttonAndLabelHeight / 2, width: buttonWidth, height: buttonHeight)
        darkModeButton.setImage(#imageLiteral(resourceName: "DarkMode"), for: .normal)
        darkModeButton.imageView?.contentMode = contentMode
        darkModeButton.imageView?.layer.cornerRadius = cornerRadius
        darkModeButton.addTarget(Actions.shared, action: Actions.appApperenceModeChangedAction, for: .touchUpInside)
        super.contentView.addSubview(darkModeButton)

        let darkModeLabel = UILabel()
        darkModeLabel.text = "黑夜模式"
        darkModeLabel.sizeToFit()
        super.contentView.addSubview(darkModeLabel)
        
        darkModeLabel.translatesAutoresizingMaskIntoConstraints = false
        darkModeLabel.centerXAnchor.constraint(equalTo: darkModeButton.centerXAnchor).isActive = true
        darkModeLabel.topAnchor.constraint(equalTo: darkModeButton.bottomAnchor, constant: super.setting.mainGap).isActive = true
        
        
        
        let borderWidth: CGFloat = 3
        let borderColor: CGColor = AppEngine.shared.userSetting.themeColor.uiColor.cgColor

        switch self.currentMode {
        
            case .followSystem:
                
                followSystemButton.layer.cornerRadius = followSystemButton.imageView?.layer.cornerRadius ?? 0
                followSystemButton.layer.borderWidth = borderWidth
                followSystemButton.layer.borderColor = borderColor
                
            case .lightMode:
                
                lightModeButton.layer.cornerRadius = lightModeButton.imageView?.layer.cornerRadius ?? 0
                lightModeButton.layer.borderWidth = borderWidth
                lightModeButton.layer.borderColor = borderColor
                
            case .darkMode:
 
                darkModeButton.layer.cornerRadius = darkModeButton.imageView?.layer.cornerRadius ?? 0
                darkModeButton.layer.borderWidth = borderWidth
                darkModeButton.layer.borderColor = borderColor
            
        }
    }
    
}
