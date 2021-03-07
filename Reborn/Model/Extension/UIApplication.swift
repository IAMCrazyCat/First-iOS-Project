//
//  UIApplication.swift
//  Reborn
//
//  Created by Christian Liu on 8/1/21.
//

import Foundation
import UIKit

extension UIApplication {
    
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 38482
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                guard let statusBarFrame = keyWindow?.windowScene?.statusBarManager?.statusBarFrame else { return nil }
                let statusBarView = UIView(frame: statusBarFrame)
                statusBarView.tag = tag
                keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        } else {
            return nil
        }
    }

    

    func getTopViewController() -> UIViewController? {

        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        if var topController = keyWindow?.rootViewController {
           
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
                return topController
            }
            
            if let tabBarController = topController as? UITabBarController {
                return tabBarController.selectedViewController
            }
            
        }
        
        return nil
    }

}

