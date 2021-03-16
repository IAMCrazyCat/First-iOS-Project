//
//  UIImage.swift
//  Reborn
//
//  Created by Christian Liu on 17/2/21.
//

import Foundation
import UIKit

extension UIImage {
    convenience init(color: UIColor, size: CGSize) {

        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.set()
        let context = UIGraphicsGetCurrentContext()!
        context.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.init(data: image.pngData()!)!
    }
    
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
    
    static func render(size: CGSize, _ draw: () -> Void) -> UIImage? {
            UIGraphicsBeginImageContext(size)
            defer { UIGraphicsEndImageContext() }
            
            draw()
            
            return UIGraphicsGetImageFromCurrentImageContext()?
                .withRenderingMode(.alwaysTemplate)
        }
        
    static func make(size: CGSize, color: UIColor = .white) -> UIImage? {
        return render(size: size) {
            color.setFill()
            UIRectFill(CGRect(origin: .zero, size: size))
        }
    }

}
