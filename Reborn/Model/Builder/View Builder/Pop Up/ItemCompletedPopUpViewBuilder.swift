//
//  ItemCompletedPopUpViewBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 7/3/21.
//

import Foundation
import UIKit

class ItemCompletedPopUpViewBuilder: PopUpViewBuilder {
    
    private var item: Item
    init(popUpViewController: PopUpViewController, frame: CGRect, item: Item) {
        self.item = item
        super.init(popUpViewController: popUpViewController, frame: frame)
    }
    
    override func buildView() -> UIView {
        _ = super.buildView()
        self.addItemCard()
        self.excuteConfettiAnimation()
        self.setUpUI()
        self.showTitle()
        return super.outPutView
    }
    
    func setUpUI() {
        super.titleLabel.text = "你成功了！"
    }
    
    func addItemCard() {
        let itemCardView = ItemCardViewBuilder(item: item, frame: CGRect(x: 0, y: super.contentView.frame.height / 2 - SystemSetting.shared.itemCardHeight / 2, width: super.contentView.frame.width, height: SystemSetting.shared.itemCardHeight), isInteractable: false).buildView()
        itemCardView.accessibilityIdentifier = "ItemCardView"
        super.contentView.addSubview(itemCardView)
        
    }
    
    func excuteConfettiAnimation() {
        
    }
    
    func showTitle() {
        
        UIView.animate(withDuration: 10, delay: 0, animations: {
            
            self.titleLabel.alpha = 0
        })
    }
    
}
