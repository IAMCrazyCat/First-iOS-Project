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
    public var promptLabel: UILabel? {
        return super.contentView?.getSubviewBy(idenifier: "PromptLabel") as? UILabel
    }
    
    
    
   
    init(item: Item, presentAnimationType: PopUpAnimationType, popUpViewController: PopUpViewController) {
        self.item = item
        super.init(presentAnimationType: presentAnimationType, popUpViewController: popUpViewController, type: .itemCompletedPopUp)
        setUpUI()
    }
    
    func setUpUI() {
        
        self.topConfettiView?.alpha = 0
        self.promptLabel?.alpha = 0
        super.titleLabel?.alpha = 0
        super.doneButton?.alpha = 0
        super.doneButton?.isHidden = true
        super.doneButton?.setTitle("知道了", for: .normal)
        super.contentView?.layer.zPosition = -1
    }
    
    override func excuteAnimation() {
    
        super.window.addConfettiAnimationView()
        super.doneButton?.isHidden = false
        UIView.animate(withDuration: 1, delay: 2, animations: {
            self.promptLabel?.alpha = 1
            self.topConfettiView?.alpha = 1
            super.doneButton?.alpha = 1
            super.titleLabel?.alpha = 1
        }) { _ in

        }
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
