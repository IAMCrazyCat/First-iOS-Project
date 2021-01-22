//
//  CalendarPageCell.swift
//  Reborn
//
//  Created by Christian Liu on 22/1/21.
//

import Foundation
import UIKit

class CalendarPageCell: UICollectionViewCell {
    static var identifier: String = "CalendarPageCell"
    
    let dayLabel: UILabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.setUpUI()
        self.contentView.addSubview(dayLabel)
    }
    
    private func setUpUI() {

        dayLabel.sizeToFit()
        dayLabel.backgroundColor = .purple
        dayLabel.textAlignment = .center
        dayLabel.layer.cornerRadius = dayLabel.frame.size.width / 2
        dayLabel.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        dayLabel.frame = self.contentView.frame
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dayLabel.text = nil
    }
}
