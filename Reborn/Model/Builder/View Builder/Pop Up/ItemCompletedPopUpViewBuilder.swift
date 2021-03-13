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
    private var itemCardView: UIView = UIView()
    init(popUpViewController: PopUpViewController, frame: CGRect, item: Item) {
        self.item = item
        super.init(popUpViewController: popUpViewController, frame: frame)
    }
    
    override func buildView() -> UIView {
        _ = super.buildView()
        self.addItemCard()
        self.addPromptLabel()
        self.setUpUI()
        return super.outPutView
    }
    
    func setUpUI() {
        super.titleLabel.text = "目标达成！"
    }
    
    func addItemCard() {
        itemCardView = ItemCardViewBuilder(item: item, frame: CGRect(x: 0, y: super.contentView.frame.height / 2 - SystemSetting.shared.itemCardHeight / 2 - 40, width: super.contentView.frame.width, height: SystemSetting.shared.itemCardHeight), isInteractable: false).buildView()
        itemCardView.accessibilityIdentifier = "ItemCardView"
        super.contentView.addSubview(itemCardView)
        
    }
    
    func addPromptLabel() {
        let promptLabel = UILabel()
        promptLabel.accessibilityIdentifier = "PromptLabel"
        promptLabel.textColor = super.setting.grayColor
        promptLabel.text = "已完成的项目可以在 项目管理 中操作 "
        promptLabel.font = AppEngine.shared.userSetting.fontSmall.withSize(12)
        promptLabel.sizeToFit()
        super.contentView.addSubview(promptLabel)
        
        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        promptLabel.centerXAnchor.constraint(equalTo: super.contentView.centerXAnchor).isActive = true
        promptLabel.topAnchor.constraint(equalTo: self.itemCardView.bottomAnchor, constant: 20).isActive = true
    }
    
    
}
