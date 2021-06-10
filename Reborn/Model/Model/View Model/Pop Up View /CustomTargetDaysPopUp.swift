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
    public var pickerViewData: [CustomData] = []
    
    init(presentAnimationType: PopUpAnimationType, size: PopUpSize = .small, dataStartIndex: Int, popUpViewController: PopUpViewController) {
        
        self.dataStartIndex = dataStartIndex
        super.init(presentAnimationType: presentAnimationType, type: .customTargetDaysPopUp, size: size, popUpViewController: popUpViewController)
        
        setPickerViewData()
    }
    
    override func createWindow() -> UIView {
        return CustomTargetDaysPopUpViewBuilder(dataStartIndex: dataStartIndex, popUpViewController: super.popUpViewController, frame: super.frame).buildView()
    }
    
    override func getStoredData() -> Any {
        return self.pickerViewData[pickerView.selectedRow(inComponent: 0)]
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
        
        self.pickerViewData = dataArray
       
    }
    
}

extension CustomTargetDaysPopUp: PickerViewPopUp {
   
    func numberOfComponents() -> Int {
        return 1
    }
    
    func numberOfRowsInComponents() -> Int {
        return self.pickerViewData.count
    }
    
    func titles() -> Array<String> {
        var titles: [String] = []
        for customData in pickerViewData {
            titles.append(customData.title)
        }
        return titles
    }
    
    func didSelectRow() {
        
    }
    
    
    
}
