//
//  CustomTargetDaysPopUpBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 25/2/21.
//

import Foundation
import UIKit

class CustomTargetDaysPopUpViewBuilder: PopUpViewBuilder {
    
    private var dataStartIndex: Int = 0
    
    init(dataStartIndex: Int, popUpViewController: PopUpViewController, frame: CGRect) {
        super.init(popUpViewController: popUpViewController, frame: frame)
        self.dataStartIndex = dataStartIndex
        
    }
    
    override func buildView() -> UIView {
        _ = super.buildView()
        self.setUpUI()
        self.addTargetDaysPiker()
        return super.outPutView
    }
    
    private func setUpUI() {
        super.titleLabel.text = "自定义目标"
    }
    
    private func addTargetDaysPiker() {
        
        let picker = UIPickerView()
        picker.accessibilityIdentifier = "PickerView"
        picker.backgroundColor = AppEngine.shared.userSetting.whiteAndBlackBackground
       

        super.contentView.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.widthAnchor.constraint(equalTo: super.contentView.widthAnchor).isActive = true
        picker.centerXAnchor.constraint(equalTo: super.contentView.centerXAnchor).isActive = true
        picker.centerYAnchor.constraint(equalTo: super.contentView.centerYAnchor).isActive = true
    }
}
