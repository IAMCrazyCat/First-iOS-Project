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
    var currentDate: Date = Date()
    let dataFilePath: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("item.plist")
    let setting: SystemStyleSetting = SystemStyleSetting()
    var overAllProgress: Double = 0.0
    var delegate: AppEngineDelegate?
    var storedDataFromPopUpView: Any? = nil
    var itemCardOnTransitionBetweenHomeViewAndAddItemCardView: UIView? = nil
    var itemOnTransitionBetweenHomeViewAndAddItemCardView: Item? = nil

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
        self.saveUser(newUser: nil)

    }
    
    public func getItems() -> Array<Item>? {
 
        return self.user?.items
    }
    
    public func loadItemCardsToHomeView(controller: HomeViewController) {
        
        var persistingCordinateY: CGFloat = 0
        var quittingCordinateY: CGFloat = 0
        
        
        if let items = self.user?.items {
            var tag: Int = self.user!.items.count - 1
            if items.count > 0 {
                
                
                for itemIndex in (0...items.count - 1).reversed() {
                    
                    let item = items[itemIndex]
                    
                  
                    if item.type == .persisting {
                        
                        controller.persistingItemsViewPromptLabel.isHidden = true
                        let builder = ItemCardBuilder(item: item, width: controller.persistingItemsView.frame.width, height: self.setting.itemCardHeight, corninateX: 0, cordinateY: persistingCordinateY, punchInButtonTag: tag)
                        let newItemCard = builder.buildItemCardView()
                        
                        let heightConstraintIndex = controller.contentView.constraints.count - 1
                        let tabBarHeight: CGFloat = 200
                        controller.persistingItemsView.addSubview(newItemCard)
                        
                        let newConstraint = controller.itemsTitleLabel.frame.origin.y + tabBarHeight + persistingCordinateY
                        if newConstraint > controller.contentView.constraints[heightConstraintIndex].constant {
                            controller.contentView.constraints[heightConstraintIndex].constant = newConstraint // update height constraint (height is at the last index of constraints array)
                        }
                 
                        controller.persistingItemsView.layoutIfNeeded()
                        persistingCordinateY += setting.itemCardHeight + setting.itemCardGap
                        
                    } else if item.type == .quitting {
                        
                        controller.quittingItemsViewPromptLabel.isHidden = true
                        let builder = ItemCardBuilder(item: item, width: controller.quittingItemsView.frame.width, height: self.setting.itemCardHeight, corninateX: 0, cordinateY: quittingCordinateY, punchInButtonTag: tag)
                        let newItemCard = builder.buildItemCardView()
                        
                        let heightConstraintIndex = controller.contentView.constraints.count - 1
                        let tabBarHeight: CGFloat = 200
                        controller.quittingItemsView.addSubview(newItemCard)
                        
                        let newConstraint = controller.itemsTitleLabel.frame.origin.y + tabBarHeight + quittingCordinateY
                        if newConstraint > controller.contentView.constraints[heightConstraintIndex].constant {
                            controller.contentView.constraints[heightConstraintIndex].constant = newConstraint // update height constraint (height is at the last index of constraints array)
                        }
                 
                        controller.persistingItemsView.layoutIfNeeded()
                        quittingCordinateY += setting.itemCardHeight + setting.itemCardGap
                    }
                    
                    
                    
                    tag -= 1
          
                }
                
            } else {
                
                controller.persistingItemsViewPromptLabel.isHidden = false
                controller.quittingItemsViewPromptLabel.isHidden = false
            }
    
        
            
        }
        

    }
    
    
    public func punchInItem(tag: Int) {
        self.user?.items[tag].punchIn(punchInDate: currentDate)

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
    
    public func buildItemCard(item: Item) -> UIView? {
        
        if user != nil {
            
            let builder = ItemCardBuilder(item: item, width: self.setting.screenFrame.width - 2 * self.setting.mainPadding, height: self.setting.itemCardHeight, corninateX: 0, cordinateY: 0, punchInButtonTag: self.user!.items.count)

            return builder.buildItemCardView()
        }
        
        return nil
       
    }
    
    public func buildCalendar(itemID: Int) -> UIView? {
        //let builder = CalendarPageBuilder(item: self.user!.items[itemID])
       
        return nil //builder.builCalendar()
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


