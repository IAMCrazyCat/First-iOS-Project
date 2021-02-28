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
        let outPutView = super.buildView()

        super.titleLabel.text = "主题颜色"
        self.addThemeColorOptions()
        return outPutView
    }
    
    private func addThemeColorOptions() {
        
        let buttonSize: CGFloat = 40
        let buttonHorizentalGap: CGFloat = 20
        let buttonVerticalGap: CGFloat = 40
        var maxNumberOfButtonsInOneRow: Int {
            let realWidth = super.contentView.frame.width - 2 * super.setting.mainPadding
            return Int(realWidth / (buttonSize + buttonHorizentalGap))
        }
        var numberOfRows: Int {
            return Int(ThemeColor.allCases.count / maxNumberOfButtonsInOneRow)
        }
        
        var cordinateX: CGFloat = super.setting.mainPadding
        var cordinateY: CGFloat = 30
        var buttonNumber: Int = 1
        for themeColorName in ThemeColor.allCases {
            
            let themeColor = UIColor(named: themeColorName.rawValue) ?? UIColor.clear
            let colorButton = UIButton()
            colorButton.accessibilityValue = themeColorName.rawValue
            colorButton.frame = CGRect(x: cordinateX, y: cordinateY, width: buttonSize, height: buttonSize)
            colorButton.setImage(#imageLiteral(resourceName: "ThemeColorIcon"), for: .normal)
            colorButton.imageView?.contentMode = .scaleToFill
            colorButton.tintColor = themeColor
            colorButton.addTarget(Actions.shared, action: Actions.shared.themeColorChangedAction, for: .touchUpInside)
            super.contentView.addSubview(colorButton)
            
        
            if buttonNumber > maxNumberOfButtonsInOneRow {
                cordinateX = super.setting.mainPadding
                cordinateY += buttonVerticalGap
            } else {
                cordinateX += buttonHorizentalGap + colorButton.frame.width
            }
            
            if themeColor == AppEngine.shared.userSetting.themeColor {
                let checkButton = UIButton()
                checkButton.setImage(#imageLiteral(resourceName: "FinishedIcon"), for: .normal)
                checkButton.tintColor = UIColor.label
                super.contentView.addSubview(checkButton)
                checkButton.translatesAutoresizingMaskIntoConstraints = false
                checkButton.topAnchor.constraint(equalTo: colorButton.bottomAnchor, constant: 10).isActive = true
                checkButton.centerXAnchor.constraint(equalTo: colorButton.centerXAnchor).isActive = true
                checkButton.widthAnchor.constraint(equalTo: colorButton.widthAnchor, multiplier: 0.5).isActive = true
                checkButton.heightAnchor.constraint(equalTo: colorButton.heightAnchor, multiplier: 0.5).isActive = true
                checkButton.layoutIfNeeded()
                
            }
            
    
            buttonNumber += 1
            
            
        }
        
    }
}
