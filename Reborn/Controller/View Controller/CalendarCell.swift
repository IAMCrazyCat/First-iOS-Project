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
    public let dot: UIButton = UIButton()
    public var date: CustomDate = CustomDate.current
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
        self.contentView.addSubview(dayButton)
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
    
    
    private func setUpUI() {
    
        
        date = CustomDate.current
        
        contentView.removeAllSubviews()
        contentView.layoutIfNeeded()
        contentView.setCornerRadius()
        contentView.clipsToBounds = false // new
        contentView.backgroundColor = .white // or orange, whatever
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.label.withAlphaComponent(0.05).cgColor
        
        dayButton.setTitle(nil, for: .normal)
        dayButton.backgroundColor = .clear
        dayButton.setTitleColor(.label, for: .normal)
        dayButton.titleLabel?.textAlignment = .center
        dayButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        dot.frame.size = CGSize(width: 6, height: 6)
        dot.setBackgroundColor(.clear, for: .normal)
        dot.accessibilityIdentifier = "dot"
        dot.center.x = contentView.center.x
        dot.frame.origin.y = contentView.frame.maxY + 2
        dot.setCornerRadius()
        
        contentView.addSubview(dayButton)
        contentView.addSubview(dot)
        
        dayButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        dayButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    
    public func updateUI(withType type: CalendarCellType, selectable: Bool, cellDay data: String) {
  
        switch type {
        case .normalWithColorFill:
            self.dayButton.setTitle(data, for: .normal)
            self.dayButton.setTitleColor(AppEngine.shared.userSetting.smartLabelColor, for: .normal)
            self.contentView.backgroundColor = AppEngine.shared.userSetting.themeColor.uiColor
            self.contentView.layer.borderColor = AppEngine.shared.userSetting.themeColor.uiColor.cgColor
        case .normalWithoutColorFill:
            self.dayButton.setTitle(data, for: .normal)
            self.dayButton.setTitleColor(.label, for: .normal)
            self.contentView.backgroundColor = .clear

        case .normalWithColorEdge:
            
            self.dayButton.setTitle(data, for: .normal)
            self.dayButton.setTitleColor(.label, for: .normal)
            self.dayButton.contentMode = .scaleAspectFill
            self.contentView.backgroundColor = .clear
            self.contentView.layer.borderColor = AppEngine.shared.userSetting.themeColor.uiColor.cgColor
            
        case .unselected:
            
            self.dayButton.setTitle(data, for: .normal)
            self.dayButton.setTitleColor(.label, for: .normal)
            self.contentView.backgroundColor = .clear
            self.contentView.layer.borderWidth = 0

        case .grayedOutWithoutColorFill:
            
            self.contentView.backgroundColor = .clear
            self.dayButton.setTitle(data, for: .normal)
            self.dayButton.setTitleColor(UIColor.label.withAlphaComponent(0.2), for: .normal)
            
        case .grayedOutWithColorFill:
        
            self.contentView.backgroundColor = AppEngine.shared.userSetting.themeColor.uiColor.withAlphaComponent(0.3)
            self.dayButton.setTitle(data, for: .normal)
            self.dayButton.setTitleColor(UIColor.white, for: .normal)
        }
        
        self.dayButton.isUserInteractionEnabled = selectable ? true : false
    
    }
    
    func addDotToBottom(withColor color: UIColor) {
        print(dot.frame)
        dot.setBackgroundColor(color, for: .normal)
    }
    

    


   
    
   
    
    
}
