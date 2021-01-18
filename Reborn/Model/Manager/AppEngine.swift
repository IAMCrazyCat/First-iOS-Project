//
//  AppEngine.swift
//  Reborn
//
//  Created by Christian Liu on 19/12/20.
//

import Foundation
import UIKit
protocol AppEngineDelegate {
    func willDismissView()
    func didDismissView()
    func didSaveAndDismissPopUpView(type: PopUpType)
}


class AppEngine {
    
    static let shared = AppEngine()
    var user: User?
    var defaults: UserDefaults = UserDefaults.standard
    let dataFilePath: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("item.plist")
    let setting: SystemStyleSetting = SystemStyleSetting()
    var overAllProgress: Double = 0.0
    var delegate: AppEngineDelegate?
    var storedDataFromPopUpView: Any? = nil
    var itemCardOnTransitionBetweenHomeViewAndAddItemCardView: UIView? = nil
    var itemOnTransitionBetweenHomeViewAndAddItemCardView: Item? = nil
    
    var currentDate: CustomDate {
        let date = Date()
        let currentYear: Int = Calendar.current.component(.year, from: date)
        let currentMonth: Int = Calendar.current.component(.month, from: date)
        let currentDay: Int = Calendar.current.component(.day, from: date)
        return CustomDate(year: currentYear, month: currentMonth, day: currentDay)
    }

    private init() {
        
        //loadItems()
        print(dataFilePath!)

    }
    
    public func saveUser(newUser user: User?) {

        if user != nil {
            let encoder = JSONEncoder()//PropertyListEncoder()

            do {
                let data = try encoder.encode(user!)
                try data.write(to: self.dataFilePath!)
            } catch {
                print("Error encoding item array, \(error)")
            }
        } else {
            let encoder = JSONEncoder()//PropertyListEncoder()

            do {
                let data = try encoder.encode(self.user!)
                try data.write(to: self.dataFilePath!)
                print("User saved")
            } catch {
                print("Error encoding item array, \(error)")
            }
        }
       
    }
    
    
    public func loadUser() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
           let decoder = JSONDecoder() //PropertyListDecoder()

           do {
                self.user = try decoder.decode(User.self, from: data) // .self 可以提取数据类型
           } catch {
               print(error)
           }
        }
    }
    
    public func addItem(newItem: Item) {
        
        self.user?.items.append(newItem)
        
        //self.saveUser(newUser: nil)

    }
    
    public func getItems() -> Array<Item>? {
 
        return self.user?.items
    }
    
    
    
    
    public func punchInItem(tag: Int) {
        
        let currentYear: Int = Calendar.current.component(.year, from: Date())
        let currentMonth: Int = Calendar.current.component(.month, from: Date())
        let currentDay: Int = Calendar.current.component(.day, from: Date())
        self.user!.items[tag].punchIn(punchInDate: CustomDate(year: currentYear, month: currentMonth, day: currentDay))
        
        //self.saveUser(newUser: nil)
        // test
//        let currentYear: Int = Calendar.current.component(.year, from: Date())
//        let currentMonth: Int = Calendar.current.component(.month, from: Date())
//        let currentDay: Int = Calendar.current.component(.day, from: Date())
//
//        for i in 1 ... 100 {
//            for j in 1 ... 12 {
//                for k in 1 ... 31 {
//                    self.user?.items[tag].punchIn(punchInDate: CustomDate(year: currentYear, month: j, day: k))
//                }
//            }
//
//        }
        
        

    }
    
    public func getFinishedDays(tag: Int) -> Int? {
        return self.user?.items[tag].finishedDays
    }
    
    public func getDays(tag: Int) -> Int? {
        return self.user?.items[tag].days
    }
    
    public func getOverAllProgress() -> Double? {
        
        self.overAllProgress = 0.0
        
        if user != nil {
            for item in self.user!.items {
               
                if item.days != 0 {
                    let itemProgress = Double(item.finishedDays) / Double(item.days)
        
                    self.overAllProgress += itemProgress
                }

            }
            
            if self.user!.items.count != 0 {
                self.overAllProgress /= Double(self.user!.items.count)
            }
            
            
            return self.overAllProgress
        }
        
        return nil
       
    }
    

    public func showPopUp(popUpType: PopUpType, controller: UIViewController) {
        self.delegate = controller as? AppEngineDelegate
        
        
        if let popUpViewController = PopUpViewBuilder(popUpType: popUpType).buildPopUpView() {
            controller.presentBottom(popUpViewController: popUpViewController)
        }
        
        
    }
    
 
    
    public func dismissPopUp(controller: PopUpViewController) {
        //delegate?.didDismissView()
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    public func saveAndDismissPopUp(controller: PopUpViewController) {
        
        self.storedDataFromPopUpView = controller.getStoredData()
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.didSaveAndDismissPopUpView(type: controller.type!)
        
    }
    
    public func showAddItemView(controller: HomeViewController) {
        self.delegate = controller
        controller.performSegue(withIdentifier: "goToAddItemView", sender: controller)
    }
    
    public func dismissAddItemView(controller: AddItemViewController) {
        self.itemCardOnTransitionBetweenHomeViewAndAddItemCardView = controller.preViewItemCard
        self.itemOnTransitionBetweenHomeViewAndAddItemCardView = controller.item
        self.delegate?.willDismissView()
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.didDismissView()
    }
    
    func getStoredDataFromPopUpView() -> Any {
        return self.storedDataFromPopUpView ?? "No Stored Data"
    }
    
    
    
    
    
  
    
}


