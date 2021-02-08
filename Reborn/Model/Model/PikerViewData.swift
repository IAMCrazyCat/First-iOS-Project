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
        for day in 1...730 {
            array.append(DataOption(data: day))
        }
        return array
    }
    
    public static var customFrequency: Array<DataOption> = [
        DataOption(title: "每天", data: 1),
        DataOption(title: "每两天", data: 2),
        DataOption(title: "每三天", data: 3),
        DataOption(title: "每四天", data: 4),
        DataOption(title: "每五天", data: 5),
        DataOption(title: "每六天", data: 6),
        DataOption(title: "每周", data: 7),
        DataOption(title: "每两周", data: 14),
        DataOption(title: "每三周", data: 21),
        DataOption(title: "每月", data: 31),
    ]
}
