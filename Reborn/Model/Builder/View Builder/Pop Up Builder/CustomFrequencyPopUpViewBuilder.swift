//
//  CustomFrequencyPopUpViewBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 25/2/21.
//

import Foundation
import UIKit

class CustomFrequencyPopUpViewBuilder: PopUpViewBuilder {
    
    private var dataStartIndex: Int
    
    init(dataStartIndex: Int, popUpViewController: PopUpViewController, frame: CGRect) {
        self.dataStartIndex = dataStartIndex
        super.init(popUpViewController: popUpViewController, frame: frame)
        
        
    }

    
    override func buildView() -> UIView {
        super.buildView()
        self.setUpUI()
        self.addFrequencyPicker()
        return super.outPutView
    }
    
    private func setUpUI() {
        super.titleLabel.text = "自定义频率"
    }
    
    private func addFrequencyPicker() {
        
        let picker = UIPickerView()
        picker.accessibilityIdentifier = "PickerView"
        picker.backgroundColor = AppEngine.shared.userSetting.whiteAndBlackBackground
       
        
        self.contentView.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.widthAnchor.constraint(equalTo: super.contentView.widthAnchor).isActive = true
        picker.topAnchor.constraint(equalTo: super.contentView.topAnchor).isActive = true
        picker.bottomAnchor.constraint(equalTo: super.contentView.bottomAnchor).isActive = true
    }
    
}
