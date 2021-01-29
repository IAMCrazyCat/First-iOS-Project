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
    
    var newCalendarPageCordiateYDifference: CGFloat = 0
    var newCalendarPageSizeDifference: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newCalendarPageSizeDifference = self.setting.newCalendarPageSizeDifference
        self.newCalendarPageCordiateYDifference = self.setting.newCalendarPageCordiateYDifference
    }
    
   
    func inlitializeUI() {
        
        if calendarView != nil {
            
            self.view.addSubview(calendarView!)
            self.calendarView!.frame.origin = calendarViewPosition!
            print(self.calendarView!.frame)
            self.calendarView!.layer.zPosition = 5
            self.calendarView!.layer.cornerRadius = self.setting.itemCardCornerRadius
            self.calendarView!.layer.masksToBounds = true
            self.calendarView!.setViewShadow()
            self.backCalendarPages.append(calendarView!)
            

            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.calendarView!.frame.origin.y += 50
            }) { _ in
                

                for index in 0 ... 2 {
                    let newCalendarPage = UIView()

                    newCalendarPage.frame = CGRect(x: self.calendarView!.frame.origin.x + self.newCalendarPageSizeDifference / 2, y: self.calendarView!.frame.origin.y, width: self.calendarView!.frame.width - self.newCalendarPageSizeDifference, height: self.calendarView!.frame.height - self.newCalendarPageSizeDifference)
                    newCalendarPage.backgroundColor = .white
                    newCalendarPage.layer.cornerRadius = self.setting.itemCardCornerRadius
                    newCalendarPage.setViewShadow()
                    
                    //self.view.addSubview(newCalendarPage)
                    self.view.insertSubview(newCalendarPage, belowSubview: self.backCalendarPages[index])
                    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                        newCalendarPage.frame.origin.y -= self.newCalendarPageCordiateYDifference
                    })
                    
                    self.backCalendarPages.append(newCalendarPage)
                    self.newCalendarPageCordiateYDifference += self.setting.newCalendarPageCordiateYDifference
                    self.newCalendarPageSizeDifference += self.setting.newCalendarPageSizeDifference
  
                }
                
                self.newCalendarPageCordiateYDifference = self.setting.newCalendarPageCordiateYDifference
                self.newCalendarPageSizeDifference = self.setting.newCalendarPageSizeDifference
            }
        }
        
    
    }
    
    func updateUI() {
        
        // add new calendar page to the back
        let newCalendarPage = UIView()
        newCalendarPage.frame = CGRect(x: self.backCalendarPages[self.backCalendarPages.count - 1].frame.origin.x + self.newCalendarPageSizeDifference / 2, y: self.backCalendarPages[self.backCalendarPages.count - 1].frame.origin.y - self.newCalendarPageCordiateYDifference, width: self.backCalendarPages[self.backCalendarPages.count - 1].frame.width - self.newCalendarPageSizeDifference, height: self.backCalendarPages[self.backCalendarPages.count - 1].frame.height - self.newCalendarPageSizeDifference)
        
        newCalendarPage.backgroundColor = .white
        newCalendarPage.alpha = 0
        newCalendarPage.layer.cornerRadius = self.setting.itemCardCornerRadius
        newCalendarPage.setViewShadow()
        
        self.view.insertSubview(newCalendarPage, belowSubview: self.backCalendarPages[self.backCalendarPages.count - 1])
        self.backCalendarPages.append(newCalendarPage)
        
       
        
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseOut, animations: {
            
            var index = 0
            while index < self.backCalendarPages.count {
                let backCalendarPage = self.backCalendarPages[index]
                
                backCalendarPage.alpha = 1
                
                // topper calendar page disapear
                if index <= 0 {
                    
                    //backCalendarPage.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1)
                    //backCalendarPage.frame.origin.y += self.newCalendarPageCordiateYDifference
                    backCalendarPage.alpha = 0
                    
                    
                } else {
                    
        
                    // second top calendar page goes forward
//                    let widthRatio = (backCalendarPage.frame.width + self.newCalendarPageSizeDifference) / backCalendarPage.frame.width
//                    let heightRatio = (backCalendarPage.frame.height + self.newCalendarPageSizeDifference) / backCalendarPage.frame.height
//
//                    backCalendarPage.layer.transform = CATransform3DMakeScale(1.01, 1.01, 1)
//                    backCalendarPage.frame.origin.x -= self.newCalendarPageSizeDifference / 2
//                    backCalendarPage.frame.origin.y += self.newCalendarPageCordiateYDifference
                    
                    if index == 1 {
                        print(self.backCalendarPages[0].frame)
                        let interactableCalendarView = self.backCalendarPages[0].subviews[0]
    
                        backCalendarPage.frame = CGRect(x: backCalendarPage.frame.origin.x - self.newCalendarPageSizeDifference / 2, y: backCalendarPage.frame.origin.y + self.newCalendarPageCordiateYDifference, width: backCalendarPage.frame.width + self.newCalendarPageSizeDifference, height: backCalendarPage.frame.height + self.newCalendarPageSizeDifference)
                        self.backCalendarPages[1].addSubview(interactableCalendarView)
                         
                    } else {
                        backCalendarPage.frame = CGRect(x: backCalendarPage.frame.origin.x - self.newCalendarPageSizeDifference / 2, y: backCalendarPage.frame.origin.y + self.newCalendarPageCordiateYDifference, width: backCalendarPage.frame.width + self.newCalendarPageSizeDifference, height: backCalendarPage.frame.height + self.newCalendarPageSizeDifference)
                    }
            
                }
                
                index += 1
            }
            
            
            
        }) { _ in
            
            // send interacable calendar view to back calendar page
         
            self.backCalendarPages[0].removeFromSuperview()
            self.backCalendarPages.remove(at: 0)
            
       
        }
        
       
        
    }
    
    

}
extension TimeMachineViewController: CalendarViewDegelagte {
    func calendarCellDidLayout(size: CGSize) {
        
    }
    
    func calendarPageDidGoLastMonth() {
        updateUI()
        
    }
    
    func calendarPageDidGoNextMonth() {
        
    }
    
    func calendarPageDidGoStartMonth() {
        
    }
    
    func calendarPageDidGoThisMonth() {
        
    }
    
    
}
