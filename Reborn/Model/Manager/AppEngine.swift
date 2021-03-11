//
//  AppEngine.swift
//  Reborn
//
//  Created by Christian Liu on 19/12/20.
//

import Foundation
import UIKit
protocol PopUpViewDelegate {
    func didDismissPopUpViewWithoutSave()
    func didSaveAndDismissPopUpView(type: PopUpType)
}


class AppEngine {
    
    public static let shared = AppEngine()
    public var currentUser: User = User(name: "颠猫", gender: .undefined, avatar: #imageLiteral(resourceName: "Test"), keys: 3, items: [Item](), vip: false)
    public var defaults: UserDefaults = UserDefaults.standard
    public let dataFilePath: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("item.plist")
    public let setting: SystemSetting = SystemSetting()
    public let userSetting: UserSetting = UserSetting()
    public var overAllProgress: Double = 0.0
    public var storedDataFromPopUpView: Any? = nil
    public var itemFromController: Item? = nil
    public var currentViewController: UIViewController? = nil

    public var time: DateComponents {
        let date = Date()
        return Calendar.current.dateComponents([.hour,.minute,.second], from: date)
    }
    public var currentTimeRange: TimeRange {
        
        for timeRange in TimeRange.allCases {

            if timeRange.range.contains(self.time.hour!) {
                
                return timeRange
            }
        }
        return .morning
    }
    
    public var currentDate: CustomDate {
        let date = Date()
        let currentYear: Int = Calendar.current.component(.year, from: date)
        let currentMonth: Int = Calendar.current.component(.month, from: date)
        let currentDay: Int = Calendar.current.component(.day, from: date)
        return CustomDate(year: currentYear, month: currentMonth, day: currentDay)
    }
    
    
    public var delegate: PopUpViewDelegate?
    private var observers: Array<UIObserver> = []
    private var observerNotifier: Timer = Timer()
    private var observerNotifierTimePoints: Array<Int> = []
    private var observerIsNotifiedByNotifier: Bool = false
    
    private init() {
        
        print(dataFilePath!)
        
        for timePoint in TimeRange.allCases {
            self.observerNotifierTimePoints.append(timePoint.range.first!)
        }
        
        observerNotifier = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in self.checkUpdate() }
        loadUser()
        initUserSetting()
    }
    
    func changeThemeColor(to newThemeColor: ThemeColor) {
        
        self.currentUser.themeColorSetting = newThemeColor
        self.userSetting.themeColor = newThemeColor.uiColor
        self.notifyAllUIObservers()
        self.saveUser(self.currentUser)
    }
    
    func initUserSetting() {
        if let themeColor = currentUser.themeColorSetting {
            changeThemeColor(to: themeColor)
        }
    }
    
    func checkIfAppLaunchedBefore() -> Bool {
        let launchedBefore = UserDefaults.standard.bool(forKey: "LaunchedBefore")
        if launchedBefore {
            print("Not first launch.")
            
        } else {
            
            print("First launch")
            UserDefaults.standard.set(true, forKey: "LaunchedBefore")
        }
        return launchedBefore
    }
    
    func purchaseApp() {
        self.currentUser.vip = true
        self.saveUser(self.currentUser)
        self.notifyAllUIObservers()
    }
    
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
    }
    
    func scheduleNotification() {
        if self.currentUser.items.count != 0 {
            var item: Item {
                var outputItem = self.currentUser.items[Int.random(in: 0 ... self.currentUser.items.count - 1)]
                while outputItem.state != .inProgress {
                    
                    outputItem = self.currentUser.items[Int.random(in: 0 ... self.currentUser.items.count - 1)]
                }
                return outputItem
            }

            
            let content = UNMutableNotificationContent()
            content.title = "今天\(item.type.rawValue)\(item.name)了吗"
            content.body = "已打卡 \(item.finishedDays)天, 进度: \(item.progressInPercentageString)"
            
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            dateComponents.hour = userSetting.notificationHour
            dateComponents.minute = userSetting.notificationMinute
            
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
                  print("没有权限")
               }
            }
        }
            
       
    }

    
    
    
    private func checkUpdate() {
        if let currentHour = self.time.hour, let currentMinute = self.time.minute, self.observerNotifierTimePoints.contains(currentHour), currentMinute == 0, !observerIsNotifiedByNotifier { // notify observers once
            
            self.notifyAllUIObservers()
            observerIsNotifiedByNotifier = true
        } else if let currentHour = self.time.hour, self.observerNotifierTimePoints.contains(currentHour + 1) { // ready to notifiy all observers one hour before hour points
            observerIsNotifiedByNotifier = false
        }
    }
    
    public func saveUser(_ user: User) {

        let encoder = JSONEncoder()//PropertyListEncoder()

        do {
            let data = try encoder.encode(self.currentUser)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
    
       
    }
    
    
    public func loadUser() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
           let decoder = JSONDecoder() //PropertyListDecoder()

           do {
                self.currentUser = try decoder.decode(User.self, from: data) // .self 可以提取数据类型
           } catch {
               print(error)
           }
        }
        
        if self.currentUser.vip {
            print("Welcome back VIP!")
        }
    }
    
    public func add(newItem: Item) {
        
        self.currentUser.items.append(newItem)
        
        self.saveUser(self.currentUser)

    }
    
    public func delete(item itemforDeleting: Item) {
        var index = 0
        for item in self.currentUser.items {
            if item.ID == itemforDeleting.ID {
                self.currentUser.items.remove(at: index)
            }
            index += 1
        }

        self.saveUser(self.currentUser)
        self.notifyAllUIObservers()
    }
    
    
    public func getItems() -> Array<Item>? {
 
        return self.currentUser.items
    }
    
    public func getLargestItemID() -> Int {
        var largestID = 0
        for item in self.currentUser.items {
            let ID = item.ID
            if ID > largestID {
                largestID = ID
            }
        }
        return largestID
    }
    
    
    public func updateItem(tag index: Int) {
        
        let item = self.currentUser.items[index]
        if !item.isPunchedIn {
            
            let currentYear: Int = Calendar.current.component(.year, from: Date())
            let currentMonth: Int = Calendar.current.component(.month, from: Date())
            let currentDay: Int = Calendar.current.component(.day, from: Date())
            item.punchIn(punchInDate: CustomDate(year: currentYear, month: currentMonth, day: currentDay))
            Vibrator.vibrate(withNotificationType: .success)
        } else {
            self.currentUser.items[index].revokePunchIn()
            Vibrator.vibrate(withImpactLevel: .light)
        }
        
        self.saveUser(self.currentUser)
        
       
    }
    
    public func getItemBy(tag index: Int) -> Item {
        return self.currentUser.items[index]
    }
    

    public func getOverAllProgress() -> Double {
        
        self.overAllProgress = 0.0
        

        for item in self.currentUser.items {
           
            if item.targetDays != 0 {
                let itemProgress = Double(item.finishedDays) / Double(item.targetDays)
    
                self.overAllProgress += itemProgress
            }

        }
        
        if self.currentUser.items.count != 0 {
            self.overAllProgress /= Double(self.currentUser.items.count)
        }
        
        
        return self.overAllProgress
       
    }
    
    public func getTodayProgress() -> String {
        var numberOfPunchedInItems: Int = 0
        for item in self.currentUser.items {
            if item.isPunchedIn {
                numberOfPunchedInItems += 1
            }
        }
        return "\(numberOfPunchedInItems)/\(self.currentUser.items.count)"
    }
    
    // ------------------------------------ observer ------------------------------------------------------
    public func add(observer: UIObserver) {
        self.observers.append(observer)
    }
    
    public func notifyAllUIObservers() {

        for observer in self.observers {
            observer.updateUI()
        }
    }
    // ------------------------------------ observer end ------------------------------------------------------
    
    
    
 
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
    
    
    
  
    
}


