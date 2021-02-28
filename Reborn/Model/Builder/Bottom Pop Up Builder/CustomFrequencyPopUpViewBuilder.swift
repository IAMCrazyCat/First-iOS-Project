//
//  CustomFrequencyPopUpViewBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 25/2/21.
//

import Foundation
import UIKit

class CustomFrequencyPopUpViewBuilder: PopUpViewBuilder {
    
    private var dataStartIndex: Int = 0
    
    init(dataStartIndex: Int, popUpViewController: PopUpViewController) {
        super.init(popUpViewController: popUpViewController)
        self.dataStartIndex = dataStartIndex
        
    }

    
    override func buildView() -> UIView {
        let outPutView = super.buildView()
        super.titleLabel.text = "自定义频率"
        self.addFrequencyPicker()
        return outPutView
    }
    
    private func addFrequencyPicker() {
        
        let picker = UIPickerView()
        picker.backgroundColor = AppEngine.shared.userSetting.whiteAndBlackBackground
        picker.tag = self.setting.popUpWindowPickerViewTag
        picker.delegate = popUpViewController
        picker.dataSource = popUpViewController
        
        var dataArray = PickerViewData.customFrequency
        if dataStartIndex > 0 {
            for _ in 0 ... dataStartIndex - 1 {
                if dataArray.count > 0 {
                    dataArray.removeFirst()
                }
            }
        }
        
        popUpViewController?.pikerViewData = dataArray
        self.contentView.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.widthAnchor.constraint(equalToConstant: self.setting.screenFrame.width - 2 * self.setting.mainDistance).isActive = true
        picker.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        picker.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
    }
    
}
