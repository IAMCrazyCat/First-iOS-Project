//
//  SystemAlarm.swift
//  Reborn
//
//  Created by Christian Liu on 29/3/21.
//

import Foundation
import UIKit
struct SystemAlert {
    static func present(_ title: String, and message: String, from viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "知道了", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func present(_ title: String, and message: String, from viewController: UIViewController, action1: UIAlertAction, action2: UIAlertAction, completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(action1)
        alert.addAction(action2)
        viewController.present(alert, animated: true, completion: completion)
    }
}
