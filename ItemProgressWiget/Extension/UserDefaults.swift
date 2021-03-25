//
//  UserDefaults.swift
//  Reborn
//
//  Created by Christian Liu on 23/3/21.
//

import Foundation
import UIKit
extension UserDefaults {
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
    
    func image(forKey key: String) -> UIImage? {
        
        if let imageData = data(forKey: key) {
            return UIImage(data: imageData)
        }
        
        return nil
        
    }
}

