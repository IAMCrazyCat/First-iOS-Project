//
//  SetUpEngine.swift
//  Reborn
//
//  Created by Christian Liu on 20/12/20.
//

import Foundation
import UIKit
class SetUpEngine {
    var progress = 1
    let pages = SetUpPageData.data
    var quittingItemName: String = ""
    var quittingItemDays: Int = 0
    var persistingItemName: String = ""
    var persistingItemDays: Int = 0
    var userName: String = ""
    var userGender: Gender = .undefined
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

            if data == Gender.male.rawValue {
                userGender = .male
            } else if data == Gender.female.rawValue {
                userGender = .female
            } else {
                userGender = .other
            }
            
        default:
            print("Switching progress Error")
        }
        
    }
    

    
    func createUser(setUpIsSkipped: Bool) {

        let newUser = AppEngine.shared.currentUser
        
        if !setUpIsSkipped {
            newUser.name = userName
            newUser.gender = userGender
            newUser.items.append(QuittingItem(ID: 1, name: quittingItemName, days: quittingItemDays, frequency: .everyday, creationDate: AppEngine.shared.currentDate))
            newUser.items.append(PersistingItem(ID: 2, name: persistingItemName, days: persistingItemDays, frequency: .everyday, creationDate: AppEngine.shared.currentDate))
            

        }

        AppEngine.shared.currentUser = newUser
    }
    
    
    func showPopUp(popUpType popUp: PopUpType, controller: UIViewController) {
  
        controller.present(popUp)
    }
    
    func getStoredDataFromPopUpView() -> Any {
        
        return AppEngine.shared.storedDataFromPopUpView ?? "Error"
    }
    
   
    
}
