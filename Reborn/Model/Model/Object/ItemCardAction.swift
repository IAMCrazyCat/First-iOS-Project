//
//  ItemCardAction.swift
//  Reborn
//
//  Created by Christian Liu on 17/2/21.
//

import Foundation
import UIKit

class ItemCardAction {
    
    static var shared: ItemCardAction = ItemCardAction()
    
    private init() {
       
    }
    
    var punchInAction: Selector = #selector(ItemCardAction.shared.itemPunchInButtonPressed)
    var detailsViewAction: Selector = #selector(ItemCardAction.shared.itemDetailsButtonPressed(_:))
    
    @objc func itemPunchInButtonPressed(_ sender: UIButton!) {
        AppEngine.shared.updateItem(tag: sender.tag)
        AppEngine.shared.notifyAllObservers()
    }
    
    @objc func itemDetailsButtonPressed(_ sender: UIButton!) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let senderViewController = sender.findViewController(),
              let navigationController = senderViewController.navigationController,
              let itemDetailViewController = storyBoard.instantiateViewController(withIdentifier: "ItemDetailView") as? ItemDetailViewController
        else {
            return
        }
        
        itemDetailViewController.item = AppEngine.shared.currentUser.items[sender.tag]
        navigationController.pushViewController(itemDetailViewController, animated: true)

    }
}
