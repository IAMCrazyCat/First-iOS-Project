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
        self.tabBar.tintColor = AppEngine.shared.userSetting.themeColor.uiColor.darkColor
        self.view.window?.overrideUserInterfaceStyle = AppEngine.shared.userSetting.uiUserInterfaceStyle
    }
    
    
}
