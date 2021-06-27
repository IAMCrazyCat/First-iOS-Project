//
//  NotificationManager.swift
//  Reborn
//
//  Created by Christian Liu on 10/6/21.
//

import Foundation
import UIKit

class NotificationManager {
    
    public static let shared = NotificationManager()
    
    
    private init() {
        
    }
    
    func scheduleNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        for time in AppEngine.shared.userSetting.notificationTime {
            DispatchQueue.main.async {
                self.addNotification(at: time)
            }
            
        }
            
    }
    
    
    func addNotification(at time: CustomTime) {
        
        var numberOfInprogressItems = 0
        for item in AppEngine.shared.currentUser.items {
            if item.state == .inProgress {
                numberOfInprogressItems += 1
            }
        }

        if AppEngine.shared.currentUser.items.count != 0, numberOfInprogressItems > 0 {
            
            var item: Item {
                var outputItem = AppEngine.shared.currentUser.items.random!
                while outputItem.state != .inProgress {
                    outputItem = AppEngine.shared.currentUser.items.random!
                }
                return outputItem
            }
            let itemToNotifyUser = item
            
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
            
            let earlyTitle = WelcomeText(timeRange: time.timeRange).firstText
            let earlyBody = earlyBodys.random!
            let lateTitle = SharePosterTextData.randomText
            let lateBody = lateBodys.random!
           
            
            
            let content = UNMutableNotificationContent()
            content.title = time < CustomTime(hour: 18, minute: 0, second: 0, oneTenthSecond: 0) ? earlyTitle : lateTitle
            content.body = time < CustomTime(hour: 14, minute: 0, second: 0, oneTenthSecond: 0) ? earlyBody : lateBody
            content.badge = 1
            
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            dateComponents.hour = time.hour
            dateComponents.minute = time.minute
            
            // Create the trigger as a repeating event.
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            // Create the request
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString,
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
    
}
