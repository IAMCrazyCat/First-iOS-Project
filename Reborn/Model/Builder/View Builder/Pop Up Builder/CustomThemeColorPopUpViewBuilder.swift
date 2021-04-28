//
//  CustomThemeColorPopUpViewBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 25/2/21.
//

import Foundation
import UIKit

class CustomThemeColorPopUpViewBuilder: PopUpViewBuilder {
    
    
    
    override func buildView() -> UIView {
        _ = super.buildView()
        self.setUpUI()
        self.addThemeColorView()
        self.addThemeColorNameLabel()
        self.addVipThemeColorPromptLabel()
        return super.outPutView
    }
    
    private func setUpUI() {
        super.titleLabel.text = "主题颜色"
    }
    
    private func addThemeColorView() {

        let paddingToLeft: CGFloat = super.setting.mainPadding
        let paddingToTop: CGFloat = 0
        let buttonSize: CGFloat = 30
        let maxNumberOfButtonsInOneRow: Int = 5

        var buttonHorizentalGap: CGFloat {
            let totalButtonWidth = CGFloat(maxNumberOfButtonsInOneRow) * buttonSize
            let totalGapWidth = super.contentView.frame.width - totalButtonWidth - 2 * paddingToLeft
            return totalGapWidth / CGFloat(maxNumberOfButtonsInOneRow - 1)
        }
        let buttonVerticalGap: CGFloat = 40
        
        var numberOfRows: Int {
            return Int(ThemeColor.allCases.count / maxNumberOfButtonsInOneRow)
        }
        
        var cordinateX: CGFloat = paddingToLeft
        var cordinateY: CGFloat = paddingToTop
        var buttonNumber: Int = 1
        var themeColors: Array<ThemeColor> {
            var colors: Array<ThemeColor> = []
            for themeColor in ThemeColor.allCases {
                colors.append(themeColor)
            }
            
            colors.sort {
                !$0.isVipColor && $1.isVipColor
            }
            return colors
        }

        let themeColorView = UIView()
        themeColorView.accessibilityIdentifier = "ThemeColorView"
        themeColorView.frame = CGRect(x: 0, y: 0, width: super.contentView.frame.width, height: buttonSize)

        for themeColor in themeColors  {
            
            let colorButton = UIButton()
            colorButton.accessibilityIdentifier = "ThemeColorButton"
            colorButton.accessibilityValue = themeColor.rawValue
            colorButton.frame = CGRect(x: cordinateX, y: cordinateY, width: buttonSize, height: buttonSize)
            colorButton.setBackgroundImage(#imageLiteral(resourceName: "ThemeColorIcon"), for: .normal)
            colorButton.imageView?.contentMode = .scaleToFill
            colorButton.tintColor = themeColor.uiColor
            colorButton.addTarget(Actions.shared, action: Actions.themeColorChangedAction, for: .touchUpInside)
            if themeColor.isVipColor {
                let vipButton = VipIcon.render(by: CGRect(x: colorButton.frame.maxX - 8, y: colorButton.frame.maxY - 8, width: buttonSize, height: buttonSize / 2), scale: 0.7)

                themeColorView.addSubview(vipButton)
            }
            themeColorView.addSubview(colorButton)
            
        
            if buttonNumber > maxNumberOfButtonsInOneRow - 1 {
                cordinateX = paddingToLeft
                cordinateY += buttonVerticalGap + colorButton.frame.height
                themeColorView.frame.size.height += buttonVerticalGap + colorButton.frame.height
                buttonNumber = 0
            } else {
                cordinateX += buttonHorizentalGap + colorButton.frame.width
            }
            
            if themeColor == AppEngine.shared.userSetting.themeColor {
                let checkButton = UIButton()
                checkButton.setImage(#imageLiteral(resourceName: "FinishedIcon"), for: .normal)
                checkButton.tintColor = UIColor.label
                themeColorView.addSubview(checkButton)
                checkButton.translatesAutoresizingMaskIntoConstraints = false
                checkButton.topAnchor.constraint(equalTo: colorButton.bottomAnchor, constant: 10).isActive = true
                checkButton.centerXAnchor.constraint(equalTo: colorButton.centerXAnchor).isActive = true
                checkButton.widthAnchor.constraint(equalTo: colorButton.widthAnchor, multiplier: 0.5).isActive = true
                checkButton.heightAnchor.constraint(equalTo: colorButton.heightAnchor, multiplier: 0.5).isActive = true
                checkButton.layoutIfNeeded()
                
            }
            
    
            buttonNumber += 1

        }
        
        super.contentView.addSubview(themeColorView)
        super.contentView.layoutIfNeeded()
        themeColorView.center.y = super.contentView.center.y / 2
        
    }
    
    func addThemeColorNameLabel() {
        let themeColorNameLabel = UILabel()
        themeColorNameLabel.font = AppEngine.shared.userSetting.mediumFont
        themeColorNameLabel.text = AppEngine.shared.userSetting.themeColor.name
        themeColorNameLabel.textColor = super.setting.grayColor
        themeColorNameLabel.sizeToFit()
        
        super.outPutView.addSubview(themeColorNameLabel)
        themeColorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        themeColorNameLabel.leftAnchor.constraint(equalTo: super.contentView.leftAnchor, constant: 0).isActive = true
        themeColorNameLabel.topAnchor.constraint(equalTo: super.titleLabel.bottomAnchor, constant: super.setting.mainGap).isActive = true
       
    }
    
    func addVipThemeColorPromptLabel() {
        let vipThemeColorPromptLabel = UILabel()
        vipThemeColorPromptLabel.accessibilityIdentifier = "VipThemeColorPromptLabel"
        vipThemeColorPromptLabel.text = "您选择了vip主题颜色，您还不是vip，您可以试用颜色，但配色不会被保存"
        vipThemeColorPromptLabel.font = AppEngine.shared.userSetting.smallFont
        vipThemeColorPromptLabel.textColor = .red
        vipThemeColorPromptLabel.alpha = 0.7
        vipThemeColorPromptLabel.lineBreakMode = .byWordWrapping
        vipThemeColorPromptLabel.numberOfLines = 2
        vipThemeColorPromptLabel.sizeToFit()
        vipThemeColorPromptLabel.isHidden = !AppEngine.shared.currentUser.isVip && AppEngine.shared.userSetting.themeColor.isVipColor ? false : true


        super.contentView.addSubview(vipThemeColorPromptLabel)
        vipThemeColorPromptLabel.translatesAutoresizingMaskIntoConstraints = false
        vipThemeColorPromptLabel.leftAnchor.constraint(equalTo: super.contentView.leftAnchor, constant: 5).isActive = true
        vipThemeColorPromptLabel.rightAnchor.constraint(equalTo: super.contentView.rightAnchor, constant: -5).isActive = true
        vipThemeColorPromptLabel.centerXAnchor.constraint(equalTo: super.contentView.centerXAnchor).isActive = true
        vipThemeColorPromptLabel.bottomAnchor.constraint(equalTo: super.contentView.bottomAnchor).isActive = true
    }
}
