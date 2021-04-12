//
//  SystemAlarm.swift
//  Reborn
//
//  Created by Christian Liu on 29/3/21.
//

import Foundation
import UIKit
struct SystemAlert {
    static func present(_ title: String, and text: String, from viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "知道了", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
