//
//  Array.swift
//  Reborn
//
//  Created by Christian Liu on 3/2/21.
//

import Foundation

extension Array {
    var second: Element? {
        if self.count >= 2 {
            return self[1]
        } else {
            return nil
        }
        
    }
    
    var random: Element? {
        let randomIndex = Int.random(in: 0 ... self.count - 1)
        return self[randomIndex]
    }
}
