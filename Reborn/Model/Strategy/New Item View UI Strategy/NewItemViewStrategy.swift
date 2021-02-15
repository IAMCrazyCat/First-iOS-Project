//
//  NewItemViewStrategy.swift
//  Reborn
//
//  Created by Christian Liu on 7/2/21.
//

import Foundation
import UIKit

protocol NewItemViewStrategy {
    
    func initializeUI()
    func isRedyToDismiss() -> Bool
    func showPopUp(popUpType: PopUpType)
    func doneButtonPressed(_ sender: UIButton)
}
