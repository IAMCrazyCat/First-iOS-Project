//
//  TimeMachineViewController.swift
//  Reborn
//
//  Created by Christian Liu on 26/1/21.
//

import UIKit

class TimeMachineViewController: UIViewController {
    
    var calendarView: UIView? = nil
    var calendarViewOriginalPosition: CGPoint?
    var calendarViewController: CalendarViewController?
    
    let setting: SystemStyleSetting = SystemStyleSetting.shared
    var calendarPages: Array<UIView> = []
    var userDidGo: NewCalendarPage = .noWhere
    var animationSpeed: TimeInterval = 0.0
    var strategy: TimeMachineAnimationStrategy? = nil
    
    @IBOutlet weak var goBackToThePastButton: UIButton!
    @IBOutlet weak var timeMachineLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationSpeed = self.setting.timeMachineAnimationNormalSpeed
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goBackToThePastButtonPressed(_ sender: UIButton) {
        
    }
    

    func presentCalendarPages() {
      
        self.strategy = PresentStrategy(timeMachineViewController : self)
        updateUI()
    
    }
    
    func dismissCalendarPages() {
        self.animationSpeed = self.setting.timeMachineAnimationNormalSpeed
        self.strategy = DismissStrategy(timeMachineViewController : self)
        updateUI()
    }
    
    func updateUI() {
        
        self.strategy?.performStrategy()
    }
    
}

extension TimeMachineViewController: CalendarViewDegelagte {
    func calendarCellDidLayout(size: CGSize) {
        
    }
    
    func calendarPageDidGoLastMonth() {
        print("Delegate method called")
        self.animationSpeed = self.setting.timeMachineAnimationNormalSpeed
        self.strategy = ForwardForOneStrategy(timeMachineViewController: self)
        updateUI()
        
    }
    
    func calendarPageDidGoNextMonth() {
        self.animationSpeed = self.setting.timeMachineAnimationNormalSpeed
        self.strategy = BackwardForOneStrategy(timeMachineViewController: self)
        updateUI()
    }
    
    func calendarPageDidGoStartMonth() {
        self.animationSpeed = self.setting.timeMachineAnimationFastSpeed
        if let monthInterval = self.calendarViewController?.storedMonthInterval, monthInterval < 0 {
            self.strategy = ForwardForManyStrategy(timeMachineViewController: self)
            
        } else if let monthInterval = self.calendarViewController?.storedMonthInterval, monthInterval > 0 {
            self.strategy = BackwardForManyStrategy(timeMachineViewController: self)
        } else {
            self.strategy = EnlargeStrategy(timeMachineViewController: self)
        }
        
        updateUI()
    }
    
    func calendarPageDidGoThisMonth() {
        self.animationSpeed = self.setting.timeMachineAnimationFastSpeed
        if let monthInterval = self.calendarViewController?.storedMonthInterval, monthInterval < 0 {
            self.strategy = ForwardForManyStrategy(timeMachineViewController: self)
            
        } else if let monthInterval = self.calendarViewController?.storedMonthInterval, monthInterval > 0 {
            self.strategy = BackwardForManyStrategy(timeMachineViewController: self)
        } else {
            self.strategy = EnlargeStrategy(timeMachineViewController: self)
        }
        updateUI()
    }
    
    
}
