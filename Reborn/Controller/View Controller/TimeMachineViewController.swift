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
    let engine: AppEngine = AppEngine.shared
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
    @IBOutlet weak var energyButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        engine.add(observer: self)
        animationSpeed = self.setting.timeMachineAnimationNormalSpeed
        
        titleLabel.textColor = AppEngine.shared.userSetting.themeColor.uiColor
        goBackToThePastButton.layer.cornerRadius = self.setting.mainButtonCornerRadius
        goBackToThePastButton.setShadow()
        goBackToThePastButton.setBackgroundColor(AppEngine.shared.userSetting.themeColor.uiColor, for: .normal)
        goBackToThePastButton.setBackgroundColor(.gray, for: .disabled)
       
        updateEnergyLabel()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        calendarViewController?.punchInMakingUpDates.removeAll()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goBackToThePastButtonPressed(_ sender: UIButton) {

       
        Vibrator.vibrate(withNotificationType: .success)
        self.dismiss(animated: true) {
            guard let makingUpDates = self.calendarViewController?.punchInMakingUpDates,
                  let item = self.calendarViewController?.item else { return }
            
            self.engine.currentUser.add(punchInDates: makingUpDates, to: item)
            self.calendarViewController?.punchInMakingUpDates.removeAll()
            self.engine.saveUser()
            self.engine.notifyAllUIObservers()
        }
        
        
    }

    public func presentCalendarPages() {
        
        self.strategy = PresentStrategy(timeMachineViewController : self)
        //self.calendarViewController?.lastViewController = self
        updateUI()
        
    }
    
    public func dismissCalendarPages() {
        self.calendarViewController?.userDidGo = .sameMonth
        self.calendarViewController?.state = .normal
        self.animationSpeed = self.setting.timeMachineAnimationNormalSpeed
        self.strategy = DismissStrategy(timeMachineViewController : self)

        updateUI()
    }
    
    func updateEnergyLabel() {
       
        self.energyButton?.setTitle(" × \(self.engine.currentUser.energy)", for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
  
    
}

extension TimeMachineViewController: UIObserver {
    func updateUI() {
        print("YES")
        updateEnergyLabel()
        self.strategy?.performStrategy()
        self.strategy = nil
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
    
    func calendarPageDidGoSameMonth() {
        self.strategy = EnlargeStrategy(timeMachineViewController: self)
        updateUI()
    }
    
    
}
