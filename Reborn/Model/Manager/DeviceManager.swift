//
//  DeviceManager.swift
//  Reborn
//
//  Created by Christian Liu on 13/7/21.
//

import Foundation
import UIKit

class DeviceManager {
    public static let shared: DeviceManager = DeviceManager()
    private init() {}
    
    public func getRandomUUID() -> String {
        let uuid = UUID().uuidString
        return uuid
    }
    
    public func getDeviceModel() -> String {
        return UIDevice.modelName
    }
    
    public func getSystemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
}
