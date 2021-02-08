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
    var currentUser: User = User(name: "颠猫", gender: .undefined, avatar: #imageLiteral(resourceName: "AvatarMale"), keys: 3, items: [Item](), vip: false)
    var defaults: UserDefaults = UserDefaults.standard
    let dataFilePath: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("item.plist")
    let setting: SystemStyleSetting = SystemStyleSetting()
    var overAllProgress: Double = 0.0
    var storedDataFromPopUpView: Any? = nil
    var itemCardFromController: UIView? = nil
    var itemFromController: Item? = nil
    
    var delegate: AppEngineDelegate?
    var currentViewController: UIViewController? = nil
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
    

    public func showPopUp(_ popUpType: PopUpType, from forPresented: UIViewController) {
        
        self.delegate = forPresented as? AppEngineDelegate
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let popUpViewController = storyboard.instantiateViewController(withIdentifier: "PopUpViewController") as? PopUpViewController {
            let popUpWindow = PopUpViewBuilder(popUpType: popUpType, popUpViewController: popUpViewController).buildPopUpView()
            popUpViewController.type = popUpType
            popUpViewController.view.addSubview(popUpWindow)
            forPresented.presentBottom(to: popUpViewController)
        }
        

        
        
    }
    
 
    
    public func dismissPopUpWithoutSave(controller: PopUpViewController) {
        //delegate?.didDismissView()
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    public func dismissAndSavePopUp(controller: PopUpViewController) {
        
        self.storedDataFromPopUpView = controller.getStoredData()
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.didSaveAndDismissPopUpView(type: controller.type!)
        
    }
    
    public func showNewItemView(controller: HomeViewController) {
        self.delegate = controller
        controller.performSegue(withIdentifier: "goToNewItemView", sender: controller)
    }
    
    public func dismissNewItemViewWithoutSave(viewController: NewItemViewController) {
        
        viewController.dismiss(animated: true, completion: nil)
    }
    
    public func dismissNewItemViewAndSaveItem(viewController: NewItemViewController) {
        viewController.dismiss(animated: true, completion: nil)
        self.saveUser(self.currentUser)
    }
    
    public func dismissNewItemViewAndAddItem(viewController: NewItemViewController) {
        self.itemCardFromController = viewController.preViewItemCard
        self.itemFromController = viewController.item
        
        if self.itemFromController != nil {
            self.addItem(newItem: itemFromController!)
        }
        
        //self.delegate = 
        self.delegate?.willDismissView()
        viewController.dismiss(animated: true, completion: nil)

        self.delegate?.didDismissView()
    }
    
    func getStoredDataFromPopUpView() -> Any {
        return self.storedDataFromPopUpView ?? "No Stored Data"
    }
    
    
    
  
    
}


