//
//  UserDefaults.swift
//  Reborn
//
//  Created by Christian Liu on 14/3/21.
//

import Foundation
import UIKit
extension UserDefaults {
   
    
    func set(_ value: UIColor?, forKey key: String) {

        if let color = value {
            self.set(Double(color.value.red), forKey: "UIColorRed")
            self.set(Double(color.value.green), forKey: "UIColorGreen")
            self.set(Double(color.value.blue), forKey: "UIColorBlue")
            self.set(Double(color.value.alpha), forKey: "UIColorAlpha")
        }

    }
    
    func set(_ value: Array<CustomTime>?, forKey key: String) {
        
        if value != nil {
            
            do {
                let encodedData = try NSKeyedArchiver.archivedData(withRootObject: value!, requiringSecureCoding: false)
                self.set(encodedData, forKey: key)
                self.synchronize()
            } catch {
                print(error)
            }
            
           
        }

    }
    
    func set(_ value: CustomTime?, forKey key: String) {
        
        if value != nil {
            
            do {
                let encodedData = try NSKeyedArchiver.archivedData(withRootObject: value!, requiringSecureCoding: false)
                self.set(encodedData, forKey: key)
                self.synchronize()
            } catch {
                print(error)
            }
            
           
        }

    }
    
    func set(_ value: CustomDate?, forKey key: String) {
        
        if value != nil {
            
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(value!) {
                self.set(encoded, forKey: key)
            }

        }

    }
    
    
    func set(_ value: AppAppearanceMode?, forKey key: String) {
        if value != nil {
            do {
                let encodedData = try NSKeyedArchiver.archivedData(withRootObject: value!.rawValue, requiringSecureCoding: false)
                self.set(encodedData, forKey: key)
                self.synchronize()
            } catch {
                print(error)
            }
        }
    }
    
    func set(_ value: UIImage?, forKey key: String) {
        if value != nil {
            let imageData = value!.pngData()
            self.set(imageData, forKey: key)
        }
    }
    
    func set(_ value: ThemeColor?, forKey key: String) {
        if value != nil {
            self.set("\(value!.rawValue)", forKey: key)
        }
    }
    
    func set(_ value: CustomData?, forKey key: String) {
        if value != nil {
            self.set(true, forKey: "CustomDataIsNotNil")
            self.set(value!.title, forKey: "CustomDataTitle")
            self.set(value!.body, forKey: "CustomDataBody")
            self.set(value!.status, forKey: "CustomDataStatus")
            self.set(value!.data, forKey: "CustomDataData")
            
            if value!.status != nil {
                self.set(true, forKey: "CustomDataStatusIsNotNil")
            } else {
                self.set(false, forKey: "CustomDataStatusIsNotNil")
            }
            
            if value!.data != nil {
                self.set(true, forKey: "CustomDataDataIsNotNil")
            } else {
                self.set(false, forKey: "CustomDataDataIsNotNil")
            }
            
        } else {
            self.set(false, forKey: "CustomDataIsNotNil")
        }
    }
    
    
    func color(forKey key: String) -> UIColor? {

        let r = CGFloat(self.double(forKey: "UIColorRed"))
        let g = CGFloat(self.double(forKey: "UIColorGreen"))
        let b = CGFloat(self.double(forKey: "UIColorBlue"))
        let a = CGFloat(self.double(forKey: "UIColorAlpha"))
        
        if r == 0 && g == 0 && b == 0 && a == 0 {
            return nil
        } else {
            return UIColor(red: r, green: g, blue: b, alpha: a)
        }

    }
    
    func themeColor(forKey key: String) -> ThemeColor? {
        if let rawValue = self.string(forKey: key) {
            return ThemeColor(rawValue: rawValue)
        }
        return nil
    }

    
    
    func customTimes(for key: String) -> Array<CustomTime>? {
        
        if  let decoded = self.data(forKey: key) {
            do {
                let decodedNotificationTime = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as? Array<CustomTime>
                return decodedNotificationTime
            } catch {
                print(error)
            }
            
        }
        
      return nil
        
    }
    
    func customTime(for key: String) -> CustomTime? {
        
        if  let decoded = self.data(forKey: key) {
            do {
                let decodedNotificationTime = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as? CustomTime
                return decodedNotificationTime
            } catch {
                print(error)
            }
            
        }
        
      return nil
        
    }
    
    func customDate(for key: String) -> CustomDate? {
        
        if let savedDate = self.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let loadedDate = try? decoder.decode(CustomDate.self, from: savedDate) {
                return loadedDate
            }
        }
        
      return nil
        
    }
    
    func appAppearanceMode(for key: String) -> AppAppearanceMode? {
        
        if  let decoded = self.data(forKey: key) {
            do {
                let decodedAppAppearanceModeRawValue = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as? String
                
                for appAppearanceMode in AppAppearanceMode.allCases {
                    if appAppearanceMode.rawValue == decodedAppAppearanceModeRawValue {
                        return appAppearanceMode
                    }
                }
            } catch {
                print(error)
            }
            
        }
        
      return nil
    }
    
    func image(forKey key: String) -> UIImage? {
        
        if let imageData = data(forKey: key) {
            return UIImage(data: imageData)
        }
        
        return nil
        
    }
    
    func customData(forKey key: String) -> CustomData? {
        let isNotNil = bool(forKey: "CustomDataIsNotNil")
        
        if isNotNil {
            let title = string(forKey: "CustomDataTitle")
            let body = string(forKey: "CustomDataBody")
            let status = bool(forKey: "CustomDataStatus")
            let data = integer(forKey: "CustomDataData")
            
            let statusIsNil = !bool(forKey: "CustomDataStatusIsNotNil")
            let dataIsNil = !bool(forKey: "CustomDataDataIsNotNil")
            

            if title == nil {
                return nil
            } else {
                
                if statusIsNil && dataIsNil {
                    return CustomData(title: title!, body: body, data: nil, status: nil)
                } else if statusIsNil && !dataIsNil {
                    return CustomData(title: title!, body: body, data: data, status: nil)
                } else if !statusIsNil && dataIsNil {
                    return CustomData(title: title!, body: body, data: nil, status: status)
                }
                
            }
            
        }
        
        return nil
        
    }

}
