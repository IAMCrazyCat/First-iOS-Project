//
//  CustomTimer.swift
//  Reborn
//
//  Created by Christian Liu on 31/3/21.
//

import Foundation
enum TimerState: String {
    case running = "running"
    case idle = "idle"
}

class CustomTimer {
    
    fileprivate var storedSeconds: Int = 0
    fileprivate var storedMinutes: Int = 0
    public static var seconds: Int {
        return CustomTimer.shared.storedSeconds
    }
    public static var minutes: Int {
        return CustomTimer.shared.storedMinutes
    }
    fileprivate var timer: Timer = Timer()
    fileprivate var storedTimerState: TimerState = .idle {
        didSet {
            if CustomTimer.shared.storedTimerState == .idle {
                CustomTimer.shared.storedSeconds = 0
                CustomTimer.shared.storedMinutes = 0
            }
        }
    }
    fileprivate static var shared = CustomTimer()
    public static var update: () -> Void = {}
    public static var finish: (() -> Void)? = {}
    public static var state: TimerState {
        
        get {
            return CustomTimer.shared.storedTimerState
        }
        
       
    }
    
    public static func createNew(timer seconds: TimeInterval, update: @escaping () -> Void, finish: (() -> Void)?) {
        
        
        var timesOfExecution: Int = 0
        
        CustomTimer.shared.storedMinutes = Int(seconds / 60)
        CustomTimer.shared.storedSeconds = Int(seconds.truncatingRemainder(dividingBy: 60))
        
        CustomTimer.shared.storedTimerState = .running
        CustomTimer.update = update
        CustomTimer.finish = finish
        CustomTimer.shared.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            

            if timesOfExecution > Int(seconds) - 1 {

                timer.invalidate()
                CustomTimer.shared.storedTimerState = .idle
                if CustomTimer.finish != nil {
                    CustomTimer.finish!()
                }
                
                
            } else {
                
                if CustomTimer.shared.storedSeconds <= 0 {
                    
                    CustomTimer.shared.storedMinutes -= 1
                    CustomTimer.shared.storedSeconds = 60
                }
                
                timesOfExecution += 1
                CustomTimer.shared.storedSeconds -= 1
                CustomTimer.update()
            }
        }
 
    }
    
    public static func killTimer() {
        print("Timer Killed")
        AppEngine.shared.removeTemporaryNotification(withIdenifier: "TomatoClock")
        CustomTimer.shared.timer.invalidate()
        CustomTimer.shared.storedTimerState = .idle
        CustomTimer.finish?()
    }
    
    public static func recoverTimer() {
        
        print("Timer Rcovered")
        if let state = UserDefaults.standard.string(forKey: "TimerState") {
            if state == "running" {
                CustomTimer.shared.storedTimerState = .running
            } else {
                CustomTimer.shared.storedTimerState = .idle
            }
        }
        
        if CustomTimer.state == .running {
            
            let timerOriginalMinutes = UserDefaults.standard.integer(forKey: "TimerSavedMinutes")
            let timerOriginalSeconds = UserDefaults.standard.integer(forKey: "TimerSavedSeconds")
            guard let timerSavedTime = UserDefaults.standard.customTime(for: "TimerSavedTime"),
                  let timerSavedDate =  UserDefaults.standard.customDate(for: "TimerSavedDate")
            else {
                return
            }

            let secondsOfUserBeingInactive = DateCalculator.calculateTimeDifferenceBetween(timerSavedTime, and: CustomTime.current)
            
            let timerOriginalTotalSeconds = timerOriginalMinutes * 60 + timerOriginalSeconds

            let totalSecondsDifference = timerOriginalTotalSeconds - secondsOfUserBeingInactive
            let minutesDifference = totalSecondsDifference > 60 ? Int(totalSecondsDifference / 60) : 0
            let secondsDifference = totalSecondsDifference > 0 ? Int(totalSecondsDifference % 60) : 0
            
            if DateCalculator.calculateDayDifferenceBetween(timerSavedDate, and: CustomDate.current) > 0 {
                CustomTimer.killTimer()
                
            } else {
                
                if totalSecondsDifference > 0 {
                    CustomTimer.shared.storedMinutes = minutesDifference
                    CustomTimer.shared.storedSeconds = secondsDifference
                } else {
                    CustomTimer.killTimer()
                }
                
                
            }
            
            
        }
        
        
        
        
        
       
    }
    
    public static func saveTimer() {
        print("Timer Saved")
        UserDefaults.standard.set(CustomTimer.state.rawValue, forKey: "TimerState")
        UserDefaults.standard.set(CustomTimer.minutes, forKey: "TimerSavedMinutes")
        UserDefaults.standard.set(CustomTimer.seconds, forKey: "TimerSavedSeconds")
        UserDefaults.standard.set(CustomTime.current, forKey: "TimerSavedTime")
        UserDefaults.standard.set(CustomDate.current, forKey: "TimerSavedDate")
    }
    
    
}
