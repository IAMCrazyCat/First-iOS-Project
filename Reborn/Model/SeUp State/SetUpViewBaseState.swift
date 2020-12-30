//
//  BaseSetUpViewState.swift
//  Reborn
//
//  Created by Christian Liu on 30/12/20.
//

import Foundation
class SetUpViewBaseState: SetUpViewState {
    
    private(set) weak var context: SetUpViewController?
    
    func update(context: SetUpViewController) {
        self.context = context
    }
    
    func handle1() {}
    
    func handle2() {}
    
    
}
