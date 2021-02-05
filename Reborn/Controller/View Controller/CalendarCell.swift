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
    public let dayButton: UIButton = UIButton()
    public var state: UIControl.State = .normal


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
        self.contentView.addSubview(dayButton)
    }
    
    private func setUpUI() {
    
        state = .normal
        
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
    
    public func updateUI(type: CalendarCellType, cellDay data: String) {

        switch type {
        case .punchedInDay:
            self.state = .disabled
            self.dayButton.setTitle(data, for: .normal)
            self.dayButton.setTitleColor(.white, for: .normal)
            self.contentView.backgroundColor = UserStyleSetting.themeColor
        case .breakDay:
            break
        case .missedDay:
            self.state = .normal
            self.dayButton.setTitle(data, for: .normal)
        case .transparent:
            self.state = .disabled
            self.contentView.backgroundColor = .clear
        case .selected:
            
            if self.state != .disabled {
                self.state = .selected
                self.dayButton.setTitle(data, for: .normal)
                self.dayButton.setTitleColor(.white, for: .normal)
                self.contentView.backgroundColor = .green
            }
        case .unselected:
            if self.state != .disabled {
                self.state = .normal
                self.dayButton.setTitle(data, for: .normal)
                self.dayButton.setTitleColor(.black, for: .normal)
                self.contentView.backgroundColor = .clear
            }
        }
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
