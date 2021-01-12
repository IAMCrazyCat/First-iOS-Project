//
//  Date.swift
//  Reborn
//
//  Created by Christian Liu on 12/1/21.
//

import Foundation

extension Date {
    
    var date: Date? {
        let components = Calendar.current.dateComponents([.month, .day], from: self)
        return Calendar.current.date(from: components)
    }
    
}
