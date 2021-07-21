//
//  AppEngine.swift
//  Reborn
//
//  Created by Christian Liu on 19/12/20.
//

import Foundation
import UIKit
import WidgetKit
import TPInAppReceipt
import StoreKit
protocol PopUpViewDelegate {
    func didDismissPopUpViewWithoutSave(_ type: PopUpType)
    func didSaveAndDismiss(_ type: PopUpType)
}



class AppEngine {
    
    private var defaults: UserDefaults = UserDefaults.standard
    private let dataFilePath: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("item.plist")
    private let setting: SystemSetting = SystemSetting()
    private var observers: Array<UIObserver> = []
    private var observerNotifier: Timer = Timer()
    private var storedDate: CustomDate
    private var storedTimeRange: TimeRange
    private var itemCardIcons: Array<Icon> = []
    
    public static let shared = AppEngine()
    public var currentUser: User = User(ID: SystemSetting.shared.defaultUserID, name: SystemSetting.shared.defaultUserName, gender: SystemSetting.shared.defaultUserGender, avatar: SystemSetting.shared.defaultUserAvatar, energy: SystemSetting.shared.defaultUserEnergy, items: SystemSetting.shared.defaultUserItems, creationDate: SystemSetting.shared.defaultCreationDate)
    public let userSetting: UserSetting = UserSetting()
    public var storedDataFromPopUpView: Any? = nil
    public var delegate: PopUpViewDelegate?
    public var currentViewController: UIViewController? {
        return UIApplication.shared.getCurrentViewController()
    }
    
    

    
    private init() {
        
        print(dataFilePath!)
        storedDate = CustomDate.current
        storedTimeRange = TimeRange.current
        
        observerNotifier = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in self.updateUIByTime() }
        
        if appLaunchedBefore() {
            loadApp()
        } else {
            saveSetting()
        }
        
        UITabBar.appearance().tintColor = self.userSetting.themeColor.uiColor
        UINavigationBar.appearance().tintColor = self.userSetting.smartLabelColorAndWhite
  

    }
    
    func loadApp() {
        loadUser()
        loadSetting()
        updateUserItems()
        schduleNotification()
        updateWidgetData()
        loadtItemCardIcons()
    }
    

    public func requestReview() {
        if let windowScene = UIApplication.shared.windows.first?.windowScene {
            if #available(iOS 14.0, *) {
                SKStoreReviewController.requestReview(in: windowScene)
            } else {
                SKStoreReviewController.requestReview()
            }
        }
    }
    
    private func schduleNotification() {
        NotificationManager.shared.scheduleFixedNotification(at: self.userSetting.notificationTime)
    }
   
    
    
    
    func loadtItemCardIcons() {
        
        DispatchQueue.main.async {
            let path = Bundle.main.resourcePath! + "/ItemCardIcons"
            let fileManager = FileManager.default
            let url = URL(fileURLWithPath: path)
            let properties = [URLResourceKey.localizedNameKey, URLResourceKey.creationDateKey, URLResourceKey.localizedTypeDescriptionKey]
            do {
                let imageURLs = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: properties, options:FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
                
                // Create image from URL
                for url in imageURLs {
                    let imageFileName = url.lastPathComponent
                    let lastCharacters = imageFileName.suffix(7)
                    let icon = Icon(image: UIImage(data: try Data(contentsOf: url))!, isVipIcon: lastCharacters == "vip.png" ? true : false, name: imageFileName)
                    self.itemCardIcons.append(icon)
                }
                self.itemCardIcons.sort {
                    if $0.isVipIcon == $1.isVipIcon {
                        return $0.name < $1.name
                    } else {
                        return !$0.isVipIcon && $1.isVipIcon
                    }
                    
                                    
                }

            } catch let error1 as NSError {
                print(error1.description)
            }
        }
        
    }
    
    func getItemCardIcons() -> Array<Icon> {
        return itemCardIcons
    }
    
    func getItemCardIcon(by name: String) -> Icon? {
        for icon in self.itemCardIcons {
            if name == icon.name {
                return icon
            }
        }
        
        return nil
    }
    
    func getItemCardIconIndex(by name: String) -> Int? {
        var index = 0
        for icon in self.itemCardIcons {
            if name == icon.name {
                return index
            }
            index += 1
        }
        return nil
    }
    
 
    func updateUIByTime() {
        
        if storedTimeRange != TimeRange.current {
            self.updateUserItems()
            UIManager.shared.updateUIAccordingToTimeChange()
            storedTimeRange = TimeRange.current
        }
        
        if storedDate != CustomDate.current {
            self.updateUserItems()
            UIManager.shared.updateUIAccordingToTimeChange()
            storedDate = CustomDate.current
        }
        
    }

    func updateUserItems() {
        self.currentUser.updateAllItems() {
            //self.notifyAllUIObservers()
        }

    }
    
    
    
    func appLaunchedBefore() -> Bool {
        let launchedBefore = UserDefaults.standard.bool(forKey: "LaunchedBefore")
        if launchedBefore {
            print("Not first launch.")
            
        } else {
            
            print("First launch")
            
        }
        return launchedBefore
    }
    
    
    func goToDeviceSystemSetting() {
        if let bundleIdentifier = Bundle.main.bundleIdentifier, let appSettings = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
            if UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            }
        }
    }

    public func saveUser(_ newUser: User = AppEngine.shared.currentUser) {

        if ThreadsManager.shared.userIsLoading {
            
        } else {
            let encoder = JSONEncoder()//PropertyListEncoder()

            do {
                let data = try encoder.encode(self.currentUser)
                try data.write(to: self.dataFilePath!)
            } catch {
                print("Error encoding item array, \(error)")
            }
            
            AppEngine.shared.updateWidgetData()
        }
       
       
    }
    
    public func getUserJsonDic() -> [String: Any]? {

        let encoder = JSONEncoder()//PropertyListEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(self.currentUser)
            do {
                // make sure this JSON is in the format we expect
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // try to read out a string array
                    return json
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
        } catch {
            print("Error encoding item array, \(error)")
            
        }
        
        return nil
    }
   
    
    private func loadUser() {
    
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = JSONDecoder() //PropertyListDecoder()
            do {
                self.currentUser = try decoder.decode(User.self, from: data)
            } catch {
                print("Failed to load user")
                print(error)
            }
        }
        
        if self.currentUser.isVip {
            print("Welcome back VIP!")
        }
    }
    
    
    
    private func loadItemCardViews() {
        //let itemCardViews =
    }
    
    public func saveSetting() {
        defaults.set(userSetting.themeColor, forKey: "ThemeColor")
        defaults.set(userSetting.notificationTime, forKey: "NotificationTime")
        defaults.set(userSetting.appAppearanceMode, forKey: "AppAppearanceMode")
        defaults.set(userSetting.hasViewedEnergyUpdate, forKey: "HasViewedEnergyUpdate")
        defaults.set(userSetting.encourageText, forKey: "EncourageText")
        if appLaunchedBefore() {
            AppEngine.shared.updateWidgetData()
        }
    }
    
    public func loadSetting() {
 
        if let themeColor = defaults.themeColor(forKey: "ThemeColor") {
            userSetting.themeColor = themeColor
        }
        
        if let notificationTime = defaults.customTimes(for: "NotificationTime") {
            userSetting.notificationTime = notificationTime
        }
        if let appAppearanceMode = defaults.appAppearanceMode(for: "AppAppearanceMode") {
            userSetting.appAppearanceMode = appAppearanceMode
        }
        if let encourageText = defaults.stringArray(forKey: "EncourageText") {
            userSetting.encourageText = encourageText
        }
        
        let hasViewedEnergyUpdate = defaults.bool(forKey: "HasViewedEnergyUpdate")
        userSetting.hasViewedEnergyUpdate = hasViewedEnergyUpdate
        
 
    }
    
    public func updateWidgetData() {
        UserDefaults(suiteName: AppGroup.identifier.rawValue)!.set(self.currentUser.getOverAllProgress(), forKey: "OverAllProgress")
        UserDefaults(suiteName: AppGroup.identifier.rawValue)!.set(self.userSetting.themeColor.uiColor, forKey: "ThemeColor")
        UserDefaults(suiteName: AppGroup.identifier.rawValue)!.set(self.currentUser.getAvatarImage(), forKey: "AvatarImage")
        if #available(iOS 14, *) {
            WidgetCenter.shared.reloadAllTimelines()
        } 
       
    }

    public func add(observer: UIObserver) {
        self.observers.append(observer)
    }
    
    public func notifyAllUIObservers(finish: (() -> Void)? = nil) {
        self.updateUserItems()
        
        DispatchQueue.main.async {
            for observer in self.observers {
                observer.updateUI()
                
            }
            finish?()
            print("All Observers Notified")
        }
        
        
    }
    
    public func notifyUIObservers(withIdentifier identifier: String) {

        for observer in self.observers {
            
            if let viewController = observer as? UIViewController, viewController.restorationIdentifier == identifier {
                observer.updateUI()
                print("ViewController: \(String(describing: viewController.restorationIdentifier)) notified")
            }
            
        }
        
    }
    
    public func getUIObserver(withIdentifier identifier: String) -> UIObserver? {
        for observer in self.observers {
       
            if let viewController = observer as? UIViewController, viewController.restorationIdentifier == identifier {
                
                return viewController as? UIObserver
            }
            
        }
        return nil
    }

    
    
    // ------------------------------------ pop up ------------------------------------------------------
    public func dismissBottomPopUpWithoutSave(_ viewController: PopUpViewController) {
        self.delegate?.didDismissPopUpViewWithoutSave(viewController.popUp.type)
        viewController.dismiss(animated: true, completion: nil)
        
        var index = 0
        for observer in self.observers {
            if observer is PopUpViewController {
                self.observers.remove(at: index)
            }
            index += 1
        }
        self.delegate = nil

        
    }
    
    public func dismissBottomPopUpAndSave(_ viewController: PopUpViewController) {
        
        self.storedDataFromPopUpView = viewController.getStoredData()
        viewController.dismiss(animated: true, completion: nil)
        self.delegate?.didSaveAndDismiss(viewController.popUp.type)
        
        var index = 0
        for observer in self.observers {
            if observer is PopUpViewController {
                self.observers.remove(at: index)
            }
            index += 1
        }
        self.delegate = nil
        
    }
    
    
    
    public func getStoredDataFromPopUpView() -> Any {
        return self.storedDataFromPopUpView ?? "No Stored Data"
    }
    
    // ------------------------------------ pop up ------------------------------------------------------
    
  
    
    public func saveTemproraryUserDefaults(value: Any?, forKey key: String) {
        
        if value != nil {
            do {
                let encodedData = try NSKeyedArchiver.archivedData(withRootObject: value!, requiringSecureCoding: false)
                defaults.set(encodedData, forKey: key)
                defaults.synchronize()
            } catch {
                print(error)
            }
        }
        
        
       
    }
    
    public func loadTemproraryUserDefaults(withKey key: String) -> Any? {
        return defaults.value(forKey: key)
    }
    
}


