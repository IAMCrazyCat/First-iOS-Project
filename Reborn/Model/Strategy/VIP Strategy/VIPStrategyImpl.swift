//
//  AddNewItemStrategy.swift
//  Reborn
//
//  Created by Christian Liu on 5/3/21.
//

import Foundation
class VIPStrategyImpl: VIPStrategy {
    final func performStrategy() {
        if AppEngine.shared.currentUser.isVip {
            performVIPStrategy()
        } else {
            performNonVIPStrategy()
        }
    }

    internal func performVIPStrategy() {
        print("Performing VIP Strategy")
    }
    
    internal func performNonVIPStrategy() {
        print("Performing NonVIP Strategy")
    }
    
    
}
