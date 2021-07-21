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
    var calendarViewController: CalendarViewController!
    let engine: AppEngine = AppEngine.shared
    let setting: SystemSetting = SystemSetting.shared
    var calendarPages: Array<UIView> = []
    var userDidGo: NewCalendarPage = .noWhere
    var animationSpeed: TimeInterval = 0.0
    var strategy: TimeMachineAnimationStrategy? = nil
    
    var currentItemProgress: Double {
        return calendarViewController.item.getProgress()
    }
    var newItemProgress: Double {
        return (Double(calendarViewController.item.getFinishedDays()) + Double(calendarViewController.selectedDays)) / Double(calendarViewController.item.targetDays)
    }

    var currentProgressInString: String {
        return "\((currentItemProgress * 100).round(toPlaces: 1))%"
    }
    var newProgressInString: String {
        return "\((newItemProgress * 100).round(toPlaces: 1))%"
    }
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var goBackToThePastButton: UIButton?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var energyButton: UIButton?
    @IBOutlet weak var promptLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        engine.add(observer: self)
        animationSpeed = self.setting.timeMachineAnimationNormalSpeed
        
        titleLabel.textColor = AppEngine.shared.userSetting.themeColor.uiColor
       
        updateEnergyLabel()
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        calendarViewController.punchInMakingUpDates.removeAll()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goBackToThePastButtonPressed(_ sender: UIButton) {

       
        Vibrator.vibrate(withNotificationType: .success)
        self.dismiss(animated: true) {
            let makingUpDates = self.calendarViewController.punchInMakingUpDates
            let item = self.calendarViewController.item!
            
            item.add(punchInDates: makingUpDates, finish: {
                self.engine.currentUser.energy -= self.calendarViewController.selectedDays
                self.calendarViewController.punchInMakingUpDates.removeAll()
                self.engine.saveUser()
                UIManager.shared.updateUIAfterTimeMachineWasUsed(item)
            })
            
            self.calendarViewController.userDidGo = .sameMonth
            
           
            
            if let currentVC = UIApplication.shared.getCurrentViewController() {
                if self.calendarViewController.item.state == .completed {
                    currentVC.presentItemCompletedPopUp(for: self.calendarViewController.item)
                }
            }
        }
        
        
    }

    public func presentCalendarPages() {
        
        self.strategy = PresentStrategy(timeMachineViewController : self)
        //self.calendarViewController.lastViewController = self
        updateUI()
        
    }
    
    public func dismissCalendarPages() {
        self.calendarViewController.userDidGo = .sameMonth
        self.calendarViewController.state = .normal
        self.animationSpeed = self.setting.timeMachineAnimationNormalSpeed
        self.strategy = DismissStrategy(timeMachineViewController : self)

        updateUI()
    }
    
    func updateEnergyLabel() {
    
        if calendarViewController.selectedDays <= 0 {
            self.energyButton?.setTitle(" × \(self.engine.currentUser.energy)", for: .normal)

        } else {

            let attrs = [NSAttributedString.Key.foregroundColor: self.engine.currentUser.energy < self.calendarViewController.selectedDays ? UIColor.red : .label]
            
            let normalText = " × \(self.engine.currentUser.energy) → "
            let mutableText = "\(self.engine.currentUser.energy - self.calendarViewController.selectedDays)"
            let mutableString = NSMutableAttributedString(string: mutableText, attributes: attrs)
            let normalString = NSMutableAttributedString(string: normalText)
            
            normalString.append(mutableString)
            self.energyButton?.setAttributedTitle(normalString, for: .normal)
            //self.energyButton?.setTitleColor( ? .label : .red, for: .normal)
        }

        
    }
    
    func userSlectedDate() -> Bool {
        return calendarViewController.selectedDays > 0
    }
    
    func userSelectedTooManyDate() -> Bool {
        return newItemProgress > 1
    }
    
    func userHasNotEnoughEnergy() -> Bool {
        return AppEngine.shared.currentUser.energy < calendarViewController.selectedDays
    }
    
    func updateGoBackToThePastButton() {
        
        goBackToThePastButton?.setCornerRadius()
        goBackToThePastButton?.setShadow(style: .button)
        goBackToThePastButton?.setSmartColor()
        goBackToThePastButton?.setBackgroundColor(.systemGray3, for: .disabled)
        goBackToThePastButton?.isEnabled = userSlectedDate() ? true : false
        
        
        if !userSlectedDate() {
            goBackToThePastButton?.isEnabled = false
            goBackToThePastButton?.setTitle("回到过去", for: .normal)
        } else {
            
            let attrs = [NSAttributedString.Key.foregroundColor: newItemProgress > 1 ? UIColor.red : newItemProgress == 1 ? UIColor.green : AppEngine.shared.userSetting.smartLabelColor]
            
            let normalText = "回到过去 项目进度: \(currentProgressInString) → "
            let mutableText = "\(newProgressInString)"
            let mutableString = NSMutableAttributedString(string: mutableText, attributes: attrs)
            let normalString = NSMutableAttributedString(string: normalText)
            
            normalString.append(mutableString)
            
            goBackToThePastButton?.setAttributedTitle(normalString, for: .normal)
            
            if userSelectedTooManyDate() || userHasNotEnoughEnergy() {
                goBackToThePastButton?.isEnabled = false
            } else {
                goBackToThePastButton?.isEnabled = true
            }
            
            
            
        }
        
        
        
        
        

       
        
    }
    
    func updatePromptLabel() {
        
        
        if userSelectedTooManyDate() {
            promptLabel?.text = "请选择更少的补打卡天数"
            promptLabel?.textColor = .systemRed
        } else {
            
            if userHasNotEnoughEnergy() {
                promptLabel?.text = "能量不足，请获得更多的能量"
                promptLabel?.textColor = .systemRed
            } else {
                promptLabel?.text = "请选择您想补打卡的日期"
                promptLabel?.textColor = .label
            }
            
            
            
        }
    }
    
    func updateStrategy() {
        self.strategy?.performStrategy()
        self.strategy = nil
    }
    

    
}

extension TimeMachineViewController: UIObserver {
    func updateUI() {

        updateGoBackToThePastButton()
        updateEnergyLabel()
        updateGoBackToThePastButton()
        updatePromptLabel()
        updateStrategy()
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
        
        let originalDate = CustomDate(year: self.calendarViewController.currentCalendarPage.year, month: self.calendarViewController.currentCalendarPage.month, day: 1)
        let newDate = self.calendarViewController.item.creationDate
        let monthInterval = DateCalculator.calculateMonthDifference(withOriginalDate: originalDate, andNewDate: newDate)
        
        self.animationSpeed = self.setting.timeMachineAnimationFastSpeed
        if monthInterval < 0 {
            self.strategy = ForwardForManyStrategy(timeMachineViewController: self, numberOfMovingPages: abs(monthInterval))
        } else if monthInterval > 0 {
            self.strategy = BackwardForManyStrategy(timeMachineViewController: self, numberOfMovingPages: abs(monthInterval))
        }
        updateUI()
    }
    
    func calendarPageDidGoThisMonth() {
        
        let originalDate = CustomDate(year: self.calendarViewController.currentCalendarPage.year, month: self.calendarViewController.currentCalendarPage.month, day: 1)
        let newDate = CustomDate.current
        let monthInterval = DateCalculator.calculateMonthDifference(withOriginalDate: originalDate, andNewDate: newDate)
        
        self.animationSpeed = self.setting.timeMachineAnimationFastSpeed
        
        if monthInterval < 0 {
            self.strategy = ForwardForManyStrategy(timeMachineViewController: self, numberOfMovingPages: abs(monthInterval))
        } else if monthInterval > 0 {
            self.strategy = BackwardForManyStrategy(timeMachineViewController: self, numberOfMovingPages: abs(monthInterval))
        }
        updateUI()
    }
    
    func calendarPageDidGoSameMonth() {
        self.strategy = EnlargeStrategy(timeMachineViewController: self)
        updateUI()
    }
    
    
}
