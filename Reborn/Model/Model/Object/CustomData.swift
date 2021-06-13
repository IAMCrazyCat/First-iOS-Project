//
//  TargetDay.swift
//  Reborn
//
//  Created by Christian Liu on 3/1/21.
//

import Foundation
struct CustomData: Codable {
    var title: String
    var body: String? = nil
    var data: Int? = nil
    var status: Bool? = nil
    
    init(data: Int) {
        self.data = data
        self.title = String("\(data)天")
    }
    
    init(title: String) {
        self.title = title
    }
    
    init(title: String, data: Int?) {
        self.data = data
        self.title = title
    }
    
    init(title: String, body: String) {
        self.title = title
        self.body = body
    }
    
    init(title: String, status: Bool) {
        self.title = title
        self.status = status
    }
    
    init(title: String, body: String?, data: Int?, status: Bool?) {
        self.title = title
        self.body = body
        self.data = data
        self.status = status
    }
    
    
}
