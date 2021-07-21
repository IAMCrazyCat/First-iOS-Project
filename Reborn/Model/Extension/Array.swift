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
    
    func reverseTraversal(condition: (() -> Bool), do execute: (() -> Void)?, stopCondition: (() -> Bool)?) {
        
        var index = self.count - 1
        while index >= 0 {
            if condition() {
                execute?()
            }
            
            if let stopCondition = stopCondition?() {
                if stopCondition {
                    break
                }
            }
            index -= 1
        }
    }
}
