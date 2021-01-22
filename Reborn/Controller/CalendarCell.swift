//
//  CalendarCell.swift
//  Reborn
//
//  Created by Christian Liu on 21/1/21.
//

import Foundation
import UIKit
class CalendarCell: UICollectionViewCell {

    static var identifier: String = "DayCell"
    let dayLabel: UILabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.setUpUI()
        self.contentView.addSubview(dayLabel)
    }
    
    private func setUpUI() {
        dayLabel.text = nil
        dayLabel.sizeToFit()
        dayLabel.backgroundColor = .green
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
        setUpUI()
    }
    
   
    
    
}
