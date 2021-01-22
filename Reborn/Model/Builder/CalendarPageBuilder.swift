//
//  CalendarBuilder.swift
//  Reborn
//
//  Created by Christian Liu on 10/1/21.
//

import Foundation
import UIKit

class CalendarPageBuilder {

    let setting: SystemStyleSetting = SystemStyleSetting.shared
    let calendarPage: CalendarPage
    let width: CGFloat
    let height: CGFloat
    let cordinateX: CGFloat
    let cordinateY: CGFloat
    var calendarPageView: UIView? = nil
    var horizentalScrollView: UIScrollView = UIScrollView()
    let calendatPageViewController: CalendarPageViewController = CalendarPageViewController.shared
    
    init(calendarPage: CalendarPage, width: CGFloat, height: CGFloat, cordinateX: CGFloat, cordinateY: CGFloat) {
        self.calendarPage = calendarPage
        self.width = width
        self.height = height
        self.cordinateX = cordinateX
        self.cordinateY = cordinateY
    }
    
    
    public func buildCalendarPage() -> UIView {
        createCalendarPageCellView()
        
        //reateCalendarPageView()
        //addDayButtons()
        
        return calendarPageView!
    }
    
//    private func createContentView() {
//        contentView = UIView()
//        contentView?.frame = CGRect(x: 0, y: 0, width: width * 3, height: height)
//    }
    
    private func createCalendarPageCellView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.width / 7, height: self.height / 6)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
       
        calendarPageView = UICollectionView(frame: CGRect(x: cordinateX, y: cordinateY, width: width, height: height), collectionViewLayout: layout)
        (calendarPageView! as! UICollectionView).backgroundColor = SystemStyleSetting.shared.whiteAndBlack
        (calendarPageView! as! UICollectionView).register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DayCell")

        (calendarPageView! as! UICollectionView).delegate = calendatPageViewController
        (calendarPageView! as! UICollectionView).dataSource = calendatPageViewController
        (calendarPageView! as! UICollectionView).tag = 11607
        
        
    }
    
    private func createCalendarPageView() {
        calendarPageView? = UIView(frame: CGRect(x: cordinateX, y: cordinateY, width: width, height: height))
    }
    
    private func addDayButtons() {
        let unitWidth = width / 7
        let unitHeight = height / 6
        var coordinateX: CGFloat = 0
        var coordinateY: CGFloat = 0
        var column: Int = self.calendarPage.weekdayOfFirstDay

        for day in 1 ... self.calendarPage.days {
            

            let dayButton = UIButton()
            coordinateX = CGFloat(column - 1) * unitWidth
//            print(column)
//            print("Calendar builder page coordinateX: \(coordinateX)")

            dayButton.frame = CGRect(x: coordinateX, y: coordinateY, width: unitWidth, height: unitWidth)
            //dayButton.center.x = coordinateX + unitWidth / 2
            dayButton.layer.cornerRadius = self.setting.calendarDaySelectionButtonCornerRadius
            dayButton.setTitle(String(day), for: .normal)
            dayButton.setTitleColor(UIColor.black, for: .normal)
            dayButton.contentHorizontalAlignment = .center
            dayButton.contentVerticalAlignment = .center
            dayButton.tag = day
            dayButton.backgroundColor = self.setting.whiteAndBlack

            for punchedInDay in self.calendarPage.punchedInDays {
                if day == punchedInDay {
                    dayButton.backgroundColor = UserStyleSetting.themeColor
                    dayButton.setTitleColor(UIColor.white, for: .normal)
                    break
                }
            }
            calendarPageView?.addSubview(dayButton)

            column += 1

            if column > 7 {
                coordinateY += unitHeight
                column = 1
            }
        }

    }
    
    

    
    
}
