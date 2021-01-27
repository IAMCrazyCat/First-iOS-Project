//
//  TimeMachineViewController.swift
//  Reborn
//
//  Created by Christian Liu on 26/1/21.
//

import UIKit

class TimeMachineViewController: UIViewController {
    
    var calendarView: UIView?
    var calendarViewPosition: CGPoint?
    let setting: SystemStyleSetting = SystemStyleSetting.shared
    var backCalendarPages: Array<UIView> = []
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
   
    func updateUI() {
        
        if calendarView != nil {

            self.view.addSubview(calendarView!)

            self.calendarView!.frame.origin = calendarViewPosition!
            self.calendarView!.layer.zPosition = 5
            self.calendarView!.layer.cornerRadius = self.setting.itemCardCornerRadius
            self.calendarView!.layer.masksToBounds = true
            self.calendarView!.setViewShadow()
            UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseOut, animations: {
                self.calendarView!.frame.origin.y += 50
            }) { _ in
                
                var newCalendarPageCordiateYDifference: CGFloat = 10
                var newCalendarPageSizeDifference: CGFloat = 20
                var zPosition: CGFloat = 4
                
                for _ in 1 ... 3 {
                    let newCalendarPage = UIView()
                    
                    newCalendarPage.frame = CGRect(x: self.calendarView!.frame.origin.x + newCalendarPageSizeDifference / 2, y: self.calendarView!.frame.origin.y, width: self.calendarView!.frame.width - newCalendarPageSizeDifference, height: self.calendarView!.frame.height - newCalendarPageSizeDifference)
                    newCalendarPage.backgroundColor = .white
                    newCalendarPage.layer.zPosition = zPosition
                    newCalendarPage.layer.cornerRadius = self.setting.itemCardCornerRadius
                    newCalendarPage.setViewShadow()
                    
                    //self.view.addSubview(newCalendarPage)
                    self.view.insertSubview(newCalendarPage, belowSubview: self.calendarView!)
                    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                        newCalendarPage.frame.origin.y -= newCalendarPageCordiateYDifference
                    })
                    
                    self.backCalendarPages.append(newCalendarPage)
                    zPosition -= 1
                    newCalendarPageCordiateYDifference += 10
                    newCalendarPageSizeDifference += 50
                }
                
               
            }
        }
        
        
       
        
    
    }

}
extension TimeMachineViewController: CalendarViewDegelagte {
    func calendarCellDidLayout(size: CGSize) {
        
    }
    
    func calendarPageDidGoLastMonth() {
        print(backCalendarPages)
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            
            //self.calendarView?.layer.addSublayer(self.calendarView!.layer)
            self.backCalendarPages[0].addSubview(self.calendarView!.subviews[0])
            self.calendarView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1)
            self.calendarView?.alpha = 0
            
        }) { _ in
            self.calendarView?.removeFromSuperview()
        }
        
    }
    
    func calendarPageDidGoNextMonth() {
        
    }
    
    func calendarPageDidGoStartMonth() {
        
    }
    
    func calendarPageDidGoThisMonth() {
        
    }
    
    
}
