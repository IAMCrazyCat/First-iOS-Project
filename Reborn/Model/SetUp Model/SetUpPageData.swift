//
//  SetUpPageData.swift
//  Reborn
//
//  Created by Christian Liu on 3/1/21.
//

import Foundation
struct SetUpPageData {

    static let data = [
        SetUpPage(ID: 1,question: "请选择一项您现在最想戒除的瘾", buttons:
                    [DataOption(title: "性瘾"), DataOption(title: "拖延"),
                     DataOption(title: "吸烟"), DataOption(title: "熬夜"),
                     DataOption(title: "喝酒"), DataOption(title: "蹦迪"),
                     DataOption(title: "游戏"), DataOption(title: "赖床"),
                     DataOption(title: "手机"), DataOption(title: "奶茶"),
                     DataOption(title: SystemStyleSetting.shared.customButtonTitle)
                     , DataOption(title: SystemStyleSetting.shared.skipButtonTitle)
                    ]),
        
        SetUpPage(ID: 2, question: "您想戒多久", buttons:
                    [DataOption(data: 7) , DataOption(data: 30),
                     DataOption(data: 60), DataOption(data: 100),
                     DataOption(data: 365), DataOption(title:  SystemStyleSetting.shared.customButtonTitle)
                    ]),
        
        SetUpPage(ID: 3, question: "请选择一项您现在最想坚持的事情",buttons:
                    [DataOption(title: "跑步"), DataOption(title: "学英语"),
                     DataOption(title: "瑜伽"), DataOption(title: "阅读"),
                     DataOption(title: "减肥"), DataOption(title: "健身"),
                     DataOption(title: "冥想"), DataOption(title: "吃早餐"),
                     DataOption(title: "存钱"), DataOption(title: "每日自省"),
                     DataOption(title: SystemStyleSetting.shared.customButtonTitle)
                     , DataOption(title: SystemStyleSetting.shared.skipButtonTitle)
                     ]),
        
        SetUpPage(ID: 4, question: "您想坚持多久", buttons:
                    [DataOption(data: 7), DataOption(data: 30),
                      DataOption(data: 60), DataOption(data: 100),
                      DataOption(data: 365),
                      DataOption(title: SystemStyleSetting.shared.customButtonTitle)
                      ]),
        
        SetUpPage(ID: 5, question: "您的性别？", buttons: [DataOption(title: "男生"),
                                                         DataOption(title: "女生")
        ])
    ]
}
