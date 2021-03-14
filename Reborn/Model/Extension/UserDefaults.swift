//
//  UserDefaults.swift
//  Reborn
//
//  Created by Christian Liu on 14/3/21.
//

import Foundation
import UIKit
extension UserDefaults {
    func color(forKey key: String) -> UIColor? {

        let r = CGFloat(self.double(forKey: "UIColorRed"))
        let g = CGFloat(self.double(forKey: "UIColorGreen"))
        let b = CGFloat(self.double(forKey: "UIColorBlue"))
        let a = CGFloat(self.double(forKey: "UIColorAlpha"))
        
        return UIColor(red: r, green: g, blue: b, alpha: a)

   }

   func set(_ value: UIColor?, forKey key: String) {

    if let color = value {
        self.set(Double(color.value.red), forKey: "UIColorRed")
        self.set(Double(color.value.green), forKey: "UIColorGreen")
        self.set(Double(color.value.blue), forKey: "UIColorBlue")
        self.set(Double(color.value.alpha), forKey: "UIColorAlpha")
    }
   
    
   }

}
