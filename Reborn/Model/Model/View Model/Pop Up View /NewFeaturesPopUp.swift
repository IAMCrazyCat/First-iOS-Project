//
//  NewFeaturePopUp.swift
//  Reborn
//
//  Created by Christian Liu on 13/6/21.
//

import Foundation
import UIKit
class NewFeaturesPopUp: PopUpImpl {
    var newFeatures: Array<CustomData>
    init(presentAnimationType: PopUpAnimationType, size: PopUpSize, popUpViewController: PopUpViewController, newFeatures: Array<CustomData>) {
        self.newFeatures = newFeatures
        super.init(presentAnimationType: presentAnimationType, type: .newFeaturesPopUp, size: size, popUpViewController: popUpViewController)
    }

    override func createWindow() -> UIView {
        return NewFeaturesPopUpViewBuilder(popUpViewController: super.popUpViewController, frame: super.frame, newFeatures: self.newFeatures).buildView()
    }
    
    override func setUpUI() {
        super.doneButton?.setTitle("知道了", for: .normal)
        super.titleLabel?.text = "新特性(v\(App.simpleVersion))"
    }
    
    
}
