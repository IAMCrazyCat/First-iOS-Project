//
//  CalendarCell.swift
//  Reborn
//
//  Created by Christian Liu on 21/1/21.
//

import Foundation
import UIKit
class CalendarCell: UICollectionViewCell {

    static var identifier: String = "CalendarCell"
    
    var calendarPage: CalendarPage = {
        return CalendarPage(year: 1997, month: 4, punchedInDays: [9])
    } ()
    
    let setting: SystemStyleSetting = SystemStyleSetting.shared
    
    var myLabel: UILabel = {
        let label = UILabel()
        label.text = "CUSTOM"
        label.backgroundColor = .green
        label.textAlignment = .center
        return label
    } ()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = UIColor.red
        addDayButtons()
        print(calendarPage)
        print(myLabel.text)
        self.contentView.addSubview(myLabel)
        
    }
    
  
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
//        let subviews = self.contentView.subviews
//        for subview in subviews {
//            if subview.tag == 11607 {
//                for subview in subview.subviews {
//                    subview.removeFromSuperview()
//                }
//            }
//
//        }

    }
    
    override func layoutSubviews() {
        myLabel.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width - 50, height: 50)
    }
    
    
    
}
