//
//  CalendarPageViewController.swift
//  Reborn
//
//  Created by Christian Liu on 19/1/21.
//

import UIKit

class CalendarPageViewController: UIViewController {
    
    public static var shared: CalendarPageViewController = CalendarPageViewController()
    public var calendarPage: CalendarPage? {
        didSet {
            
        }
    }
    private var day: Int = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    
}


extension CalendarPageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarPageCell.identifier, for: indexPath) as! CalendarPageCell

        if indexPath.row < (self.calendarPage?.weekdayOfFirstDay ?? 0) - 1 {

            cell.dayLabel.backgroundColor = UIColor.clear

        } else if indexPath.row > (self.calendarPage?.weekdayOfFirstDay ?? 0) - 1 && indexPath.row < (self.calendarPage?.days ?? 31) + (self.calendarPage?.weekdayOfFirstDay ?? 0)  {

            let dayNumber = indexPath.row - (self.calendarPage?.weekdayOfFirstDay ?? 0) + 1

            cell.dayLabel.text = String(dayNumber)
            self.day += 1

        } else {
            cell.dayLabel.backgroundColor = UIColor.clear
        }
        
        cell.dayLabel.text = String(indexPath.row)
        self.day += 1
        
       
        print("????????\(calendarPage)")
        return cell
    }
    
   

    
}

extension CalendarPageViewController: UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on day \(indexPath.row - self.calendarPage!.weekdayOfFirstDay + 1)")
       print()
    }
    
    
}




