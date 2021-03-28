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
    var pageView: UIView = UIView()
    let setting: SystemSetting = SystemSetting.shared
    
    init(page: SetUpPage, pageCordinateX: CGFloat, layoutGuideView: UIView){
        self.superView = layoutGuideView
        self.page = page
        self.pageCordinateX = pageCordinateX
    }
    
    public func buildSetUpPage() -> UIView {
        createView()
        addButtons()
        
        if page.ID == 5 {
            addTextField()
        }
        return pageView
    }
        
        
    private func createView() {
        pageView.accessibilityIdentifier = "PageView"
        pageView.tag = page.ID
        pageView.frame = CGRect(x: self.pageCordinateX, y: 0, width: superView.frame.width, height: superView.frame.height)
        pageView.backgroundColor = AppEngine.shared.userSetting.whiteAndBlackBackground
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
                buttonX = self.pageView.frame.width / 2.0 - buttonWidth - self.setting.optionButtonHorizontalDistance / 2.0
                buttonY += self.setting.optionButtonVerticalDistance + buttonHeight
                column += 1
                
            } else { // right side buttons
                buttonX = self.pageView.frame.width / 2 + self.setting.optionButtonHorizontalDistance / 2
                column = 1
            }
         
           
            button = UIButton(frame: CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight))

            
            button.setCornerRadius()
            button.setShadow()
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(self.setting.optionButtonTitleColor, for: .normal)
            button.setTitleColor(.label, for: .normal)
            button.setTitleColor(.white, for: .selected)
            
            button.setBackgroundColor(AppEngine.shared.userSetting.whiteAndBlackContent, for: .normal)
            button.setBackgroundColor(AppEngine.shared.userSetting.themeColor.uiColor, for: .selected)
            //button.backgroundColor = AppEngine.shared.userSetting.themeColor
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
            
            self.pageView.addSubview(button)
        }
    }
    
    func addTextField() {

        let textField = UITextField()
        textField.setPadding()
        //textField.disableKeyBoard()
        textField.tintColor = AppEngine.shared.userSetting.themeColor.uiColor
        textField.accessibilityIdentifier = "TextField"
        textField.backgroundColor = SystemSetting.shared.grayColor.withAlphaComponent(0.3)
        textField.layer.cornerRadius = self.setting.textFieldCornerRadius
        textField.placeholder = "您的名称"
        textField.tag = self.setting.popUpWindowTextFieldTag
        textField.addTarget(Actions.shared, action: Actions.setUpTextFieldChangedAction, for: .touchDown)
        textField.returnKeyType = .done
       
        self.pageView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.widthAnchor.constraint(equalToConstant: self.pageView.frame.width - 2 * self.setting.mainDistance).isActive = true
        textField.heightAnchor.constraint(equalToConstant: self.setting.textFieldHeight).isActive = true
        textField.centerXAnchor.constraint(equalTo: self.pageView.centerXAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: self.pageView.topAnchor, constant: self.setting.optionButtonToTopDistance).isActive = true
        
    }
    
    

}
