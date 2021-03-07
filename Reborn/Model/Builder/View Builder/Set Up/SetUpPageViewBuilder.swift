//
//  SetUpPageBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 3/1/21.
//

import Foundation
import UIKit

class SetUpPageViewBuilder {

    var page: SetUpPage
    var pageCordinateX: CGFloat
    var superView: UIView
    var pageView: UIView?
    let setting: SystemSetting = SystemSetting.shared
    
    init(page: SetUpPage, pageCordinateX: CGFloat, layoutGuideView: UIView){
        self.superView = layoutGuideView
        self.page = page
        self.pageCordinateX = pageCordinateX
    }
    
    public func buildSetUpPage() -> UIView {
        createView()
        addButtons()
        return pageView!
    }
        
        
    private func createView() {
        
        self.pageView = UIView(frame: CGRect(x: self.pageCordinateX, y: 0, width: superView.frame.width, height: superView.frame.height))
        self.pageView?.backgroundColor = AppEngine.shared.userSetting.whiteAndBlackBackground
    }
    
    private func addButtons() {
        
        var column = 1
        var buttonX: CGFloat
        var buttonY: CGFloat = -self.setting.optionButtonToTopDistance
        
        var button: UIButton
        let buttonWidth = self.setting.screenFrame.width * self.setting.optionButtonWidthRatio
        let buttonHeight = self.setting.screenFrame.height * self.setting.optionButtonHeightRatio
        
        for dataButton in page.buttons {
            let buttonTitle = dataButton.title
            
            if column == 1 { // left side buttons
                buttonX = self.pageView!.frame.width / 2.0 - buttonWidth - self.setting.optionButtonHorizontalDistance / 2.0
                buttonY += self.setting.optionButtonVerticalDistance + buttonHeight
                column += 1
                
            } else { // right side buttons
                buttonX = self.pageView!.frame.width / 2 + self.setting.optionButtonHorizontalDistance / 2
                column = 1
            }
         
           
            button = UIButton(frame: CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight))
    
            button.layer.cornerRadius = button.frame.height / 2
            button.setShadow()
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(self.setting.optionButtonTitleColor, for: .normal)
            button.setTitleColor(.label, for: .normal)
            button.setTitleColor(.white, for: .selected)
            
            button.setBackgroundColor(AppEngine.shared.userSetting.whiteAndBlackContent, for: .normal)
            button.setBackgroundColor(AppEngine.shared.userSetting.themeColor, for: .selected)
            
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
            
            self.pageView?.addSubview(button)
        }
    }
    
    

}
