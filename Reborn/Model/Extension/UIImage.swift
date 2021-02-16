//
//  UIImage.swift
//  Reborn
//
//  Created by Christian Liu on 17/2/21.
//

import Foundation
import UIKit

extension UIImage {
    public class func renderImageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
           UIGraphicsBeginImageContext(size)
           guard let context = UIGraphicsGetCurrentContext() else {
               UIGraphicsEndImageContext()
               return UIImage()
           }
           context.setFillColor(color.cgColor);
           context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height));
           let img = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           return img ?? UIImage()
       }

}
