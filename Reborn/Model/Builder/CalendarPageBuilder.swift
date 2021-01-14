//
//  CalendarBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 10/1/21.
//

import Foundation
import UIKit

class CalendarPageBuilder {
    let item: Item
    let setting: SystemStyleSetting = SystemStyleSetting.shared
    let width: CGFloat
    let height: CGFloat
    var calendarView: UIView? = nil
    var horizentalScrollView: UIScrollView = UIScrollView()
    
    var contentView: UIView? = nil
    init(item: Item, width: CGFloat, height: CGFloat) {
        self.item = item
        self.width = width
        self.height = height
    }
    
    
    public func builCalendar() -> UIView {
        createContentView()
        createCenterCalendarPage()
        return contentView!
    }
    
    private func createContentView() {
        contentView = UIView()
        contentView?.frame = CGRect(x: 0, y: 0, width: width * 3, height: height)
    }
    
    
    
    private func createLeftCalendarPage() {
        
    }
    
    private func createCenterCalendarPage() {
        let dates: Array<Date> = []
        
        
        let centerCalendarPage = UIView()
        centerCalendarPage.frame = CGRect(x: width, y: 0, width: width, height: height)
        centerCalendarPage.backgroundColor = UIColor.red
        contentView?.addSubview(centerCalendarPage)
        
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
