//
//  ViewController.swift
//  Reborn
//
//  Created by Christian Liu on 18/3/21.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        AppEngine.shared.add(observer: self)
    }
    

}

extension TabBarViewController: UIObserver {
    func updateUI() {
        self.tabBar.tintColor = AppEngine.shared.userSetting.themeColor
        
        if AppEngine.shared.userSetting.appAppearanceMode == .lightMode {
            view.window?.overrideUserInterfaceStyle = .light
        } else if AppEngine.shared.userSetting.appAppearanceMode == .darkMode {
            view.window?.overrideUserInterfaceStyle = .dark
        } else {
            view.window?.overrideUserInterfaceStyle = .unspecified
        }
    }
    
    
}
