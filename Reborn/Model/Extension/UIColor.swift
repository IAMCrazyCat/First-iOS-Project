//
//  UIColor.swift
//  Reborn
//
//  Created by Christian Liu on 7/1/21.
//

import Foundation
import UIKit
extension UIColor {
    
    var value: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
           var red: CGFloat = 0
           var green: CGFloat = 0
           var blue: CGFloat = 0
           var alpha: CGFloat = 0
           getRed(&red, green: &green, blue: &blue, alpha: &alpha)

           return (red, green, blue, alpha)
       }
    
    var absoluteValue: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        
        let red: CGFloat = value.red * 255
        let green: CGFloat = value.green * 255
        let blue: CGFloat = value.blue * 255
        let alpha: CGFloat = value.alpha
        //getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
    
    var invertColor: UIColor {
        return UIColor(red: 1 - value.red, green: 1 - value.green, blue: 1 - value.blue, alpha: 1)
    }
    
    var brightColor: UIColor {
        return UIColor(red: value.red * 1.2, green: value.green * 1.2, blue: value.blue * 1.2, alpha: 1)
    }
    
//    var fadeColor: UIColor {
//        return self.withAlphaComponent(0.4)
//    }
}
