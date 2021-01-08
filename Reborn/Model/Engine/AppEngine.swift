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
    var itemArray: Array<Item> = []
    var defaults: UserDefaults = UserDefaults.standard
    var currentDate: Date = Date()
    let dataFilePath: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("item.plist")
    let setting: SystemStyleSetting = SystemStyleSetting()
    var overAllProgress: Double = 0.0
    var delegate: AppEngineDelegate?
    var storedDataFromPopUpView: Any? = nil
    var itemCardOnTransitionBetweenHomeViewAndAddItemCardView: UIView? = nil
    private init() {
        
        //loadItems()
        print(dataFilePath!)
    }
    
    public func addItem(newItem: Item) {
        
        self.itemArray.append(newItem)

    }
    
    public func saveItems() {
        let encoder = JSONEncoder()//PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
    }
    
    public func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = JSONDecoder() //PropertyListDecoder()
            
            do {
                self.itemArray = try decoder.decode([Item].self, from: data) // .self 可以提取数据类型
            } catch {
                print(error)
            }
        }
    
    }
    
    
    public func getItemArray() -> Array<Item> {
 
        return itemArray
    }
    
    public func loadItemCardsToHomeView(controller: HomeViewController) {
        
        var cordinateY: CGFloat = 0
        var tag: Int = itemArray.count - 1
        
    
        if itemArray.count > 0 {
            
            for itemIndex in (0...self.itemArray.count - 1).reversed() {
                
                let item = self.itemArray[itemIndex]
                let builder = ItemCardBuilder(item: item, width: controller.itemCardsView.frame.width, height: self.setting.itemCardHeight, corninateX: 0, cordinateY: cordinateY, punchInButtonTag: tag)
                
                controller.updateVerticalScrollView(newItemCard: builder.buildItemCardView(), updatedHeight: cordinateY)
                cordinateY += setting.itemCardHeight + setting.itemCardGap
                tag -= 1
                print(tag)
            }
            
        }
        
        print(itemArray)
    }
    
    
    public func punchInItem(tag: Int) {
        itemArray[tag].punchIn(punchInDate: currentDate)
        print(itemArray[tag].punchInDate)
    }
    
    public func getFinishedDays(tag: Int) -> Int {
        return itemArray[tag].finishedDays
    }
    
    public func getDays(tag: Int) -> Int {
        return itemArray[tag].days
    }
    
    public func getOverAllProgress() -> Double {
        
        self.overAllProgress = 0
        for item in itemArray {
            let itemProgress = Double(item.finishedDays) / Double(item.days)
            self.overAllProgress += itemProgress
        }
        
        self.overAllProgress /= Double(itemArray.count)
        return self.overAllProgress
    }
    
    public func generateNewItemCard(item: Item) -> UIView {
        
       
        
        let builder = ItemCardBuilder(item: item, width: self.setting.screenFrame.width - 2 * self.setting.mainDistance, height: self.setting.itemCardHeight, corninateX: 0, cordinateY: 0, punchInButtonTag: itemArray.count)
        print("itemArray \(itemArray.count)")
        return builder.buildItemCardView()
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
        itemCardOnTransitionBetweenHomeViewAndAddItemCardView = controller.preViewItemCard
        self.delegate?.willDismissView()
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.didDismissView()
    }
    
    func getStoredDataFromPopUpView() -> Any {
        return self.storedDataFromPopUpView ?? "No Stored Data"
    }
    
  
    
}


