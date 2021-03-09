//
//  CustomTargetDaysPopUpView.swift
//  Reborn
//
//  Created by Christian Liu on 8/3/21.
//

import Foundation
import UIKit

class CustomTargetDaysPopUp: PopUpImpl {
    
    public var pickerView: UIPickerView {
        return super.contentView?.getSubviewBy(idenifier: "PickerView") as! UIPickerView
    }
    
    public var dataStartIndex: Int
    public var pikerViewData: Array<Any> = []
    
    init(presentAnimationType: PopUpAnimationType, popUpViewController: PopUpViewController, dataStartIndex: Int) {
        
        self.dataStartIndex = dataStartIndex
        super.init(presentAnimationType: presentAnimationType, popUpViewController: popUpViewController, type: .customTargetDaysPopUp)
        
        setPickerViewData()
    }
    
    override func createWindow() -> UIView {
        return CustomTargetDaysPopUpViewBuilder(dataStartIndex: dataStartIndex, popUpViewController: super.popUpViewController, frame: super.frame).buildView()
    }
    
    override func getStoredData() -> Any {
        return self.pikerViewData[pickerView.selectedRow(inComponent: 0)]
    }
    
    override func updateUI() {
        
    }
    
    func setPickerViewData() {
        pickerView.delegate = popUpViewController
        pickerView.dataSource = popUpViewController
        
        var dataArray = PickerViewData.customTargetDays
        if dataStartIndex > 0 {
            for _ in 0 ... dataStartIndex - 1 {
                
                if dataArray.count > 0 {
                    dataArray.removeFirst()
                }
                
            }
        }
        
        self.pikerViewData = dataArray
       
    }
    
}
