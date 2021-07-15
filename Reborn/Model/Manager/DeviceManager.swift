//
//  DeviceManager.swift
//  Reborn
//
//  Created by Christian Liu on 13/7/21.
//

import Foundation
import UIKit

struct DeviceInfomation {
    let deviceModel: String
    let systemVersion: String
}

class DeviceManager {
   
    public static func getRandomUUID() -> String {
        let uuid = UUID().uuidString
        return uuid
    }
    
    public static func getDeviceModel() -> String {
        return UIDevice.modelName
    }
    
    public static func getSystemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
}
