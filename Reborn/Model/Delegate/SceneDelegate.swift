//
//  SceneDelegate.swift
//  Reborn
//
//  Created by Christian Liu on 16/12/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = scene as? UIWindowScene else { return }
        
        UNUserNotificationCenter.current().delegate = self
     
        if AppEngine.shared.appLaunchedBefore() {
            
            let viewController = storyboard.instantiateViewController (withIdentifier: "TabBarController") as? UITabBarController
            window = UIWindow(windowScene: windowScene)
            window?.rootViewController = viewController
            window?.makeKeyAndVisible()
            
        } else {
            
            let viewController = storyboard.instantiateViewController (withIdentifier: "SetUpViewController") as? SetUpViewController
            window = UIWindow(windowScene: windowScene)
            window?.rootViewController = viewController
            window?.makeKeyAndVisible()
            AppEngine.shared.requestNotificationPermission()
        }
        
        window?.overrideUserInterfaceStyle = AppEngine.shared.userSetting.uiUserInterfaceStyle
       
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    


    func sceneDidDisconnect(_ scene: UIScene) {
        SettingStrategy().saveUserSetting()
        CustomTimer.saveTimer()
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        SettingStrategy().saveUserSetting()
        CustomTimer.recoverTimer()
        AppEngine.shared.notifyUIObservers(withIdentifier: "UserCenterViewController")
        AppEngine.shared.notifyUIObservers(withIdentifier: "PopUpViewController")

    }

    func sceneWillResignActive(_ scene: UIScene) {
        CustomTimer.saveTimer()
        
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        //CustomTimer.recoverTimer()
        AppEngine.shared.updateUIByTime()
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
       
        SettingStrategy().saveUserSetting()
        //CustomTimer.saveTimer()
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    
    private func redirectToTomatoClockViewControll() {
        
//        let window = UIApplication.shared.connectedScenes
//        .filter({$0.activationState == .foregroundActive})
//        .map({$0 as? UIWindowScene})
//        .compactMap({$0})
//        .first?.windows
//        .filter({$0.isKeyWindow}).first

        // you can assign your vc directly or push it in navigation stack as follows:
        self.window?.makeKeyAndVisible()
        let tabBarViewController = self.window?.rootViewController as? TabBarViewController
        
        if tabBarViewController?.selectedIndex != 2 {
            tabBarViewController?.selectedIndex = 2
        }
        let navigationController = (self.window?.rootViewController as? TabBarViewController)?.viewControllers![2] as? UINavigationController
        
        if navigationController?.visibleViewController?.restorationIdentifier != "TomatoClockViewController" {
            let tomatoClockViewController = self.storyboard.instantiateViewController(withIdentifier: "TomatoClockViewController") as? TomatoClockViewController
            navigationController?.pushViewController(tomatoClockViewController!, animated: true)
        } else {

        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
//
//
//        })
        
        
        
    }
    

}

extension SceneDelegate: UNUserNotificationCenterDelegate {
    // This function will be called when the app receive notification
     func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
       // show the notification alert (banner), and with sound
       completionHandler([.alert, .sound])
     }
       
     // This function will be called right after user tap on the notification
     func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
         
        print("Notification called")
        print(response.notification.request.identifier)
        let application = UIApplication.shared
        
        if (application.applicationState == .active) {
            print("user tapped the notification bar when the app is in foreground")
            response.notification.request.identifier == "TomatoClock" ? redirectToTomatoClockViewControll() : ()
        }
          
        if (application.applicationState == .inactive) {
            response.notification.request.identifier == "TomatoClock" ? redirectToTomatoClockViewControll() : ()
        }
        
       // tell the app that we have finished processing the user’s action / response
        completionHandler()
     }
}

