//
//  CustomTime.swift
//  Reborn
//
//  Created by Christian Liu on 14/3/21.
//

import Foundation
class CustomTime: NSObject, NSCoding {
    
    var hour: Int
    var minute: Int
    
    init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(hour, forKey: "Hour")
        coder.encode(minute, forKey: "Minute")
    }
    
    required convenience init?(coder: NSCoder) {
        let hour = coder.decodeInteger(forKey: "Hour")
        let minute = coder.decodeInteger(forKey: "Minute")
        self.init(hour: hour, minute: minute)
    }
    

   
    
   
}

