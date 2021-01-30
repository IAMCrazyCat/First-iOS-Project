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
        
        var red: CGFloat = value.red * 255
        var green: CGFloat = value.green * 255
        var blue: CGFloat = value.blue * 255
        var alpha: CGFloat = value.alpha
        //getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
}
