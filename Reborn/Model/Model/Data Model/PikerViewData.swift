//
//  PikerViewData.swift
//  Reborn
//
//  Created by Christian Liu on 1/1/21.
//

import Foundation
struct PickerViewData {
    public static var customTargetDays: Array<CustomData> {
        var array = [CustomData]()
        for day in 1...730 {
            array.append(CustomData(data: day))
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
    
    public static var tomatoClockTimes: Array<CustomData> = [CustomData(title: "1分钟", data: 1),
                                                             CustomData(title: "20分钟", data: 20),
                                                             CustomData(title: "25分钟", data: 25),
                                                             CustomData(title: "30分钟", data: 30),
                                                             CustomData(title: "35分钟", data: 35),
                                                             CustomData(title: "40分钟", data: 40),
                                                             CustomData(title: "45分钟", data: 45),
                                                             CustomData(title: "50分钟", data: 50),
                                                             CustomData(title: "55分钟", data: 55),
                                                             CustomData(title: "60分钟", data: 60)]
    
    public static var tomatoClockBreakTimes: Array<CustomData> = [CustomData(title: "5分钟", data: 5),
                                                                  CustomData(title: "10分钟", data: 10),
                                                                  CustomData(title: "15分钟", data: 15),
                                                                  CustomData(title: "20分钟", data: 20),
                                                                  CustomData(title: "25分钟", data: 25),
                                                                  CustomData(title: "30分钟", data: 30)]
}
