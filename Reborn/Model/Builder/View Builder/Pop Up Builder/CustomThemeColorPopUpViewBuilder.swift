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
        self.addThemeColorOptions()
        return super.outPutView
    }
    
    private func setUpUI() {
        super.titleLabel.text = "主题颜色"
    }
    
    private func addThemeColorOptions() {
        
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
        for themeColorName in ThemeColor.allCases {
            
            let themeColor = UIColor(named: themeColorName.rawValue) ?? UIColor.blue
            let colorButton = UIButton()
            colorButton.accessibilityValue = themeColorName.rawValue
            colorButton.frame = CGRect(x: cordinateX, y: cordinateY, width: buttonSize, height: buttonSize)
            colorButton.setBackgroundImage(#imageLiteral(resourceName: "ThemeColorIcon"), for: .normal)
            colorButton.imageView?.contentMode = .scaleToFill
            colorButton.tintColor = themeColor
            colorButton.addTarget(Actions.shared, action: Actions.themeColorChangedAction, for: .touchUpInside)
            super.contentView.addSubview(colorButton)
            
        
            if buttonNumber > maxNumberOfButtonsInOneRow - 1 {
                cordinateX = paddingToLeft
                cordinateY += buttonVerticalGap + colorButton.frame.height
                buttonNumber = 0
            } else {
                cordinateX += buttonHorizentalGap + colorButton.frame.width
            }
            
            if themeColor.value == AppEngine.shared.userSetting.themeColor.value {
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
