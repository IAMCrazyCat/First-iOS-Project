//
//  PikerViewData.swift
//  Reborn
//
//  Created by Christian Liu on 1/1/21.
//

import Foundation
struct PickerViewData {
    public static var customTargetDays: Array<DataOption> {
        var array = [DataOption]()
        for day in 0...730 {
            array.append(DataOption(data: day))
        }
        return array
    }
    
    public static var customFrequency: Array<DataOption> = [DataOption(title: "每天", data: 0),
                                                            DataOption(title: "每两天", data: 1),
                                                            DataOption(title: "每三天", data: 2),
                                                            DataOption(title: "每周", data: 6),
                                                            DataOption(title: "每两周", data: 13),
                                                            DataOption(title: "每月", data: 0)]
}
