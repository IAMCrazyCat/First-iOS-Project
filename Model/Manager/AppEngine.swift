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
    
    public var currentTimeRange: TimeRange {
        let time = calendar.dateComponents([.hour,.minute,.second], from: Date())
        
        for timeRange in TimeRange.allCases {

            if timeRange.range.contains(time.hour!) {
                
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
    
    private let calendar = Calendar.current
    private var delegate: PopUpViewDelegate?
    private var observers: Array<Observer> = []

    private init() {
        
        //loadItems()
        print(dataFilePath!)

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
    
    
    
    
    public func punchInItem(tag: Int) {
        
        let currentYear: Int = Calendar.current.component(.year, from: Date())
        let currentMonth: Int = Calendar.current.component(.month, from: Date())
        let currentDay: Int = Calendar.current.component(.day, from: Date())
        self.currentUser.items[tag].punchIn(punchInDate: CustomDate(year: currentYear, month: currentMonth, day: currentDay))
        
        self.saveUser(self.currentUser)

    }
    
    public func getFinishedDays(tag: Int) -> Int? {
        return self.currentUser.items[tag].finishedDays
    }
    
    public func getDays(tag: Int) -> Int? {
        return self.currentUser.items[tag].targetDays
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
    
    // ------------------------------------ observer ------------------------------------------------------
    public func registerObserver(observer: Observer) {
        self.observers.append(observer)
    }
    
    public func notigyAllObservers() {
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
        delegate?.didDismissPopUpViewWithoutSave()
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    public func dismissBottomPopUpAndSave(controller: PopUpViewController) {
        
        self.storedDataFromPopUpView = controller.getStoredData()
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.didSaveAndDismissPopUpView(type: controller.type!)
        
    }
    
    
    func getStoredDataFromPopUpView() -> Any {
        return self.storedDataFromPopUpView ?? "No Stored Data"
    }
    
    
    
  
    
}


