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
        contentView.removeAllSubviews()
        contentView.setCornerRadius()
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white // or orange, whatever
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.label.withAlphaComponent(0.05).cgColor
        
        dayButton.setTitle(nil, for: .normal)
        dayButton.backgroundColor = .clear
        dayButton.setTitleColor(.label, for: .normal)
        dayButton.titleLabel?.textAlignment = .center
        dayButton.translatesAutoresizingMaskIntoConstraints = false
       
        contentView.addSubview(dayButton)

        dayButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        dayButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    
    public func updateAppearence(withType type: CalendarCellType, cellDay data: String) {

        switch type {
        case .punchedInDay:
            self.state = .disabled
            self.dayButton.setTitle(data, for: .normal)
            self.dayButton.setTitleColor(.white, for: .normal)
            self.contentView.backgroundColor = AppEngine.shared.userSetting.themeColor
            self.contentView.layer.borderColor = AppEngine.shared.userSetting.themeColor.cgColor
        case .breakDay:
            break
        case .missedDay:
            self.state = .normal
            self.contentView.backgroundColor = .clear
            
            self.dayButton.setTitle(data, for: .normal)
       
        case .selected:
            
            if self.state != .disabled {
                self.state = .selected
                self.dayButton.setTitle(data, for: .normal)
                self.dayButton.setTitleColor(.label, for: .normal)
                self.contentView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                UIView.animate(withDuration: 0.2, animations: {
                    self.contentView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }) { _ in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.contentView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    })
                    
                }
                self.contentView.backgroundColor = .clear
                self.contentView.layer.borderWidth = 1
                self.contentView.layer.borderColor = AppEngine.shared.userSetting.themeColor.cgColor
            }
            
        case .unselected:
            
            if self.state != .disabled {
                self.state = .normal
                self.dayButton.setTitle(data, for: .normal)
                self.dayButton.setTitleColor(.label, for: .normal)
                self.contentView.backgroundColor = .clear
                self.contentView.layer.borderWidth = 0
            }
        case .notThisMonthMissedDay:
            
            self.state = .disabled
            self.contentView.backgroundColor = .clear
            self.dayButton.setTitle(data, for: .normal)
            self.dayButton.setTitleColor(UIColor.label.withAlphaComponent(0.2), for: .normal)
            
        case .nothThisMonthPunchedIn:
            
            self.state = .disabled
            self.contentView.backgroundColor = AppEngine.shared.userSetting.themeColor.withAlphaComponent(0.3)
            self.dayButton.setTitle(data, for: .normal)
            self.dayButton.setTitleColor(UIColor.white, for: .normal)
        }
        
    }
    
    func addDotToBottom(withColor color: UIColor) {
        let dot = UIView()
        dot.accessibilityIdentifier = "dot"
        dot.frame.size = CGSize(width: self.contentView.frame.size.width.truncatingRemainder(dividingBy: 6) , height: self.contentView.frame.size.height.truncatingRemainder(dividingBy: 6))
        dot.center.x = self.contentView.center.x
        dot.frame.origin.y = self.contentView.frame.maxY + 2
        dot.backgroundColor = color
        dot.setCornerRadius()
        self.contentView.clipsToBounds = false
        
        self.contentView.addSubview(dot)
    }
    


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        //dayButton.frame = self.contentView.frame
        //dayButton.layer.cornerRadius = dayButton.frame.width / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setUpUI()
    }
    
    
   
    
    
}
