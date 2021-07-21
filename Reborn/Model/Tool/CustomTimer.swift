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
    fileprivate var storedMilliSeconds: Int = 0
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
    public static var milliSeconds: Int {
        return CustomTimer.shared.storedMilliSeconds
    }
    public static var update: () -> Void = {}
    public static var finish: (() -> Void)? = {}
    public static var state: TimerState {
        
        get {
            return CustomTimer.shared.storedTimerState
        }
        
       
    }
    
    public static func createNew(timer seconds: TimeInterval, update: @escaping () -> Void, finish: (() -> Void)?) {
        
        CustomTimer.shared.storedMinutes = Int(seconds / 60)
        CustomTimer.shared.storedSeconds = Int(seconds.truncatingRemainder(dividingBy: 60))
        CustomTimer.shared.storedMilliSeconds = 0
        CustomTimer.shared.storedTimerState = .running
        CustomTimer.update = update
        CustomTimer.finish = finish
        CustomTimer.shared.timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { timer in
            

            if CustomTimer.shared.storedMilliSeconds <= 0 {
                
               
                
                CustomTimer.update()
                if CustomTimer.shared.storedSeconds <= 0 {
                    
                    CustomTimer.shared.storedMinutes -= 1
                    CustomTimer.shared.storedSeconds = 60
                }
                
                CustomTimer.shared.storedSeconds -= 1
                CustomTimer.shared.storedMilliSeconds = 1000
    
                
                let totolMilliSeconds = CustomTimer.minutes * 60000 + CustomTimer.seconds * 1000 + CustomTimer.milliSeconds
                totolMilliSeconds <= 0 ? killTimer() : ()
                
                
            }
            
            CustomTimer.shared.storedMilliSeconds -= 1
        }
            
           
 
    }
    
    public static func killTimer() {
        print("Timer Killed")
        NotificationManager.shared.removeTemporaryNotification(withIdenifier: "TomatoClock")
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
            let timerOriginalTotalMilliSeconds = UserDefaults.standard.integer(forKey: "TimerOriginalTotalMilliSeconds")
         
            let formatter = DateFormatter()
            formatter.dateFormat = "y-MM-dd H:m:ss.SSSS"
            let timerSavingDate = formatter.date(from: timerSavingDateStr)
            let milliSecondsOfUserBeingInactive = DateCalculator.calculateTimeDifference(from: timerSavingDate!, to: Date())
            
            let totalMilliSecondsDifference = timerOriginalTotalMilliSeconds - milliSecondsOfUserBeingInactive
            
    
            let minutesDifference = Int(totalMilliSecondsDifference / 60000)
            let secondsDifference = Int((totalMilliSecondsDifference % 60000) / 1000)
            let milliSecondsDifference = Int((totalMilliSecondsDifference % 60000) % 1000)
 
            
            if totalMilliSecondsDifference > 0 {
                CustomTimer.shared.storedMinutes = minutesDifference
                CustomTimer.shared.storedSeconds = secondsDifference
                CustomTimer.shared.storedMilliSeconds = milliSecondsDifference
            } else {
                CustomTimer.killTimer()
            }
            
            
        }
        
        UIManager.shared.updateUIAfterTomatoTimerIsRecovered()
  
    }
    
    public static func saveTimer() {
        print("Timer Saved")
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd H:m:ss.SSSS"
        let dateStr = formatter.string(from: Date())
        
        let currentTotalMilliSeconds = CustomTimer.minutes * 60000 + CustomTimer.seconds * 1000 + CustomTimer.milliSeconds

        UserDefaults.standard.set(currentTotalMilliSeconds, forKey: "TimerOriginalTotalMilliSeconds")
        UserDefaults.standard.set(dateStr, forKey: "TimerSavingDate")
        
    }
    
    
}
