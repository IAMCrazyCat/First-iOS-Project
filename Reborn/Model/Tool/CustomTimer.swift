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
    fileprivate var storedOneTenthSeconds: Int = 0
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
    
    public static var seconds: Int {
        return CustomTimer.shared.storedSeconds
    }
    public static var minutes: Int {
        return CustomTimer.shared.storedMinutes
    }
    public static var oneTenthSeconds: Int {
        return CustomTimer.shared.storedOneTenthSeconds
    }
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
        CustomTimer.shared.storedOneTenthSeconds = 10
        CustomTimer.shared.storedTimerState = .running
        CustomTimer.update = update
        CustomTimer.finish = finish
        CustomTimer.shared.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            

            if CustomTimer.shared.storedOneTenthSeconds <= 0 {
                
                if timesOfExecution > Int(seconds) - 1 {
                    CustomTimer.killTimer()
                    
                } else {
                    
                    if CustomTimer.shared.storedSeconds <= 0 {
                        
                        CustomTimer.shared.storedMinutes -= 1
                        CustomTimer.shared.storedSeconds = 60
                    }
                    
                    timesOfExecution += 1
                    CustomTimer.shared.storedSeconds -= 1
                    CustomTimer.update()
                }
                
                CustomTimer.shared.storedOneTenthSeconds = 10
                
            }
            
            CustomTimer.shared.storedOneTenthSeconds -= 1
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
            
            guard let timerSavingDateStr = UserDefaults.standard.string(forKey: "TimerSavingDate") else {return}
            let timerOriginalTotalOneTenthSeconds = UserDefaults.standard.integer(forKey: "TimerOriginalTotalOneTenthSeconds")
            print("WTF!!!!")
            print(timerOriginalTotalOneTenthSeconds)
            let formatter = DateFormatter()
            formatter.dateFormat = "y-MM-dd H:m:ss.SSSS"
            let timerSavingDate = formatter.date(from: timerSavingDateStr)
            //print(formatter.string(from: timerSavingDate!))
            //print(formatter.string(from: Date()))
            let oneTenthSecondsOfUserBeingInactive = DateCalculator.calculateTimeDifference(from: timerSavingDate!, to: Date())
            
            let totalOneTenthSecondsDifference = timerOriginalTotalOneTenthSeconds - oneTenthSecondsOfUserBeingInactive
            
    
            let minutesDifference = Int(totalOneTenthSecondsDifference / 600)
            let secondsDifference = Int((totalOneTenthSecondsDifference % 600) / 10)
            let oneTenthDifference = Int((totalOneTenthSecondsDifference % 600) % 10)
            
  
            print("\(minutesDifference)minites \(secondsDifference)seconds 0.\(oneTenthDifference)seconds")
            
            if totalOneTenthSecondsDifference > 0 {
                CustomTimer.shared.storedMinutes = minutesDifference
                CustomTimer.shared.storedSeconds = secondsDifference
                CustomTimer.shared.storedOneTenthSeconds = oneTenthDifference
            } else {
                CustomTimer.killTimer()
            }
            
            
        }
        
        AppEngine.shared.notifyUIObservers(withIdentifier: "PotatoClockViewController")
  
    }
    
    public static func saveTimer() {
        print("Timer Saved")
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd H:m:ss.SSSS"
        let dateStr = formatter.string(from: Date())
        
        let currentTotalOneTenthSeconds = CustomTimer.minutes * 600 + CustomTimer.seconds * 10 + CustomTimer.oneTenthSeconds

        UserDefaults.standard.set(currentTotalOneTenthSeconds, forKey: "TimerOriginalTotalOneTenthSeconds")
        UserDefaults.standard.set(dateStr, forKey: "TimerSavingDate")
        
    }
    
    
}
