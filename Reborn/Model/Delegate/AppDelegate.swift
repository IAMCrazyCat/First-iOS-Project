//
//  AppDelegate.swift
//  Reborn
//
//  Created by Christian Liu on 16/12/20.
//

import UIKit
import GoogleMobileAds
import UserNotifications
import Purchases
@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if !AppEngine.shared.currentUser.isVip {
            GADMobileAds.sharedInstance().start(completionHandler: nil)
        }
        
        Purchases.debugLogsEnabled = true
        Purchases.configure(withAPIKey: "bSAXvlaUIFweatIwfeZryIrUUYJhnRMZ")
        InAppPurchaseManager.shared.fetchOfferingFromRevenueCat()
        //InAppPurchaseManager.shared.finishPendingTransactions()
        InAppPurchaseManager.shared.checkUserSubsriptionStatus()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
    
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("Terminated")
        
        CustomTimer.killTimer()
        CustomTimer.saveTimer()
        SettingStrategy().saveUserSetting()
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        CustomTimer.saveTimer()
        SettingStrategy().saveUserSetting()
    }
    
   
    
    
   

    


}



