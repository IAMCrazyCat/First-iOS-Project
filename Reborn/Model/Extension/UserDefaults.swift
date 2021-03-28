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

    
    
    func notificationTime(for key: String) -> Array<CustomTime>? {
        
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

}
