//
//  CalendarBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 10/1/21.
//

import Foundation
import UIKit

class CalendarBuilder {
    let item: Item
    let setting: SystemStyleSetting = SystemStyleSetting.shared
    var calendarView: UIView? = nil
    var horizentalScrollView: UIScrollView = UIScrollView()
    
    init(item: Item) {
        self.item = item
    }
    
    public func builCalendar() -> UIView {
        createNewCalendar()
        addMonthLabel()
        return calendarView!
    }
    
    private func addHorizentalScrollView() {
        //let horizentalScrollView =
    }
    
    private func createNewCalendar() {
        self.calendarView = UIView()
        self.calendarView?.frame = CGRect(x: 0, y: 0, width: SystemStyleSetting.shared.screenFrame.width - 2 * SystemStyleSetting.shared.mainDistance, height: SystemStyleSetting.shared.calendarHeight)
        //self.horizentalScrollView.addSubview(<#T##view: UIView##UIView#>)
    }
    
    private func addMonthLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        
        let monthLabel = UILabel()
        monthLabel.textColor = UIColor.black
        
        monthLabel.text = formatter.string(for: self.item.punchInDate.last)
        print(monthLabel )
//        monthLabel.frame = CGRect(x: SystemStyleSetting.shared.mainDistance, y: 0, width: SystemStyleSetting.shared.screenFrame.width - 4 * SystemStyleSetting.shared.mainDistance, height: SystemStyleSetting.shared.calendarHeight)
        monthLabel.sizeToFit()
        self.calendarView?.addSubview(monthLabel)
        
    }
    
    
}
