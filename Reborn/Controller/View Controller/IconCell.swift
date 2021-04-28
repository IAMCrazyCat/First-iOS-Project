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
        iconButton.frame = contentView.bounds
        contentView.addSubview(iconButton)
    }
    
    func updateUI(withIcon icon: Icon) {
        IconStrategy(iconCell: self).setAppearance(with: icon)
    }
    
}
