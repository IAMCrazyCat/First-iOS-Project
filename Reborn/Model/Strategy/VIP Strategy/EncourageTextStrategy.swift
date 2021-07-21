//
//  EncourageTextStrategy.swift
//  Reborn
//
//  Created by Christian Liu on 6/7/21.
//

import Foundation
import UIKit
class EncourageTextStrategy: VIPStrategyImpl {
    let encourageTextViewController: EncourageTextViewController
    init(encourageTextViewController: EncourageTextViewController) {
        self.encourageTextViewController = encourageTextViewController
    }
    
    override func performVIPStrategy() {
        encourageTextViewController.state = encourageTextViewController.state == .normal ? .editing : .normal
        encourageTextViewController.updateUI()
        UIManager.shared.updateUIAfterEncourageTextWasEdited()
    }
    
    override func performNonVIPStrategy() {
        UIApplication.shared.getCurrentViewController()?.presentViewController(withIentifier: "PurchaseViewController")
    }
}
