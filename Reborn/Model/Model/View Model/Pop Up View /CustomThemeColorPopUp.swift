//
//  CustomThemeColorPopUpView.swift
//  Reborn
//
//  Created by Christian Liu on 8/3/21.
//

import Foundation
import UIKit

class CustomThemeColorPopUp: PopUpImpl {

    
    init(presentAnimationType: PopUpAnimationType, size: PopUpSize = .small, popUpViewController: PopUpViewController) {
        super.init(presentAnimationType: presentAnimationType, type: .customThemeColorPopUp, size: size, popUpViewController: popUpViewController)
    }
    override func createWindow() -> UIView {
        return CustomThemeColorPopUpViewBuilder(popUpViewController: super.popUpViewController, frame: super.frame).buildView()
    }
    
    override func updateUI() {
    
    }
    

    
}
