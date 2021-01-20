//
//  CalendarPageViewController.swift
//  Reborn
//
//  Created by Christian Liu on 19/1/21.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    
    public static var shared: CalendarCell = CalendarCell()
    public var calendarPage: CalendarPage? = nil
    private var day: Int = 1
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("cell inited")
        
        let test = UILabel()
        test.text = "test"
        test.sizeToFit()
        
        self.contentView.addSubview(test)
        print("CurrentPageIndex \(CalendarViewController.shared.currentPageIndex)")
        self.calendarPage = CalendarViewController.shared.calendarPages[CalendarViewController.shared.currentPageIndex]
        let builder = CalendarPageBuilder(calendarPage: self.calendarPage!, width: self.frame.width, height: self.frame.height, cordinateX: 0, cordinateY: 0 )
        self.addSubview(builder.buildCalendarPage())

    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func initialize(calendarPage: CalendarPage) {
        print("initialized")
        self.calendarPage = calendarPage
        self.day = 1

    }
    
    override func prepareForReuse() {
        print("Cell Reused")
        super.prepareForReuse()
        self.day = 1
    }
    
}


extension CalendarCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if calendarPage != nil {
            let days = calendarPage!.days + calendarPage!.weekdayOfFirstDay // How many cells to display
            print("total days \(days)")
            return days
        } else {
            return 0
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath)
        
        if indexPath.row < self.calendarPage?.weekdayOfFirstDay ?? 0 {
            
            cell.backgroundColor = UIColor.clear
            
        } else {
 
            let dayLabel = UILabel()
            dayLabel.text = String(day)
            dayLabel.sizeToFit()
            dayLabel.frame = CGRect(origin: CGPoint(x: 0, y: 0) , size: cell.frame.size)
            dayLabel.textAlignment = .center
            dayLabel.layer.cornerRadius = dayLabel.frame.size.width / 2
            dayLabel.clipsToBounds = true
            
           
            let dayNumber = indexPath.row - (self.calendarPage?.weekdayOfFirstDay ?? 0) + 1
            //print(self.calendarPage!.punchedInDays)
            if let _ = self.calendarPage, self.calendarPage!.punchedInDays.contains(dayNumber) {
                dayLabel.backgroundColor = UserStyleSetting.themeColor
                dayLabel.textColor = UIColor.white
              
            } else {
                dayLabel.backgroundColor = SystemStyleSetting.shared.whiteAndBlack
                dayLabel.textColor = UIColor.black
            }
            
            cell.addSubview(dayLabel)
        
            if self.day > self.calendarPage!.days {
                self.day = 1
            }
            
            print(self.day)
        }
        
       
        
        return cell
    }
    
   

    
}

extension CalendarCell: UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on day \(indexPath.row - self.calendarPage!.weekdayOfFirstDay + 1)")
       print()
    }
    
    
}




