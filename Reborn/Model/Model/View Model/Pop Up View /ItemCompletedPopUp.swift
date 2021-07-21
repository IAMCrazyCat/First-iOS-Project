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
    public var itemCardView: ItemCardView? {
        return super.contentView?.getSubviewBy(idenifier: "ItemCardView") as? ItemCardView
    }
    public var topConfettiView: UIView? {
        return self.itemCardView?.contentView.getSubviewBy(idenifier: "TopConfettiView")
    }
    public var promptLabel: UILabel? {
        return super.contentView?.getSubviewBy(idenifier: "PromptLabel") as? UILabel
    }
    
    
    
   
    init(item: Item, presentAnimationType: PopUpAnimationType, size: PopUpSize = .small, popUpViewController: PopUpViewController) {
        self.item = item
        super.init(presentAnimationType: presentAnimationType, type: .itemCompletedPopUp, size: size, popUpViewController: popUpViewController)
    }
    
    override func setUpUI() {
        
        self.topConfettiView?.alpha = 0
        self.promptLabel?.alpha = 0
        super.titleLabel?.alpha = 0
        super.doneButton?.alpha = 0
        super.doneButton?.isHidden = true
        super.doneButton?.setTitle("知道了", for: .normal)
        super.contentView?.layer.zPosition = -1
    }
    
    override func excuteAnimation() {
    
        super.window.showConfettiAnimationAtBack()
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
