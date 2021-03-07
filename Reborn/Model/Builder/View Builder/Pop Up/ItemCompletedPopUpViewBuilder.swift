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
        addItemCard()
        excuteConfettiAnimation()
        setUpUI()
        showTitle()
        return super.outPutView
    }
    
    func setUpUI() {
        super.titleLabel.text = "你成功了！"
        super.titleLabel.alpha = 0
    }
    
    func addItemCard() {
        let itemCardView = ItemCardViewBuilder(item: item, frame: CGRect(x: 0, y: super.contentView.frame.height / 2 - SystemSetting.shared.itemCardHeight / 2, width: super.contentView.frame.width, height: SystemSetting.shared.itemCardHeight), isInteractable: false).buildView()
        super.contentView.addSubview(itemCardView)
        
    }
    
    func excuteConfettiAnimation() {
        
    }
    
    func showTitle() {
       
    }
    
}
