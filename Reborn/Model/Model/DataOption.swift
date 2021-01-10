//
//  TargetDay.swift
//  Reborn
//
//  Created by Christian Liu on 3/1/21.
//

import Foundation
struct DataOption: Codable {
    var data: Int?
    var title: String
    
    init(data: Int) {
        self.data = data
        self.title = String("\(data)天")
    }
    
    init(title: String) {
        self.data = nil
        self.title = title
    }
    
    init(title: String, data: Int) {
        self.data = data
        self.title = title
    }
}
