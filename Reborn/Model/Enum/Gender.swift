//
//  Gender.swift
//  Reborn
//
//  Created by Christian Liu on 9/1/21.
//

import Foundation
import UIKit

enum Gender: String, Codable, CaseIterable {
    case male = "男生"
    case female = "女生"
    case secret = "保密"
    case undefined = "未填写"
    
    var name: String {
        switch self {
        case .male: return "男"
        case .female: return "女"
        case .secret: return "保密"
        case .undefined: return "其他"
        }
    }
}
