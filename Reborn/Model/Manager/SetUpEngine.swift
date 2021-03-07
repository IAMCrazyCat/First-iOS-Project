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
    var userGender: Gender?
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
    
    
    
    func processSlectedData(pressedButton: UIButton) { // execute once next button clicked
        
        var buttonTitle = pressedButton.currentTitle ?? "Error"
        

        switch progress {
        case 1:
            quittingItemName = buttonTitle
        case 2:
         
            buttonTitle.removeLast()
            quittingItemDays = Int(buttonTitle) ?? 0
        case 3:
            persistingItemName = buttonTitle
        case 4:

            buttonTitle.removeLast()
            persistingItemDays = Int(buttonTitle) ?? 0
        case 5:
            
            if buttonTitle == Gender.male.rawValue {
                userGender = .male
            } else if buttonTitle == Gender.female.rawValue {
                userGender = .female
            } else {
                userGender = .other
            }
            
        default:
            print("Switching progress Error")
        }
        
    }
    

    
    func createUser(setUpIsSkipped: Bool) {

        let newUser = User(name: "没有名字", gender: userGender ?? .undefined, avatar: #imageLiteral(resourceName: "Test"), keys: 3, items: [Item](), vip: false)
        
        if !setUpIsSkipped {
            
            newUser.items.append(QuittingItem(ID: 1, name: quittingItemName, days: quittingItemDays, finishedDays: 0, frequency: .everyday, creationDate: AppEngine.shared.currentDate))
            newUser.items.append(PersistingItem(ID: 2, name: persistingItemName, days: persistingItemDays, finishedDays: 0, frequency: .everyday, creationDate: AppEngine.shared.currentDate))
        }

        AppEngine.shared.currentUser = newUser
    }
    
    
    func showPopUp(popUpType popUp: PopUpType, controller: UIViewController) {
  
        controller.show(popUp)
    }
    
    func getStoredDataFromPopUpView() -> Any {
        
        return AppEngine.shared.storedDataFromPopUpView ?? "Error"
    }
    
    func loadSetUpPages(controller: SetUpViewController) -> UIView {
        
        let layoutGuideView = controller.middleView!
        var pageNum = 0
        
        for page in pages {
            print(CGFloat(pageNum) * layoutGuideView.frame.width)
            let builder = SetUpPageViewBuilder(page: page, pageCordinateX: CGFloat(pageNum) * layoutGuideView.frame.width, layoutGuideView: layoutGuideView)
            controller.middleScrollView.addSubview(builder.buildSetUpPage())
            controller.middleScrollView.contentSize = CGSize(width: CGFloat(pages.count) * layoutGuideView.frame.width, height: layoutGuideView.frame.height) // set size
            pageNum += 1
            
        }
       
        return layoutGuideView
    }
    
}
