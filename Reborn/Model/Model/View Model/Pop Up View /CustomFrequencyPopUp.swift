//
//  CustomFrequencyPopUp.swift
//  Reborn
//
//  Created by Christian Liu on 8/3/21.
//

import Foundation
import UIKit

class CustomFrequencyPopUp: PopUpImpl {
    
    var dataStartIntex: Int = 0
    var pickerView: UIPickerView? {
        return super.contentView?.getSubviewBy(idenifier: "PickerView") as? UIPickerView
    }
    
    var pikerViewData: Array<Any> = []

    init(presentAnimationType: PopUpAnimationType, size: PopUpSize = .small, dataStartIndex: Int, popUpViewController: PopUpViewController) {

        self.dataStartIntex = dataStartIndex
        super.init(presentAnimationType: presentAnimationType, type: .customFrequencyPopUp, size: size, popUpViewController: popUpViewController)
       
        setPickerViewData()
    }
    
    override func createWindow() -> UIView {
        return CustomFrequencyPopUpViewBuilder(dataStartIndex: self.dataStartIntex, popUpViewController: super.popUpViewController, frame: super.frame).buildView()
    }
    
    override func getStoredData() -> Any? {
        if pickerView != nil {
            return self.pikerViewData[pickerView!.selectedRow(inComponent: 0)]
        } else {
            return nil
        }
        
    }
    
    func setPickerViewData() {
        pickerView?.delegate = popUpViewController
        pickerView?.dataSource = popUpViewController
        
        var dataArray = PickerViewData.customFrequency
        if dataStartIntex > 0 {
            for _ in 0 ... dataStartIntex - 1 {
                if dataArray.count > 0 {
                    dataArray.removeFirst()
                }
            }
        }
        
        self.pikerViewData = dataArray

    }
    
    
}
