//
//  UIApplication.swift
//  Reborn
//
//  Created by Christian Liu on 8/1/21.
//

import Foundation
import UIKit

extension UIApplication {

    class func getTopViewController() -> UIViewController? {

        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
                return topController
            }
        }
        
        return nil
    }
    
    class func getPresentedViewController() -> UIViewController? {
        var presentViewController = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentViewController?.presentedViewController
        {
            presentViewController = pVC
        }

        return presentViewController
      }
    
}

