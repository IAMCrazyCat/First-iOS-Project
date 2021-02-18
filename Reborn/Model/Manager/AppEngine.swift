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
    public let setting: SystemStyleSetting = SystemStyleSetting()
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
    
    
    private var delegate: PopUpViewDelegate?
    private var observers: Array<Observer> = []
    private var observerNotifier: Timer = Timer()
    private var observerNotifierTimePoints: Array<Int> = []
    private var observerIsNotifiedByNotifier: Bool = false
    
    private init() {
        
        print(dataFilePath!)
        
       
        for timePoint in TimeRange.allCases {
            self.observerNotifierTimePoints.append(timePoint.range.first!)
        }
    
        observerNotifier = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in self.checkUpdate() }
        scheduleNotification()
    }
    
    func scheduleNotification() {
        print("scheldued")
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = 0
        dateComponents.minute = 25
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    
    
    private func checkUpdate() {
        if let currentHour = self.time.hour, self.observerNotifierTimePoints.contains(currentHour), !observerIsNotifiedByNotifier { // notify observers once 
            
            self.notifyAllObservers()
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
    }
    
    public func addItem(newItem: Item) {
        
        self.currentUser.items.append(newItem)
        
        self.saveUser(self.currentUser)

    }
    
    public func getItems() -> Array<Item>? {
 
        return self.currentUser.items
    }
    
    
    
    
    public func updateItem(tag: Int) {
        
        let item = self.currentUser.items[tag]
        if !item.isPunchedIn {
            
            let currentYear: Int = Calendar.current.component(.year, from: Date())
            let currentMonth: Int = Calendar.current.component(.month, from: Date())
            let currentDay: Int = Calendar.current.component(.day, from: Date())
            item.punchIn(punchInDate: CustomDate(year: currentYear, month: currentMonth, day: currentDay))
            Vibrator.vibrate(withNotificationType: .success)
        } else {
            self.currentUser.items[tag].revokePunchIn()
            Vibrator.vibrate(withImpactLevel: .light)
        }
        
        self.saveUser(self.currentUser)
       
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
    public func registerObserver(observer: Observer) {
        self.observers.append(observer)
    }
    
    public func notifyAllObservers() {
        print("All Observer nofified")
        for observer in self.observers {
            observer.updateUI()
        }
    }
    // ------------------------------------ observer end ------------------------------------------------------
    
    
    public func showCenterPopUp(from forPresented: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popUpType = PopUpType.customTargetDays
        
        if let popUpViewController = storyboard.instantiateViewController(withIdentifier: "PopUpViewController") as? PopUpViewController {

            let popUpWindow = PopUpViewBuilder(popUpType: popUpType, popUpViewController: popUpViewController).buildView()
            popUpViewController.type = popUpType
            popUpViewController.view.addSubview(popUpWindow)
            forPresented.presentBottom(to: popUpViewController)
        }
    }

    public func showBottomPopUp(_ popUpType: PopUpType, dataStartIndex: Int = 0, from forPresented: UIViewController) {
        
        self.delegate = forPresented as? PopUpViewDelegate
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let popUpViewController = storyboard.instantiateViewController(withIdentifier: "PopUpViewController") as? PopUpViewController {

            let popUpWindow = PopUpViewBuilder(popUpType: popUpType, dataStartIndex: dataStartIndex, popUpViewController: popUpViewController).buildView()
            popUpViewController.type = popUpType
            popUpViewController.view.addSubview(popUpWindow)
            forPresented.presentBottom(to: popUpViewController)
        }
        
    }
 
    public func dismissBottomPopUpWithoutSave(controller: PopUpViewController) {
        self.delegate?.didDismissPopUpViewWithoutSave()
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    public func dismissBottomPopUpAndSave(controller: PopUpViewController) {
        
        self.storedDataFromPopUpView = controller.getStoredData()
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.didSaveAndDismissPopUpView(type: controller.type!)
        
    }
    
    
    
    public func getStoredDataFromPopUpView() -> Any {
        return self.storedDataFromPopUpView ?? "No Stored Data"
    }
    
    
    
  
    
}


