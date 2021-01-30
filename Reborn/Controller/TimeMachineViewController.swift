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
    var calendarViewController: CalendarViewController?
    
    let setting: SystemStyleSetting = SystemStyleSetting.shared
    var backCalendarPages: Array<UIView> = []
    var userDidGo: NewCalendarPage = .noWhere
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
   
    
    
    func inlitializeUI() {
        
        if calendarView != nil {
            
            self.view.addSubview(calendarView!)
            self.calendarView!.frame.origin = calendarViewPosition!
            self.calendarView!.layer.cornerRadius = self.setting.itemCardCornerRadius
            self.calendarView!.layer.masksToBounds = true
            self.calendarView!.setViewShadow()
            self.backCalendarPages.append(calendarView!)
            
            var cordinateYDifference = self.setting.newCalendarPageCordiateYDifference
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {

                self.calendarView!.frame.origin.y += self.setting.newCalendarPageCordiateYDifference
            }) { _ in
                
                var scale: CGFloat = 1
    
                var r: CGFloat = 1
                var g: CGFloat = 1
                var b: CGFloat = 1
                
                for index in 0 ... self.setting.numberOfCalendarPages - 2 {
                    
                    r -= self.setting.calendarPageColorDifference
                    g -= self.setting.calendarPageColorDifference
                    b -= self.setting.calendarPageColorDifference
                    
                    scale *= self.setting.newCalendarPageSizeDifference
                    let newCalendarPage = UIView()
                    
                    newCalendarPage.frame = self.backCalendarPages[0].frame
                    newCalendarPage.transform = CGAffineTransform(scaleX: scale, y: scale)
                    newCalendarPage.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1)
                    newCalendarPage.layer.cornerRadius = self.setting.itemCardCornerRadius
                    newCalendarPage.setViewShadow()
                    
                    
                    self.view.insertSubview(newCalendarPage, belowSubview: self.backCalendarPages[index])
                    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                        newCalendarPage.frame.origin.y -= cordinateYDifference
                    
                    })
                    
                    self.backCalendarPages.append(newCalendarPage)
                    cordinateYDifference += self.setting.newCalendarPageCordiateYDifference
                    

                }
                
            
            }
        }
        
    
    }
    
    
    func addNewCalendarPage() { // add new calendar page to the front or back
        
        if userDidGo == .lastMonth {
            let newCalendarPage = UIView()
            let scale = CGFloat(pow(Double(self.setting.newCalendarPageSizeDifference), Double(self.backCalendarPages.count)))
            let r = self.backCalendarPages.last!.backgroundColor!.value.red - self.setting.calendarPageColorDifference
            let g = self.backCalendarPages.last!.backgroundColor!.value.green - self.setting.calendarPageColorDifference
            let b = self.backCalendarPages.last!.backgroundColor!.value.blue - self.setting.calendarPageColorDifference
            
            newCalendarPage.frame = self.backCalendarPages.first!.frame // new calendar page frame equals to the first page
            newCalendarPage.frame.origin.y =  self.backCalendarPages.first!.frame.origin.y - self.setting.newCalendarPageCordiateYDifference * CGFloat(self.backCalendarPages.count) // move up the new calendar page to its proper position Y
            newCalendarPage.transform =  CGAffineTransform(scaleX: scale, y: scale) // scale it accroding to first page to its proper size
            
            // set style
            newCalendarPage.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: self.backCalendarPages.last!.backgroundColor!.value.alpha)
            //newCalendarPage.alpha = 0
            newCalendarPage.layer.cornerRadius = self.setting.itemCardCornerRadius
            newCalendarPage.setViewShadow()

            self.view.insertSubview(newCalendarPage, belowSubview: self.backCalendarPages.last!)
            self.backCalendarPages.append(newCalendarPage)
            
        } else if userDidGo == .nextMonth {
            
            let newCalendarPage = UIView()
            let scale = 1 / self.setting.newCalendarPageSizeDifference // new page is one unit larger than first page
            let r = self.backCalendarPages.last!.backgroundColor!.value.red + self.setting.calendarPageColorDifference
            let g = self.backCalendarPages.last!.backgroundColor!.value.green + self.setting.calendarPageColorDifference
            let b = self.backCalendarPages.last!.backgroundColor!.value.blue + self.setting.calendarPageColorDifference
            let a = self.backCalendarPages.first!.backgroundColor!.value.alpha
            newCalendarPage.frame = self.backCalendarPages.first!.frame
            newCalendarPage.frame.origin.y =  self.backCalendarPages.first!.frame.origin.y + self.setting.newCalendarPageCordiateYDifference
            newCalendarPage.transform =  CGAffineTransform(scaleX: scale, y: scale) // scale it accroding to first page to its proper size
            
            newCalendarPage.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: a)
            
            newCalendarPage.alpha = 1
            newCalendarPage.layer.cornerRadius = self.setting.itemCardCornerRadius
            newCalendarPage.setViewShadow()
            
            self.view.insertSubview(newCalendarPage, aboveSubview: self.backCalendarPages.first!)
            self.backCalendarPages.insert(newCalendarPage, at: 0)
        }
       
    }
    
    func addTempCalendatPage() {
        
        if calendarViewController != nil {
           
            
            if userDidGo == .lastMonth {
                
                let builder = TimeMachineCalendarPageBuilder(interactableCalendarView: self.backCalendarPages.first!.subviews.first!, calendarViewController: self.calendarViewController!, userDidGo: userDidGo)
                self.backCalendarPages.first!.addSubview(builder.buildCalendarPage()) // add temp calendar page to that will disapear
                
            } else if userDidGo == .nextMonth {
                
                let builder = TimeMachineCalendarPageBuilder(interactableCalendarView: self.backCalendarPages[1].subviews.first!, calendarViewController: self.calendarViewController!, userDidGo: userDidGo)
                self.backCalendarPages[1].addSubview(builder.buildCalendarPage()) // add temp calendar page to that will disapear
            }
            
           
        }
    }
    
    func updateOtherCalendarPages() {
        
        
     
        
        UIView.animate(withDuration: 3.35, delay: 0, options: .curveEaseOut, animations: {
            
   
            for index in 0 ... self.backCalendarPages.count - 1 {
                
                let backCalendarPage = self.backCalendarPages[index]
                let scale: CGFloat = self.setting.newCalendarPageSizeDifference
                backCalendarPage.alpha = 1
                
                if index == 0 {
                    
                    if self.userDidGo == .lastMonth {
                        // first calendar page disapear
                        backCalendarPage.transform = CGAffineTransform(scaleX: 1 / scale, y: 1 / scale)
                        backCalendarPage.frame.origin.y += self.setting.newCalendarPageCordiateYDifference
                        backCalendarPage.alpha = 0
                        
                    } else if self.userDidGo == .nextMonth {
                        print("AL")
                        print(self.backCalendarPages[1].subviews.first!.alpha)
                        let interactableCalendarView = self.backCalendarPages[1].subviews.first!
                        backCalendarPage.addSubview(interactableCalendarView)
            
                        backCalendarPage.transform = CGAffineTransform(scaleX: CGFloat(backCalendarPage.transform.currentScale) * scale , y:   CGFloat(backCalendarPage.transform.currentScale) * scale)
                        backCalendarPage.frame.origin.y -= self.setting.newCalendarPageCordiateYDifference
                        
                        
                    }
                   
                } else {
                    
                    if index == 1 {
                        
                        if self.userDidGo == .lastMonth {
                            // send interacable calendar view to second calendar page
                            let interactableCalendarView = self.backCalendarPages.first!.subviews.first!
                            backCalendarPage.addSubview(interactableCalendarView)
                            
                        } else if self.userDidGo == .nextMonth {

                           
                        }
                        
                        
                    }
                        
                        if self.userDidGo == .lastMonth {
                            
                            let r = backCalendarPage.backgroundColor!.value.red + self.setting.calendarPageColorDifference
                            let g = backCalendarPage.backgroundColor!.value.green + self.setting.calendarPageColorDifference
                            let b = backCalendarPage.backgroundColor!.value.blue + self.setting.calendarPageColorDifference
                            backCalendarPage.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1)
                            backCalendarPage.transform = CGAffineTransform(scaleX: CGFloat(backCalendarPage.transform.currentScale) / scale , y: CGFloat(backCalendarPage.transform.currentScale) / scale)
                            backCalendarPage.frame.origin.y += self.setting.newCalendarPageCordiateYDifference
                            
                        } else if self.userDidGo == .nextMonth {
                            
                            let r = backCalendarPage.backgroundColor!.value.red - self.setting.calendarPageColorDifference
                            let g = backCalendarPage.backgroundColor!.value.green - self.setting.calendarPageColorDifference
                            let b = backCalendarPage.backgroundColor!.value.blue - self.setting.calendarPageColorDifference
                            backCalendarPage.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1)
                          
                            backCalendarPage.transform = CGAffineTransform(scaleX: CGFloat(backCalendarPage.transform.currentScale) * scale , y:   CGFloat(backCalendarPage.transform.currentScale) * scale)
                            backCalendarPage.frame.origin.y -= self.setting.newCalendarPageCordiateYDifference
                        }
                    
                    
                    
                    if index == self.backCalendarPages.count - 1 {
                        
                        if self.userDidGo == .nextMonth {
                            backCalendarPage.alpha = 0 // last calendar page disappear
                        }
                    }
                   
                }
            }
        }) { _ in
            
            if self.userDidGo == .lastMonth {
                // remove the first calendar page
                self.backCalendarPages.first!.removeFromSuperview()
                self.backCalendarPages.remove(at: 0)
                
            } else if self.userDidGo == .nextMonth {
                //self.backCalendarPages[1].subviews.first!.removeFromSuperview()
                self.backCalendarPages.last!.removeFromSuperview()
                self.backCalendarPages.remove(at: self.backCalendarPages.count - 1)
            }
           
        }
    }
    
    
    func updateUI() {

        addNewCalendarPage()
        //addTempCalendatPage()
        updateOtherCalendarPages()
        
    }
    
}
extension TimeMachineViewController: CalendarViewDegelagte {
    func calendarCellDidLayout(size: CGSize) {
        
    }
    
    func calendarPageDidGoLastMonth() {
        if calendarViewController != nil {
            userDidGo = calendarViewController!.userDidGo
        }
        
        updateUI()
        
    }
    
    func calendarPageDidGoNextMonth() {
        if calendarViewController != nil {
            userDidGo = calendarViewController!.userDidGo
        }
        updateUI()
    }
    
    func calendarPageDidGoStartMonth() {
        
    }
    
    func calendarPageDidGoThisMonth() {
        
    }
    
    
}
