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
    let dayButton: UIButton = UIButton()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
        self.contentView.addSubview(dayButton)
    }
    
    private func setUpUI() {
        contentView.layer.cornerRadius = contentView.frame.width / 2
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white // or orange, whatever
        
        
        dayButton.setTitle(nil, for: .normal)
        dayButton.backgroundColor = .clear
        dayButton.setTitleColor(.black, for: .normal)
        dayButton.titleLabel?.textAlignment = .center
        dayButton.translatesAutoresizingMaskIntoConstraints = false
       
        contentView.addSubview(dayButton)

        dayButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        dayButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        dayButton.frame = self.contentView.frame
        dayButton.layer.cornerRadius = dayButton.frame.width / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setUpUI()
    }
    
    
   
    
    
}
