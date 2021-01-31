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
    var strategy: TimeMachinePagesBehaviorStrategy? = nil
    
    @IBOutlet weak var timeMachineLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationSpeed = self.setting.timeMachineAnimationNormalSpeed
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func initializeCalendarPages() {
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
    
    
    func inlitialize() {
        self.strategy = StillStrategy(viewController: self)
        
        for constraint in self.timeMachineLabel.constraints {
            constraint.isActive = true
        }
        
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
                
                self.initializeCalendarPages()
                self.strategy?.updateCalendarPages()
            }
        }
        
    
    }
    
   
    func updateUI() {
        
        if animationThredIsFinished {
            strategy?.updateCalendarPages()
        }
       
        
    }
    
}
extension TimeMachineViewController: CalendarViewDegelagte {
    func calendarCellDidLayout(size: CGSize) {
        
    }
    
    func calendarPageDidGoLastMonth() {
        self.strategy = ForwardForOneStrategy(viewController: self)
        updateUI()
        
    }
    
    func calendarPageDidGoNextMonth() {
        self.strategy = BackwardForOneStrategy(viewController: self)
        updateUI()
    }
    
    func calendarPageDidGoStartMonth() {
        self.strategy = ForwardForManyStrategy(viewController: self)
        updateUI()
    }
    
    func calendarPageDidGoThisMonth() {
        self.strategy = ForwardForManyStrategy(viewController: self)

    }
    
    
}
