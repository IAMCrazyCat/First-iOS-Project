//
//  IconCell.swift
//  Reborn
//
//  Created by Christian Liu on 28/4/21.
//

import Foundation
import UIKit

class IconCell: UICollectionViewCell {
    static var identifier: String = "IconCell"
    public let iconButton: UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
        //self.contentView.addSubview(iconButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setUpUI()
    }
    
    func setUpUI() {
        contentView.removeAllSubviews()
        contentView.layoutIfNeeded()
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 5
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.clear.cgColor
        iconButton.isUserInteractionEnabled = true
        iconButton.frame.size = CGSize(width: contentView.frame.width - 10, height: contentView.frame.height - 10)
        iconButton.center = contentView.center
        contentView.addSubview(iconButton)
    }
    
    func updateUI(withIcon icon: Icon, selectedIcon: Icon?) {
        IconStrategy(iconCell: self).setAppearance(with: icon)
        if self.iconButton.accessibilityIdentifier == selectedIcon?.name {
            self.selectIcon()
        } else {
            self.unselectIcon()
        }
    }
    
    func selectIcon() {
        contentView.layer.borderColor = AppEngine.shared.userSetting.themeColor.uiColor.cgColor
    }

    func unselectIcon() {
        contentView.layer.borderColor = UIColor.clear.cgColor
    }
    
    
    
}
