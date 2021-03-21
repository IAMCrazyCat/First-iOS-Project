//
//  LightAndDarkModePopUp.swift
//  Reborn
//
//  Created by Christian Liu on 20/3/21.
//

import Foundation
import UIKit
class LightAndDarkModePopUp: PopUpImpl {

    var followSystemButton: UIButton? {
        return super.contentView?.getSubviewBy(idenifier: "FollowSystemButton") as? UIButton
    }
    
    var lightModeButton: UIButton? {
        return super.contentView?.getSubviewBy(idenifier: "LightModeButton") as? UIButton
    }
    
    var darkModeButton: UIButton? {
        return super.contentView?.getSubviewBy(idenifier: "DarkModeButton") as? UIButton
    }
    
    init(presentAnimationType: PopUpAnimationType, size: PopUpSize = .small, popUpViewController: PopUpViewController) {
        super.init(presentAnimationType: presentAnimationType, type: .lightAndDarkModePopUp, size: size, popUpViewController: popUpViewController)
        
    }
    
    override func createWindow() -> UIView {
        return LightAndDarkModePopUpViewBuilder(popUpViewController: super.popUpViewController, frame: super.frame, currentMode: AppEngine.shared.userSetting.appAppearanceMode).buildView()
    }
    
    override func updateUI() {
        
      
        
        print("FUCK!!!!")
        
    }
}

