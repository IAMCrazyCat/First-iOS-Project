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
    func didDismissPopUpViewWithoutSave()
    func didSaveAndDismissPopUpView(type: PopUpType)
}


class AppEngine {
    
    private var defaults: UserDefaults = UserDefaults.standard
    private let dataFilePath: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("item.plist")
    private let setting: SystemSetting = SystemSetting()
    private var observers: Array<UIObserver> = []
    private var observerNotifier: Timer = Timer()
    private var observerNotifierTimePoints: Array<Int> = []
    private var observerIsNotifiedByNotifier: Bool = false
    
    public static let shared = AppEngine()
    public var currentUser: User = User(name: "颠猫", gender: .undefined, avatar: #imageLiteral(resourceName: "Unknown"), energy: 3, items: [Item](), isVip: false)
    public let userSetting: UserSetting = UserSetting()
    public var storedDataFromPopUpView: Any? = nil
    public var currentViewController: UIViewController? {
        return UIApplication.shared.getTopViewController()
    }

    public var delegate: PopUpViewDelegate?

    private init() {
        
        print(dataFilePath!)
        
        for timePoint in TimeRange.allCases {
            self.observerNotifierTimePoints.append(timePoint.range.first!)
        }
        
        observerNotifier = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in self.changeDetactor() }
        
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
        scheduleNotification()
        updateWidgetData()
    }
    
 
    func changeDetactor() {
        self.checkTime()
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
        self.saveUser(self.currentUser)
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

 
    private func checkTime() {
        if let currentHour = TimeRange.time.hour, let currentMinute = TimeRange.time.minute, self.observerNotifierTimePoints.contains(currentHour), currentMinute == 0, !observerIsNotifiedByNotifier { // notify observers once
            
            self.notifyAllUIObservers()
            observerIsNotifiedByNotifier = true
        } else if let currentHour = TimeRange.time.hour, self.observerNotifierTimePoints.contains(currentHour + 1) { // ready to notifiy all observers one hour before hour points
            observerIsNotifiedByNotifier = false
        }
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
    
    private func loadSetting() {
 
        if let themeColor = defaults.themeColor(forKey: "ThemeColor") {
            userSetting.themeColor = themeColor
        }
        
        if let notificationTime = defaults.notificationTime(for: "NotificationTime") {
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
        
        
        for observer in self.observers {
            DispatchQueue.main.async {
                observer.updateUI()
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
    public func dismissBottomPopUpWithoutSave(thenGoBackTo viewController: PopUpViewController) {
        self.delegate?.didDismissPopUpViewWithoutSave()
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
    
    public func dismissBottomPopUpAndSave(thenGoBackTo viewController: PopUpViewController) {
        
        if let popUp = viewController.popUp {
            self.storedDataFromPopUpView = viewController.getStoredData()
            viewController.dismiss(animated: true, completion: nil)
            self.delegate?.didSaveAndDismissPopUpView(type: popUp.type)
        }
        
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
    
    
   
    
}


