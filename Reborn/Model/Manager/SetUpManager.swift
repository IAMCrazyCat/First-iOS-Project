//
//  SetUpEngine.swift
//  Reborn
//
//  Created by Christian Liu on 20/12/20.
//

import Foundation
import UIKit
class SetUpManager {
    var progress = 1
    let pages = SetUpPageData.data
    var quittingItemName: String = ""
    var quittingItemDays: Int = 0
    var persistingItemName: String = ""
    var persistingItemDays: Int = 0
    var userName: String = ""
    var userGender: Gender = .undefined
    
    var quittingItemIsSkipped = false
    var persistingItemIsSkipped = false
    func nextPage() {
        if progress < pages.count {
            progress += 1
        }
    }
    
    func previousPage() {
        if progress > 1 {
            progress -= 1
        }
    }
    
    func getCurrentPage() -> SetUpPage {
        return pages[progress - 1]
    }
    
    func getPagesCount() -> Int {
        return pages.count
    }
    
    
    
    func save(data: Any) { // execute once next button clicked
        
        var data = data as! String
        
        switch progress {
        case 1:
            quittingItemName = data
        case 2:
            data.removeLast()
            quittingItemDays = Int(data) ?? 0
        case 3:
            persistingItemName = data
        case 4:
            
            data.removeLast()
            persistingItemDays = Int(data) ?? 0
        case 5:
            userName = data
        case 6:
            
            for gender in Gender.allCases {
                if data == gender.name {
                    userGender = gender
                }
            }
            print(userGender)
            
        default:
            print("Switching progress Error")
        }
        
    }
    

    
    func createUser(setUpIsSkipped: Bool) {

        var newUser = User(ID: SystemSetting.shared.defaultUserID, name: SystemSetting.shared.defaultUserName, gender: SystemSetting.shared.defaultUserGender, avatar: SystemSetting.shared.defaultUserAvatar, energy: SystemSetting.shared.defaultUserEnergy, items: SystemSetting.shared.defaultUserItems, creationDate: SystemSetting.shared.defaultCreationDate)
        
        if !setUpIsSkipped {

            newUser.name = userName
            newUser.gender = userGender
            if !persistingItemIsSkipped {
                let item = Item(ID: 1, name: persistingItemName, days: persistingItemDays, frequency: EveryDay(), creationDate: CustomDate.current, type: .persisting, icon: Icon.defaultIcon1, notificationTimes: [CustomTime]())
                newUser.items.append(item)
            }
            
            if !quittingItemIsSkipped {
                let item = Item(ID: 2, name: quittingItemName, days: quittingItemDays, frequency: EveryDay(), creationDate: CustomDate.current, type: .quitting, icon: Icon.defaultIcon2, notificationTimes: [CustomTime]())
                newUser.items.append(item)
            }
            newUser.energy = 1
            
            switch newUser.gender {
            case .male: newUser.setAvatarImage(#imageLiteral(resourceName: "DefaultAvatarMale"))
            case .female: newUser.setAvatarImage(#imageLiteral(resourceName: "DefaultAvatar"))
            default: newUser.setAvatarImage(#imageLiteral(resourceName: "DefaultAvatar"))
            }
            
        } else {
            newUser = User(ID: SystemSetting.shared.defaultUserID, name: SystemSetting.shared.defaultUserName, gender: SystemSetting.shared.defaultUserGender, avatar: SystemSetting.shared.defaultUserAvatar, energy: SystemSetting.shared.defaultUserEnergy, items: SystemSetting.shared.defaultUserItems, creationDate: SystemSetting.shared.defaultCreationDate)
        }

        AppEngine.shared.currentUser = newUser
        AppEngine.shared.saveUser()
    }
    
    
    func showPopUp(popUpType popUp: PopUpType, controller: UIViewController) {
  
        controller.present(popUp)
    }
    
    func getStoredDataFromPopUpView() -> Any {
        
        return AppEngine.shared.storedDataFromPopUpView ?? "Error"
    }
    
   
    
}
