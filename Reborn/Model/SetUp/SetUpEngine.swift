//
//  SetUpEngine.swift
//  Reborn
//
//  Created by Christian Liu on 20/12/20.
//

import Foundation
import UIKit
struct SetUpEngine {
    var progress = 1
    var engine = AppEngine()
    let pages = [
        SetUpPage(question: "请选择一项您现在最想戒除的瘾", buttons: ["性瘾", "拖延", "吸烟", "熬夜", "喝酒", "蹦迪", "游戏", "赖床", "手机", "奶茶", "自定义", "暂时没有瘾"]),
        SetUpPage(question: "您想戒多久", buttons: ["1个月", "2个月", "3个月", "半年", "1年", "2年"]),
        SetUpPage(question: "请选择一项您现在最想坚持的事情", buttons: ["跑步", "学英语", "瑜伽", "阅读", "减肥", "健身", "冥想", "自定义"]),
        SetUpPage(question: "您想坚持多久", buttons: ["1个月", "2个月", "3个月", "半年", "1年", "2年"]),
        SetUpPage(question: "您的性别？", buttons: ["男生", "女生", "其他"])
    ]
    
    var quittingItemName: String = ""
    var quittingItemDays: Int = 0
    var persistingItemName: String = ""
    var persistingItemDays: Int = 0
    var userGender: String = ""
    
    mutating func nextPage() {
        if progress < pages.count {
            progress += 1
        }
    }
    
    mutating func previousPage() {
        if progress > 1 {
            progress -= 1
        }
    }
    
    mutating func getCurrentPage() -> SetUpPage {
        return pages[progress - 1]
    }
    
    func getPagesCount() -> Int {
        return pages.count
    }
    
    func decideDurations(title: String) -> Int {
        
        var quittingItemDays: Int
        
        switch title {
        case "1个月":
            quittingItemDays = 30
        case "2个月":
            quittingItemDays = 60
        case "3个月":
            quittingItemDays = 90
        case "半年":
            quittingItemDays = 180
        case "1年":
            quittingItemDays = 365
        case "2年":
            quittingItemDays = 730
        default:
            print("Swicthing button.currentTitle! Error")
            quittingItemDays = 0
        }
        
        return quittingItemDays
    }
    
    mutating func processSlectedData(buttonTitle: String) { // execute once next button clicked
   
        
        switch progress {
        case 1:
            quittingItemName = buttonTitle
        case 2:
            quittingItemDays = self.decideDurations(title: buttonTitle)
        case 3:
            persistingItemName = buttonTitle
        case 4:
            persistingItemDays = self.decideDurations(title: buttonTitle)
        case 5:
            userGender = buttonTitle
        default:
            print("Switching progress Error")
        }
        
    }
    
    func saveData() {
        self.engine.saveItem(newItem: QuittingItem(name: quittingItemName, days: quittingItemDays, finishedDays: 0, creationDate: Date()))
        self.engine.saveItem(newItem: PersistingItem(name: persistingItemName, days: persistingItemDays, finishedDays: 0, creationDate: Date()))
    }
    
}
