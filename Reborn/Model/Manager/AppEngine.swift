//
//  AppEngine.swift
//  Reborn
//
//  Created by Christian Liu on 19/12/20.
//

import Foundation
import UIKit
import WidgetKit

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
    public var currentUser: User = User(name: "颠猫", gender: .undefined, avatar: #imageLiteral(resourceName: "DefaultAvatar"), energy: 3, items: [Item](), isVip: false)
    public let userSetting: UserSetting = UserSetting()
    public var storedDataFromPopUpView: Any? = nil
    public var delegate: PopUpViewDelegate?
    public var currentViewController: UIViewController? {
        return UIApplication.shared.getTopViewController()
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
        scheduleNotification()
        updateWidgetData()
        loadtItemCardIcons()
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
            self.notifyAllUIObservers()
            self.updateUserItems()
            storedTimeRange = TimeRange.current
        }
        
        if storedDate != CustomDate.current {
            self.notifyAllUIObservers()
            self.updateUserItems()
            storedDate = CustomDate.current
        }
        
    }

    func updateUserItems() {
        self.currentUser.updateAllItems()
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
    
    func purchaseApp() {
        self.currentUser.isVip = true
        self.currentUser.energy += 5
        self.userSetting.hasViewedEnergyUpdate = false
        self.saveUser()
        self.notifyAllUIObservers()
    }
    
    func purchaseEnergy() {
        self.currentUser.energy += 3
        self.saveUser()
        self.notifyAllUIObservers()
    }
    
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("App has notification permission")
            } else {
                print("App does not have notification permission")
            }
        }
    }
    
    func isNotificationEnabled() -> Bool {
        var isNotificationEnabled = false
        let semaphore = DispatchSemaphore(value: 0)
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            
          if settings.authorizationStatus == .authorized {
            isNotificationEnabled = true
          }
          else {
            isNotificationEnabled = false
          }
            semaphore.signal()
        }
        
        semaphore.wait()
        return isNotificationEnabled
       
    }
    
    func goToDeviceSystemSetting() {
        if let bundleIdentifier = Bundle.main.bundleIdentifier, let appSettings = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
            if UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            }
        }
    }
    
    func addNotification(at time: CustomTime) {
        
        let userHasItemsInProgress = { () -> Bool in
            for item in self.currentUser.items {
                if item.state == .inProgress {
                    return true
                }
            }
            return false
        }

        if self.currentUser.items.count != 0, userHasItemsInProgress() == true {
            
            var item: Item {
                var outputItem = self.currentUser.items.random!
                while outputItem.state != .inProgress {
                    outputItem = self.currentUser.items.random!
                }
                return outputItem
            }
            
            let itemToNotifyUser = item
            
            let content = UNMutableNotificationContent()
            content.title = "\(currentUser.name), 今天\(itemToNotifyUser.type.rawValue)\(itemToNotifyUser.name)了吗"
            content.body = "已打卡 \(itemToNotifyUser.finishedDays)天, 目标: \(itemToNotifyUser.targetDays)天, 进度: \(itemToNotifyUser.progressInPercentageString)"
            
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            dateComponents.hour = time.hour
            dateComponents.minute = time.minute
            
            // Create the trigger as a repeating event.
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            // Create the request
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString,
                        content: content, trigger: trigger)

            // Schedule the request with the system.
            let notificationCenter = UNUserNotificationCenter.current()
            
            notificationCenter.add(request) { (error) in
               if error != nil {
                  print("Notification schedule failed, No user permission")
               } else {
                print("Notification schedule successfully")
               }
            }
        }
    }
    
    func scheduleNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        for time in userSetting.notificationTime {
            DispatchQueue.main.async {
                self.addNotification(at: time)
            }
            
        }
            
    }
    
    func scheduleTemporaryNotification(title: String, body: String, after timeInterval: TimeInterval, identifier: String) {
        let content = UNMutableNotificationContent()
        let soundName = UNNotificationSoundName("DigitalAlarmTwice.m4a")
        content.title = title
        content.body = body
        content.sound = UNNotificationSound(named: soundName)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
           if let error = error{
               print("Error posting notification:\(error.localizedDescription)")
           } else{
               print("notification scheduled")
           }
        }
    }
    
    func removeTemporaryNotification(withIdenifier identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    

 
   
    
    public func saveUser(_ newUser: User = AppEngine.shared.currentUser) {

        let encoder = JSONEncoder()//PropertyListEncoder()

        do {
            let data = try encoder.encode(self.currentUser)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        AppEngine.shared.updateWidgetData()
       
    }
    
    
    private func loadUser() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
           let decoder = JSONDecoder() //PropertyListDecoder()

           do {
                self.currentUser = try decoder.decode(User.self, from: data) // .self 可以提取数据类型
           } catch {
               print(error)
           }
        }
        
        if self.currentUser.isVip {
            print("Welcome back VIP!")
        }
    }
    
    public func saveSetting() {
        defaults.set(userSetting.themeColor, forKey: "ThemeColor")
        defaults.set(userSetting.notificationTime, forKey: "NotificationTime")
        defaults.set(userSetting.appAppearanceMode, forKey: "AppAppearanceMode")
        defaults.set(userSetting.hasViewedEnergyUpdate, forKey: "HasViewedEnergyUpdate")
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
        
        let hasViewedEnergyUpdate = defaults.bool(forKey: "HasViewedEnergyUpdate")
        userSetting.hasViewedEnergyUpdate = hasViewedEnergyUpdate
        
 
    }
    
    public func updateWidgetData() {
        UserDefaults(suiteName: AppGroup.identifier.rawValue)!.set(self.currentUser.getOverAllProgress(), forKey: "OverAllProgress")
        UserDefaults(suiteName: AppGroup.identifier.rawValue)!.set(self.userSetting.themeColor.uiColor, forKey: "ThemeColor")
        UserDefaults(suiteName: AppGroup.identifier.rawValue)!.set(self.currentUser.getAvatarImage(), forKey: "AvatarImage")
        WidgetCenter.shared.reloadAllTimelines()
    }

    public func add(observer: UIObserver) {
        self.observers.append(observer)
    }
    
    public func notifyAllUIObservers() {
        print(observers)
        
        for observer in self.observers {
            DispatchQueue.main.async {
                observer.updateUI()
                print("\((observer as! UIViewController).restorationIdentifier) notified")
            }
            
        }
        print("All Observers Notified")
    }
    
    public func notifyUIObservers(withIdentifier identifier: String) {

        for observer in self.observers {
       
            if let viewController = observer as? UIViewController, viewController.restorationIdentifier == identifier {
                observer.updateUI()
                print("ViewController: \(String(describing: viewController.restorationIdentifier)) notified")
            }
            
        }
        
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
    
    public func getAppVersion() -> String {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let versionBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
        return "\(appVersion).\(versionBuild)"
    }
    
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


