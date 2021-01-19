//
//  CalendarPageViewController.swift
//  Reborn
//
//  Created by Christian Liu on 19/1/21.
//

import UIKit

class CalendarPageViewController: UIViewController {
    
    public static var shared: CalendarPageViewController = CalendarPageViewController()
    public var calendarPages: Array<CalendarPage> = []
    private var day: Int = 1
    public var currentPage: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    public func addPage(newCalendarPage calendarPage: CalendarPage) {
        self.calendarPages.append(calendarPage)
        self.day = 1
    }
    
}

extension CalendarPageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return calendarPages[currentPage].days + calendarPages[currentPage].weekdayOfFirstDay // How many cells to display
    }
        
        
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath)
        
        
        if indexPath.row < self.calendarPages[self.currentPage].weekdayOfFirstDay {
            
            cell.backgroundColor = UIColor.clear
            
        } else {
            
            
            
            
            let dayLabel = UILabel()
            dayLabel.text = String(day)
            dayLabel.sizeToFit()
            dayLabel.frame = CGRect(origin: CGPoint(x: 0, y: 0) , size: cell.frame.size)
            dayLabel.textAlignment = .center
            dayLabel.layer.cornerRadius = dayLabel.frame.size.width / 2
            dayLabel.clipsToBounds = true
            
            if indexPath.row == self.calendarPages[self.currentPage].weekdayOfFirstDay + 1 {
                dayLabel.backgroundColor = UserStyleSetting.themeColor
              
            } else {
                dayLabel.backgroundColor = SystemStyleSetting.shared.whiteAndBlack
            }
            
            cell.addSubview(dayLabel)
        
            
            self.day += 1

        }
        
       
        
        return cell
    }
    
   

    
}

extension CalendarPageViewController: UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on day \(indexPath.row - self.calendarPages[self.currentPage].weekdayOfFirstDay + 1)")
       print()
    }
    
    
}




