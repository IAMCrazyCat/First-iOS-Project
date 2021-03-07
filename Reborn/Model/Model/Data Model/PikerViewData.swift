//
//  PikerViewData.swift
//  Reborn
//
//  Created by Christian Liu on 1/1/21.
//

import Foundation
struct PickerViewData {
    public static var customTargetDays: Array<DataModel> {
        var array = [DataModel]()
        for day in 1...730 {
            array.append(DataModel(data: day))
        }
        return array
    }
    
    public static var customFrequency: Array<Frequency> {
        var data: Array<Frequency> = []
        for freqency in Frequency.allCases {
            data.append(freqency)
        }
        return data
    }
}
