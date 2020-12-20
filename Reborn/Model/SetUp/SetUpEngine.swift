//
//  SetUpEngine.swift
//  Reborn
//
//  Created by Christian Liu on 20/12/20.
//

import Foundation

struct SetUpEngine {
    var progress = 1
    let pages = [
        SetUpPage(question: "请选择一项您现在最想戒除的瘾", buttons: ["性瘾", "拖延", "吸烟", "熬夜", "喝酒", "蹦迪", "游戏", "赖床", "手机", "自定义", "暂时没有瘾"]),
        SetUpPage(question: "您想戒多久", buttons: ["1个月", "2个月", "3个月", "半年", "1年", "2年"]),
        SetUpPage(question: "请选择一项您现在最想坚持的事情", buttons: ["跑步", "学英语", "瑜伽", "阅读", "减肥", "健身"]),
        SetUpPage(question: "您想坚持多久", buttons: ["1个月", "2个月", "3个月", "半年", "1年", "2年"]),
        SetUpPage(question: "您的性别？", buttons: ["男生", "女生", "其他"]),
    ]
    
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
    
}
