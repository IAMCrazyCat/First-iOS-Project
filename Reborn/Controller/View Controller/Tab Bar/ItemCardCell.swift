//
//  ItemCardCell.swift
//  Reborn
//
//  Created by Christian Liu on 21/7/21.
//

import Foundation
import UIKit
class ItemCardCell: UICollectionViewCell {
    static var identifier: String = "ItemCardCell"
    public let itemCardView: ItemCardView? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
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
    }
    
    func updateUI(with itemCardView: ItemCardView) {
        self.contentView.addSubview(itemCardView)
    }
    
 
}
