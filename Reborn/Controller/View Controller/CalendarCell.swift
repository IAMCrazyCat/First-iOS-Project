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
    
        state = .normal
        contentView.removeAllSubviews()
        contentView.layoutIfNeeded()
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
    
    
    public func updateUI(withType type: CalendarCellType, cellDay data: String) {
        
        
        
        
        switch type {
        case .punchedInDay:
            self.state = .disabled
            self.dayButton.setTitle(data, for: .normal)
            self.dayButton.setTitleColor(AppEngine.shared.userSetting.smartLabelColor, for: .normal)
            self.contentView.backgroundColor = AppEngine.shared.userSetting.themeColor.uiColor
            self.contentView.layer.borderColor = AppEngine.shared.userSetting.themeColor.uiColor.cgColor
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
                self.dayButton.contentMode = .scaleAspectFill
                
//                let imageView = UIImageView()
//                imageView.frame = self.contentView.frame
//                imageView.image = #imageLiteral(resourceName: "FrequencyIcon").withTintColor(.systemPink)
//                imageView.tintColor = .systemPink
//                imageView.contentMode = .scaleToFill
//                imageView.layer.zPosition = 5
//                imageView.frame.origin.x -= 1
//                imageView.alpha = 0
//                self.contentView.addSubview(imageView)
//                UIView.animate(withDuration: 0.3, animations: {
//                    imageView.alpha = 1
//                })
//                self.dayButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
//                UIView.animate(withDuration: 0.2, animations: {
//                    self.dayButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
//                }) { _ in
//                    UIView.animate(withDuration: 0.1, animations: {
//                        self.dayButton.transform = CGAffineTransform(scaleX: 1, y: 1)
//                    })
//
//                }
                self.contentView.backgroundColor = .clear
                self.contentView.layer.borderColor = AppEngine.shared.userSetting.themeColor.uiColor.cgColor
             
            }
            
        case .unselected:
            self.state = .normal
            self.dayButton.setTitle(data, for: .normal)
            self.dayButton.setTitleColor(.label, for: .normal)
            self.contentView.backgroundColor = .clear
            self.contentView.layer.borderWidth = 0
            
        case.unselectedInTimeMachine:
            self.state = .disabled
            self.dayButton.setTitle(data, for: .normal)
            self.dayButton.setTitleColor(.label, for: .normal)
            self.contentView.backgroundColor = .clear
            self.contentView.layer.borderWidth = 0
        case .notThisMonthMissedDay, .dayAfterTodayInTimeMachine:
            
            self.state = .disabled
            self.contentView.backgroundColor = .clear
            self.dayButton.setTitle(data, for: .normal)
            self.dayButton.setTitleColor(UIColor.label.withAlphaComponent(0.2), for: .normal)
            
        case .nothThisMonthPunchedIn:
            
            self.state = .disabled
            self.contentView.backgroundColor = AppEngine.shared.userSetting.themeColor.uiColor.withAlphaComponent(0.3)
            self.dayButton.setTitle(data, for: .normal)
            self.dayButton.setTitleColor(UIColor.white, for: .normal)
        }
        
        if self.state == .disabled {
            self.dayButton.isUserInteractionEnabled = false
        } else {
            self.dayButton.isUserInteractionEnabled = true
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
    


   
    
   
    
    
}
