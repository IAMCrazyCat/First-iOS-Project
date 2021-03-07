//
//  AddNewItemStrategy.swift
//  Reborn
//
//  Created by Christian Liu on 5/3/21.
//

import Foundation
class VIPStrategyImpl: VIPStrategy {
    func performStrategy() {
        if AppEngine.shared.currentUser.vip {
            performVIPStrategy()
        } else {
            performNonVIPStrategy()
        }
    }

    func performVIPStrategy() {
        print("Performing VIP Strategy")
    }
    
    func performNonVIPStrategy() {
        print("Performing NonVIP Strategy")
    }
    
    
}
