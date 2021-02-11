//
//  Gender.swift
//  Reborn
//
//  Created by Christian Liu on 9/1/21.
//

import Foundation
import UIKit

enum Gender: String, Codable {
    case male = "男生"
    case female = "女生"
    case other = "保密"
    case undefined = "未填写"
}
