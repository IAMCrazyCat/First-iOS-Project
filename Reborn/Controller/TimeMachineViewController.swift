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
    var calendarPages: Array<UIView> = []
    var userDidGo: NewCalendarPage = .noWhere
    var animationSpeed: TimeInterval = 0.0
    
    var animationThredIsFinished: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        animationSpeed = self.setting.timeMachineAnimationNormalSpeed
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateCalendarPagesColor() {
        var r: CGFloat = 1
        var g: CGFloat = 1
        var b: CGFloat = 1
        
        if userDidGo == .noWhere || userDidGo == .nextMonth  {
            for index in 0 ... calendarPages.count - 1 {
                
                let calendarPage = calendarPages[index]
                calendarPage.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1)
                
                r -= self.setting.calendarPageColorDifference
                g -= self.setting.calendarPageColorDifference
                b -= self.setting.calendarPageColorDifference
               
            }
        }
        
        if userDidGo == .lastMonth {
            
            for index in 1 ... calendarPages.count - 1 {
                
                let calendarPage = calendarPages[index]
                calendarPage.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1)
                
                r -= self.setting.calendarPageColorDifference
                g -= self.setting.calendarPageColorDifference
                b -= self.setting.calendarPageColorDifference
               
            }
        }
 
    }
    
    func addCalendarPages() {
        var scale: CGFloat = 1
        var cordinateYDifference = self.setting.newCalendarPageCordiateYDifference
        
        for index in 0 ... self.setting.numberOfCalendarPages - 2 {
            
           
            
            scale *= self.setting.newCalendarPageSizeDifference
            let newCalendarPage = UIView()
            newCalendarPage.backgroundColor = self.setting.calendarPageColor
            newCalendarPage.frame = self.calendarPages[0].frame
            newCalendarPage.transform = CGAffineTransform(scaleX: scale, y: scale)
            newCalendarPage.layer.cornerRadius = self.setting.itemCardCornerRadius
            newCalendarPage.setViewShadow()
            
            
            self.view.insertSubview(newCalendarPage, belowSubview: self.calendarPages[index])
            
            UIView.animate(withDuration: self.animationSpeed, delay: 0, options: .curveEaseOut, animations: {
                newCalendarPage.frame.origin.y -= cordinateYDifference
            
            })
            
            self.calendarPages.append(newCalendarPage)
            cordinateYDifference += self.setting.newCalendarPageCordiateYDifference
            

        }
    }
    
    
    func inlitializeUI() {
        
        if calendarView != nil {
            
            self.view.addSubview(calendarView!)
            self.calendarView!.frame.origin = calendarViewPosition!
            self.calendarView!.layer.cornerRadius = self.setting.itemCardCornerRadius
            self.calendarView!.layer.masksToBounds = true
            self.calendarView!.setViewShadow()
            self.calendarPages.append(calendarView!)
            
           
            
            UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseOut, animations: {

                self.calendarView!.frame.origin.y = self.setting.screenFrame.height / 2 -  self.calendarView!.frame.height / 2
            }) { _ in
                
                self.addCalendarPages()
                self.updateCalendarPagesColor()
            }
        }
        
    
    }
    
    
    func addNewCalendarPage() { // add new calendar page to the front or back
        
        if userDidGo == .lastMonth {
            let newCalendarPage = UIView()
            let scale = CGFloat(pow(Double(self.setting.newCalendarPageSizeDifference), Double(self.calendarPages.count)))

            
            newCalendarPage.frame = self.calendarPages.first!.frame // new calendar page frame equals to the first page
            newCalendarPage.frame.origin.y =  self.calendarPages.first!.frame.origin.y - self.setting.newCalendarPageCordiateYDifference * CGFloat(self.calendarPages.count) // move up the new calendar page to its proper position Y
            newCalendarPage.transform =  CGAffineTransform(scaleX: scale, y: scale) // scale it accroding to first page to its proper size
            
            // set style
            newCalendarPage.backgroundColor = self.setting.calendarPageColor
            newCalendarPage.alpha = 0
            newCalendarPage.layer.cornerRadius = self.setting.itemCardCornerRadius
            newCalendarPage.setViewShadow()

            self.view.insertSubview(newCalendarPage, belowSubview: self.calendarPages.last!)
            self.calendarPages.append(newCalendarPage)
            
        } else if userDidGo == .nextMonth {
            
            let newCalendarPage = UIView()
            let scale = 1 / self.setting.newCalendarPageSizeDifference // new page is one unit larger than first page
            newCalendarPage.backgroundColor = self.setting.calendarPageColor
            newCalendarPage.frame = self.calendarPages.first!.frame
            newCalendarPage.frame.origin.y =  self.calendarPages.first!.frame.origin.y + self.setting.newCalendarPageCordiateYDifference
            newCalendarPage.transform =  CGAffineTransform(scaleX: scale, y: scale) // scale it accroding to first page to its proper size
            
            newCalendarPage.alpha = 0
            newCalendarPage.layer.cornerRadius = self.setting.itemCardCornerRadius
            newCalendarPage.setViewShadow()
            
            self.view.insertSubview(newCalendarPage, aboveSubview: self.calendarPages.first!)
            self.calendarPages.insert(newCalendarPage, at: 0)
        }
       
    }
    
    func removeOldTempCalendarPage(superview: UIView) {
        for subview in superview.subviews {
            if subview.accessibilityIdentifier == "TempCalendarPageView" {
                subview.removeFromSuperview()
            }
           
        }
    }
    
    func addTempCalendarPage() {
        
        if calendarViewController != nil {
           
            
            if userDidGo == .lastMonth {
                
                let builder = TimeMachineCalendarPageBuilder(interactableCalendarView: self.calendarPages.first!.subviews.first!, calendarViewController: self.calendarViewController!, userDidGo: userDidGo)
                let tempCalendarPage = builder.buildCalendarPage()
                tempCalendarPage.accessibilityIdentifier = "TempCalendarPageView"
                
                self.removeOldTempCalendarPage(superview: self.calendarPages.first!)
                self.calendarPages.first!.addSubview(tempCalendarPage) // add temp calendar page to that will disapear
                
            } else if userDidGo == .nextMonth {
                
                let builder = TimeMachineCalendarPageBuilder(interactableCalendarView: self.calendarPages[1].subviews.first!, calendarViewController: self.calendarViewController!, userDidGo: userDidGo)
                let tempCalendarPage = builder.buildCalendarPage()
                tempCalendarPage.accessibilityIdentifier = "TempCalendarPageView"
                self.removeOldTempCalendarPage(superview: self.calendarPages[1])
                self.calendarPages[1].addSubview(tempCalendarPage) // add temp calendar page to that will disapear
            }
            
           
        }
    }
    
    func updateOtherCalendarPages() {
        
        self.animationThredIsFinished = false
        print(self.animationSpeed)
        UIView.animate(withDuration: self.animationSpeed, delay: 0, options: .curveLinear, animations: {
            
               for index in 0 ... self.calendarPages.count - 1 {
                
                let backCalendarPage = self.calendarPages[index]
                let scale: CGFloat = self.setting.newCalendarPageSizeDifference
                backCalendarPage.alpha = 1
                
                if index == 0 {
                    
                    if self.userDidGo == .lastMonth {
                        // first calendar page disapear
                        backCalendarPage.transform = CGAffineTransform(scaleX: 1 / scale, y: 1 / scale)
                        backCalendarPage.frame.origin.y += self.setting.newCalendarPageCordiateYDifference
                        backCalendarPage.alpha = 0
                        
                    } else if self.userDidGo == .nextMonth {
                       
                        let interactableCalendarView = self.calendarPages[1].subviews.first!
                        backCalendarPage.insertSubview(interactableCalendarView, at: backCalendarPage.subviews.count)
            
                        backCalendarPage.transform = CGAffineTransform(scaleX: CGFloat(backCalendarPage.transform.currentScale) * scale , y:   CGFloat(backCalendarPage.transform.currentScale) * scale)
                        backCalendarPage.frame.origin.y -= self.setting.newCalendarPageCordiateYDifference
                        
                        
                    }
                   
                } else {
                    
                    if index == 1 {
                        
                        if self.userDidGo == .lastMonth {
                            // send interacable calendar view to second calendar page
                            let interactableCalendarView = self.calendarPages.first!.subviews.first!
                            //backCalendarPage.addSubview(interactableCalendarView)
                       
                            backCalendarPage.insertSubview(interactableCalendarView, at: backCalendarPage.subviews.count)
                        } else if self.userDidGo == .nextMonth {

                           
                        }
                        
                        
                    }
                        
                        if self.userDidGo == .lastMonth {
                            

            
                            backCalendarPage.transform = CGAffineTransform(scaleX: CGFloat(backCalendarPage.transform.currentScale) / scale , y: CGFloat(backCalendarPage.transform.currentScale) / scale)
                            backCalendarPage.frame.origin.y += self.setting.newCalendarPageCordiateYDifference
                            
                        } else if self.userDidGo == .nextMonth {
                            


                            backCalendarPage.transform = CGAffineTransform(scaleX: CGFloat(backCalendarPage.transform.currentScale) * scale , y:   CGFloat(backCalendarPage.transform.currentScale) * scale)
                            backCalendarPage.frame.origin.y -= self.setting.newCalendarPageCordiateYDifference
                        }
                    
                    
                    
                    if index == self.calendarPages.count - 1 {
                        
                        if self.userDidGo == .nextMonth {
                            backCalendarPage.alpha = 0 // last calendar page disappear
                        }
                    }
                   
                }
            }
        }) { _ in
            
            if self.userDidGo == .lastMonth {
                // remove the first calendar page
                self.calendarPages.first!.removeFromSuperview()
                self.calendarPages.remove(at: 0)
                
            } else if self.userDidGo == .nextMonth {
                //self.backCalendarPages[1].subviews.first!.removeFromSuperview()
                self.calendarPages.last!.removeFromSuperview()
                self.calendarPages.remove(at: self.calendarPages.count - 1)
            }
            
            self.animationThredIsFinished = true
           
        }
    }
    
    
    func updateUI() {
        
        if calendarViewController != nil {
            userDidGo = calendarViewController!.userDidGo
        }
        
        if animationThredIsFinished {
            addNewCalendarPage()
            addTempCalendarPage()
            updateOtherCalendarPages()
            updateCalendarPagesColor()
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
       
        updateUI()
    }
    
    func calendarPageDidGoStartMonth() {
        //self.animationSpeed = self.setting.timeMachineAnimationFastSpeed
        updateUI()
    }
    
    func calendarPageDidGoThisMonth() {
        
    }
    
    
}
