//
//  CustomThemeColorPopUpView.swift
//  Reborn
//
//  Created by Christian Liu on 8/3/21.
//

import Foundation
import UIKit

class CustomThemeColorPopUp: PopUpImpl {

    
    init(presentAnimationType: PopUpAnimationType, popUpViewController: PopUpViewController) {
        super.init(presentAnimationType: presentAnimationType, popUpViewController: popUpViewController, type: .customThemeColorPopUp)
    }
    override func createWindow() -> UIView {
        return CustomThemeColorPopUpViewBuilder(popUpViewController: super.popUpViewController, frame: super.frame).buildView()
    }
    
    override func updateUI() {
    
    }
    

    
}
