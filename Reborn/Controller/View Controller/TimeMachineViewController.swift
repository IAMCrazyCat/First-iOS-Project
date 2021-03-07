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
    
    let setting: SystemSetting = SystemSetting.shared
    var calendarPages: Array<UIView> = []
    var userDidGo: NewCalendarPage = .noWhere
    var animationSpeed: TimeInterval = 0.0
    var strategy: TimeMachineAnimationStrategy? = nil
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var goBackToThePastButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationSpeed = self.setting.timeMachineAnimationNormalSpeed
        
        titleLabel.textColor = AppEngine.shared.userSetting.themeColor
        goBackToThePastButton.layer.cornerRadius = self.setting.mainButtonCornerRadius
        goBackToThePastButton.setShadow()
        goBackToThePastButton.setBackgroundColor(AppEngine.shared.userSetting.themeColor, for: .normal)
        goBackToThePastButton.setBackgroundColor(.gray, for: .disabled)
 
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goBackToThePastButtonPressed(_ sender: UIButton) {
        
        Vibrator.vibrate(withNotificationType: .success)
        self.dismiss(animated: true, completion: nil)
    }

    public func presentCalendarPages() {
        
        self.strategy = PresentStrategy(timeMachineViewController : self)
        updateUI()
    
    }
    
    public func dismissCalendarPages() {
        self.calendarViewController?.userDidGo = .noWhere
        self.calendarViewController?.state = .normal
        self.animationSpeed = self.setting.timeMachineAnimationNormalSpeed
        self.strategy = DismissStrategy(timeMachineViewController : self)
        updateUI()
    }
    
  
    
}

extension TimeMachineViewController: UIObserver {
    func updateUI() {
        //timeMachineLabel.tintColor = AppEngine.shared.userSetting.themeColor
        //goBackToThePastButton.setBackgroundColor(AppEngine.shared.userSetting.themeColor, for: .normal)
        
        self.strategy?.performStrategy()
    }
}

extension TimeMachineViewController: CalendarViewDegelagte {
    func calendarCellDidLayout(size: CGSize) {
        
    }
    
    func calendarPageDidGoLastMonth() {
    
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
        }
        updateUI()
    }
    
    func calendarPageDidGoThisMonth() {
        self.animationSpeed = self.setting.timeMachineAnimationFastSpeed
        if let monthInterval = self.calendarViewController?.storedMonthInterval, monthInterval < 0 {
            self.strategy = ForwardForManyStrategy(timeMachineViewController: self)
            
        } else if let monthInterval = self.calendarViewController?.storedMonthInterval, monthInterval > 0 {
            self.strategy = BackwardForManyStrategy(timeMachineViewController: self)
        }
        updateUI()
    }
    
    func calendarPageDidGoNowhere() {
        self.strategy = EnlargeStrategy(timeMachineViewController: self)
        updateUI()
    }
    
    
}
