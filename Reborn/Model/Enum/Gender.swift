//
//  Gender.swift
//  Reborn
//
//  Created by Christian Liu on 9/1/21.
//

import Foundation
import UIKit

enum Gender: String, Codable, CaseIterable {
    case male = "男"
    case female = "女"
    case secret = "保密"
    case undefined = "未填写"
}
