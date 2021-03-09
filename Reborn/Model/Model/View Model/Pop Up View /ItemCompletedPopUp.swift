//
//  ItemCompletedPopUp.swift
//  Reborn
//
//  Created by Christian Liu on 8/3/21.
//

import Foundation
import UIKit
class ItemCompletedPopUp: PopUpImpl {
    public var item: Item
    public var itemCard: UIView? {
        return super.contentView?.getSubviewBy(idenifier: "ItemCardView")
    }
    public var topConfettiView: UIView? {
        return self.itemCard?.getSubviewBy(idenifier: "TopConfettiView")
    }
    
    
   
    init(item: Item, presentAnimationType: PopUpAnimationType, popUpViewController: PopUpViewController) {
        self.item = item
        super.init(presentAnimationType: presentAnimationType, popUpViewController: popUpViewController, type: .itemCompletedPopUp)
        setUpUI()
    }
    
    func setUpUI() {
        topConfettiView?.alpha = 0
        super.titleLabel?.alpha = 0
    }
    
    override func excuteAnimation() {
        
        super.window.addConfettiAnimationView()
        
       
        
        UIView.animate(withDuration: 5, delay: 0, animations: {
            super.titleLabel?.alpha = 1
        })
    }
    
    
    
    override func createWindow() -> UIView {
        
        return ItemCompletedPopUpViewBuilder(popUpViewController: super.popUpViewController, frame: super.frame, item: self.item).buildView()
    }
    
    override func getStoredData() -> Any {
        return ""
    }
    
    override func updateUI() {
        
    }
}
