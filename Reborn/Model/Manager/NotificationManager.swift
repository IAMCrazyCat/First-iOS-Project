//
//  NotificationManager.swift
//  Reborn
//
//  Created by Christian Liu on 10/6/21.
//

import Foundation
import UIKit

class NotificationManager {
    private let defaults = UserDefaults.standard
    public static let shared = NotificationManager()
    let defaultSound = UNNotificationSound.default
    let customSound = UNNotificationSound(named: UNNotificationSoundName("DigitalAlarmTwice.m4a"))
    let earlyBodys = ["新的一天开始了，来看看今天有几项习惯需要完成",
                       "今天一定要更自律，来看看今日任务",
                       "我在记录你的改变，来看看你这几天的习惯完成度"
    ]
    
    let lateBodys =  ["花30秒来打个卡，检查您今天的进度💯",
                      "打卡时间到😘",
                      "今天打卡了吗？别忘了您还可以使用时间机器补打卡",
                      "今天任务完成的如何？不要忘记打卡哦"
    ]
    
    
    private init() {
        
    }
    
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("App has notification permission")
            } else {
                print("App does not have notification permission")
            }
        }
    }
    
    func isNotificationEnabled() -> Bool {
        var isNotificationEnabled = false
        let semaphore = DispatchSemaphore(value: 0)
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            
          if settings.authorizationStatus == .authorized {
            isNotificationEnabled = true
          }
          else {
            isNotificationEnabled = false
          }
            semaphore.signal()
        }
        
        semaphore.wait()
        return isNotificationEnabled
       
    }
    
    func removeAllNotification(of item: Item) {
        let identifier = "Item\(item.ID)Notification"

        switch item.newFrequency.type {
        case .everyWeekdays:
            var identifiers: Array<String> = []
            for weekday in (item.newFrequency as! EveryWeekdays).weekdays {
                identifiers.append(identifier + String(weekday.rawValue))
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        default:  UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        }
    }
    
    func scheduleFixedNotification(at times: [CustomTime]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["FixedNotification"])

        for time in times {
            DispatchQueue.main.async {
                let earlyTitle = WelcomeText(timeRange: time.timeRange).firstText
                let earlyBody = self.earlyBodys.random!
                let lateTitle = SharePosterTextData.randomText
                let lateBody = self.lateBodys.random!
            
                let titile = time < CustomTime(hour: 18, minute: 0, second: 0, oneTenthSecond: 0) ? earlyTitle : lateTitle
                let body = time < CustomTime(hour: 14, minute: 0, second: 0, oneTenthSecond: 0) ? earlyBody : lateBody
                self.addNotification(at: time, title: titile, body: body, identifier: "FixedNotification")
            }
        }
            
    }
    
    func scheduleNotification(for item: Item) {
        let tommorow = DateCalculator.calculateDate(withDayDifference: 1, originalDate: CustomDate.current)
        let identifier = "Item\(item.ID)Notification"
        self.removeAllNotification(of: item)
        
        if let notificationTime = item.notificationTimes.first {
            let titile = WelcomeText(timeRange: notificationTime.timeRange).firstText
            let body = "今天记得\(item.getFullName()), 您已经\(item.type.rawValue)了\(item.getFinishedDays())天, 距离目标又进了一步"
            
            switch item.newFrequency {
            case is EveryDay:
                
                if item.state != .inProgress {

                } else {
                    self.addNotification(at: notificationTime, title: titile, body: body, identifier: identifier)
                }
            case is EveryWeekdays:
                
                if item.state == .completed {
                    
                } else {
                    let weekdays = (item.newFrequency as! EveryWeekdays).weekdays
                    for weekday in weekdays {
                        self.addNotification(on: weekday, at: notificationTime, title: titile, body: body, identifier: identifier + String(weekday.rawValue))
                    }
                }
            case is EveryWeek:
                
                if item.state != .inProgress || item.getNextPunchInDate(isPunchedIn: true) != tommorow {
                    
                    if let nextPunchInDate = item.getNextPunchInDate(isPunchedIn: true) {
                        addNotification(on: nextPunchInDate, at: notificationTime, title: titile, body: body, identifier: identifier)
                    }

                } else {
                    self.addNotification(at: notificationTime, title: titile, body: body, identifier: identifier)
                }
            case is EveryMonth:
               
                if item.state != .inProgress || item.getNextPunchInDate(isPunchedIn: true) != tommorow {
                    
                    if let nextPunchInDate = item.getNextPunchInDate(isPunchedIn: true) {
                        addNotification(on: nextPunchInDate, at: notificationTime, title: titile, body: body, identifier: identifier)
                    }
                    
                } else {
                    self.addNotification(at: notificationTime, title: titile, body: body, identifier: identifier)
                }
            default: break
            }
        }
    }
    
    func addNotification(on date: CustomDate, at time: CustomTime, title: String, body: String, identifier: String) {
        let content = UNMutableNotificationContent()
        content.sound = self.defaultSound
        content.title = title
        content.body = body
        content.badge = 1
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.month = date.month
        dateComponents.day = date.day
        dateComponents.hour = time.hour
        dateComponents.minute = time.minute
        
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        // Create the request
        let request = UNNotificationRequest(identifier: identifier,
                    content: content, trigger: trigger)

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.add(request) { (error) in
           if error != nil {
              print("Notification schedule failed, No user permission")
           } else {
              print("Notification schedule successfully")
           }
        }
    }
    
    func addNotification(on weekday: WeekDay, at time: CustomTime, title: String, body: String, identifier: String) {
        let content = UNMutableNotificationContent()
        content.sound = self.defaultSound
        content.title = title
        content.body = body
        content.badge = 1
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.hour = time.hour
        dateComponents.minute = time.minute
        dateComponents.weekday = weekday.originalWeekday
        
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        // Create the request
        let request = UNNotificationRequest(identifier: identifier,
                    content: content, trigger: trigger)

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.add(request) { (error) in
           if error != nil {
              print("Notification schedule failed, No user permission")
           } else {
              print("Notification schedule successfully, Weekday:\(weekday) time: \(time) identifier: \(identifier)")
           }
        }
    }
    
    
    
    func addNotification(at time: CustomTime, title: String, body: String, identifier: String) {
        
        let content = UNMutableNotificationContent()
        content.sound = self.defaultSound
        content.title = title
        content.body = body
        content.badge = 1
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.hour = time.hour
        dateComponents.minute = time.minute
        
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier,
                    content: content, trigger: trigger)

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.add(request) { (error) in
           if error != nil {
              print("Notification schedule failed, No user permission")
           } else {
              print("Notification schedule successfully")
           }
        }
    }
    
    
    
    func scheduleTemporaryNotification(title: String, body: String, after timeInterval: TimeInterval, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = self.customSound
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
           if let error = error{
               print("Error posting notification:\(error.localizedDescription)")
           } else{
               print("notification scheduled")
           }
        }
    }
    
    func removeTemporaryNotification(withIdenifier identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    public func saveLastNotificationStatus() {
        let lastStatus: Bool = self.isNotificationEnabled()
        defaults.set(lastStatus, forKey: "NotificationStatus")
    }
    
    private func loadLastNotificationStatus() -> Bool {
        return defaults.bool(forKey: "NotificationStatus")
    }
    
    public func isNotificationStatusChanged() -> Bool {
        if isNotificationEnabled() != loadLastNotificationStatus() {
            return true
        } else {
            return false
        }
    }
    
}
