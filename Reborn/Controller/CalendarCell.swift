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
        contentView.layer.cornerRadius = contentView.frame.width / 2
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white // or orange, whatever

        dayLabel.text = nil
        dayLabel.backgroundColor = .clear
        //dayLabel.layer.borderWidth = 0.5
        dayLabel.textColor = .black
        dayLabel.textAlignment = .center
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
       
        contentView.addSubview(dayLabel)

        dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        dayLabel.frame = self.contentView.frame
        dayLabel.layer.cornerRadius = dayLabel.frame.width / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setUpUI()
    }
    
    
   
    
    
}
