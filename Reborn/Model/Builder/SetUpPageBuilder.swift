//
//  SetUpPageBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 3/1/21.
//

import Foundation
import UIKit

class SetUpPageBuilder {

    var page: SetUpPage
    var pageCordinateX: CGFloat
    var superView: UIView
    var pageView: UIView?
    let setting: SystemStyleSetting = SystemStyleSetting.shared
    
    init(page: SetUpPage, pageCordinateX: CGFloat, layoutGuideView: UIView){
        self.superView = layoutGuideView
        self.page = page
        self.pageCordinateX = pageCordinateX
    }
    
    public func buildSetUpPage() -> UIView {
        createPageView()
        addButtons()
        return pageView!
    }
        
        
    private func createPageView() {
        
        self.pageView = UIView(frame: CGRect(x: self.pageCordinateX, y: 0, width: superView.frame.width, height: superView.frame.height))
        
    }
    
    private func addButtons() {
        
        var column = 1
        var buttonX: CGFloat
        var buttonY: CGFloat = -self.setting.optionButtonToTopDistance
        
        var button: UIButton
        
        for dataButton in page.buttons {
            let buttonTitle = dataButton.title
            
            if column == 1 { // left side buttons
                buttonX = self.pageView!.frame.width / 2.0 - self.setting.optionButtonWidth - self.setting.optionButtonHorizontalDistance / 2.0
                buttonY += self.setting.optionButtonVerticalDistance + self.setting.optionButtonHeight
                column += 1
                
            } else { // right side buttons
                buttonX = self.pageView!.frame.width / 2 + self.setting.optionButtonHorizontalDistance / 2
                column = 1
            }
         
           
            button = UIButton(frame: CGRect(x: buttonX, y: buttonY, width: self.setting.optionButtonWidth, height: self.setting.optionButtonHeight))
            // Button's properties
//            button.layer.cornerRadius = self.setting.optionButtonCornerRadius
//            button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
//            button.layer.shadowOffset =  CGSize(width: 0.0, height: 2.0)
//            button.layer.shadowOpacity = 1.0
//            button.layer.masksToBounds = false
            
            button.layer.cornerRadius = SystemStyleSetting.shared.optionButtonCornerRadius
            button.setViewShadow()
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(self.setting.optionButtonTitleColor, for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.setTitleColor(UIColor.white, for: .selected)
            
            button.setBackgroundColor(UIColor.white, cornerRadius: button.layer.cornerRadius, for: .normal)
            button.setBackgroundColor(UserStyleSetting.themeColor, cornerRadius: button.layer.cornerRadius, for: .selected)
            
            button.titleLabel?.font = self.setting.optionButtonTitleFont
            button.addTarget(self, action: SetUpViewController.optionButtonAction, for: .touchDown)

            switch page.ID {
            case 1:
                if buttonTitle == self.setting.customButtonTitle {
                button.tag = self.setting.customItemNameButtonTag
            }
            case 2:
                if buttonTitle == self.setting.customButtonTitle {
                button.tag = self.setting.customTargetDaysButtonTag
            }
            case 3:
                if buttonTitle == self.setting.customButtonTitle {
                    button.tag = self.setting.customItemNameButtonTag
                }
            case 4:
                if buttonTitle == self.setting.customButtonTitle {
                    button.tag = self.setting.customTargetDaysButtonTag
                }
            default: print("")
            }
            
            self.pageView!.addSubview(button)
        }
    }
    
    

}
