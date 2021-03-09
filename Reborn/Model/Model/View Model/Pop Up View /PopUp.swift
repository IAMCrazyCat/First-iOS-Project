//
//  PopUpView.swift
//  Reborn
//
//  Created by Christian Liu on 8/3/21.
//

import Foundation
import UIKit

protocol PopUp {
    func isReadyToDismiss() -> Bool
    func getStoredData() -> Any?
    func updateUI()
}
