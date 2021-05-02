//
//  SetUpPageData.swift
//  Reborn
//
//  Created by Christian Liu on 3/1/21.
//

import Foundation
struct SetUpPageData {

    static let data = [
        SetUpPage(ID: 1,question: "请选择一项您想戒除的习惯", buttons:
                    [CustomData(title: "拖延"), CustomData(title: "性瘾"),
                     CustomData(title: "吸烟"), CustomData(title: "熬夜"),
                     CustomData(title: "喝酒"), CustomData(title: "蹦迪"),
                     CustomData(title: "游戏"), CustomData(title: "赖床"),
                     CustomData(title: "糖"), CustomData(title: "奶茶"),
                     CustomData(title: SystemSetting.shared.customButtonTitle)
                     , CustomData(title: SystemSetting.shared.skipButtonTitle)
                    ]),
        
        SetUpPage(ID: 2, question: "您想戒多久", buttons:
                    [CustomData(data: 7) , CustomData(data: 30),
                     CustomData(data: 60), CustomData(data: 100),
                     CustomData(data: 365), CustomData(title:  SystemSetting.shared.customButtonTitle)
                    ]),
        
        SetUpPage(ID: 3, question: "请选择一项您想坚持的习惯",buttons:
                    [CustomData(title: "跑步"), CustomData(title: "学英语"),
                     CustomData(title: "瑜伽"), CustomData(title: "阅读"),
                     CustomData(title: "减肥"), CustomData(title: "健身"),
                     CustomData(title: "冥想"), CustomData(title: "吃早餐"),
                     CustomData(title: "存钱"), CustomData(title: "每日自省"),
                     CustomData(title: SystemSetting.shared.customButtonTitle)
                     , CustomData(title: SystemSetting.shared.skipButtonTitle)
                     ]),
        
        SetUpPage(ID: 4, question: "您想坚持多久", buttons:
                    [CustomData(data: 7), CustomData(data: 30),
                      CustomData(data: 60), CustomData(data: 100),
                      CustomData(data: 365),
                      CustomData(title: SystemSetting.shared.customButtonTitle)
                      ]),
        SetUpPage(ID: 5, question: "请设置您的名称", buttons: []),
        SetUpPage(ID: 6, question: "请设置您的性别", buttons: [CustomData(title: "男生"),
                                                         CustomData(title: "女生"),
                                                         CustomData(title: "其他"),
                                                         CustomData(title: "保密")
        ])
    ]
}
