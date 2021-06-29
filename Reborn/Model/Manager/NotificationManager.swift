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
    //            let earlyBodys = ["今天是第\(itemToNotifyUser.finishedDays + 1)天\(itemToNotifyUser.type.rawValue)\(itemToNotifyUser.name)，距离你的目标越来越进了",
    //                               "今天你有\(numberOfInprogressItems)个计划，来看看吧",
    //                               "今天记得\(itemToNotifyUser.type.rawValue)\(itemToNotifyUser.name)，你已经完成了\(itemToNotifyUser.progressInPercentageString)"
    //            ]
    //
    //            let lateBodys =  ["\(currentUser.name), 今天\(itemToNotifyUser.type.rawValue)\(itemToNotifyUser.name)了吗，快来打卡吧",
    //                              "花30秒来打个卡，检查您今天的进度💯",
    //                              "打卡时间到😘",
    //                              "今天打卡了吗？对了别忘了您可以随时使用时间机器补打卡",
    //                              "今天\(numberOfInprogressItems)项任务完成的如何？不要忘记打卡哦"
    //            ]
    
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
       
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        
        if let notificationTime = item.notificationTimes.first {
            let titile = WelcomeText(timeRange: notificationTime.timeRange).firstText
            let body = "今天记得\(item.getFullName()), 您已经\(item.type.rawValue)了\(item.finishedDays)天, 距离目标又进了一步"
            
            switch item.newFrequency {
            case is EveryDay:
                self.addNotification(at: notificationTime, title: titile, body: body, identifier: identifier)
                if item.state != .inProgress {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
                }
            case is EveryWeekdays:
                let weekdays = (item.newFrequency as! EveryWeekdays).weekdays
                for weekday in weekdays {
                    self.addNotification(on: weekday, at: notificationTime, title: titile, body: body, identifier: identifier)
                }
                if item.state == .completed {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
                }
            case is EveryWeek:
                self.addNotification(at: notificationTime, title: titile, body: body, identifier: identifier)
                if item.state != .inProgress || (item.isPunchedIn && item.nextPunchInDate != tommorow) {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
                }
            case is EveryMonth:
                self.addNotification(at: notificationTime, title: titile, body: body, identifier: identifier)
                if item.state != .inProgress || (item.isPunchedIn && item.nextPunchInDate != tommorow) {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
                }
            default: break
            }
        }
    }
    
    func addNotification(on weekday: WeekDay, at time: CustomTime, title: String, body: String, identifier: String) {
        let content = UNMutableNotificationContent()
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
        let soundName = UNNotificationSoundName("DigitalAlarmTwice.m4a")
        content.title = title
        content.body = body
        content.sound = UNNotificationSound(named: soundName)
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
