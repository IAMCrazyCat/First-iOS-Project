//
//  SetUpPageData.swift
//  Reborn
//
//  Created by Christian Liu on 3/1/21.
//

import Foundation
struct SetUpPageData {

    static let data = [
        SetUpPage(ID: 1,question: "请选择一项您现在最想戒除的习惯", buttons:
                    [DataModel(title: "拖延"), DataModel(title: "性瘾"),
                     DataModel(title: "吸烟"), DataModel(title: "熬夜"),
                     DataModel(title: "喝酒"), DataModel(title: "蹦迪"),
                     DataModel(title: "游戏"), DataModel(title: "赖床"),
                     DataModel(title: "糖"), DataModel(title: "奶茶"),
                     DataModel(title: SystemSetting.shared.customButtonTitle)
                     , DataModel(title: SystemSetting.shared.skipButtonTitle)
                    ]),
        
        SetUpPage(ID: 2, question: "您想戒多久", buttons:
                    [DataModel(data: 7) , DataModel(data: 30),
                     DataModel(data: 60), DataModel(data: 100),
                     DataModel(data: 365), DataModel(title:  SystemSetting.shared.customButtonTitle)
                    ]),
        
        SetUpPage(ID: 3, question: "请选择一项您现在最想坚持的习惯",buttons:
                    [DataModel(title: "跑步"), DataModel(title: "学英语"),
                     DataModel(title: "瑜伽"), DataModel(title: "阅读"),
                     DataModel(title: "减肥"), DataModel(title: "健身"),
                     DataModel(title: "冥想"), DataModel(title: "吃早餐"),
                     DataModel(title: "存钱"), DataModel(title: "每日自省"),
                     DataModel(title: SystemSetting.shared.customButtonTitle)
                     , DataModel(title: SystemSetting.shared.skipButtonTitle)
                     ]),
        
        SetUpPage(ID: 4, question: "您想坚持多久", buttons:
                    [DataModel(data: 7), DataModel(data: 30),
                      DataModel(data: 60), DataModel(data: 100),
                      DataModel(data: 365),
                      DataModel(title: SystemSetting.shared.customButtonTitle)
                      ]),
        SetUpPage(ID: 5, question: "请想一个好听的名称", buttons: []),
        SetUpPage(ID: 6, question: "您的性别？", buttons: [DataModel(title: "男生"),
                                                         DataModel(title: "女生")
        ])
    ]
}
