//
//  NotifyController.swift
//  AppStoreIOS12
//
//  Created by BenKu on 2019/5/15.
//  Copyright © 2019 PF. All rights reserved.
//

import UserNotifications
import UIKit
struct Notify {
    
}
extension Date {
    static func currentTime() -> String {
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss";
        return df.string(from: Date())
    }
}
extension Notify {
    static let notifyID = "AA"
    static func show(_ msg:String) {
        print("\(#function):\(msg),\(Date.currentTime())")
        DispatchQueue.main.async {
            let content = UNMutableNotificationContent.init()
            content.badge = NSNumber(integerLiteral: 0)
            content.title = "Alert!"
            content.body = msg + Date.currentTime()
            content.threadIdentifier = notifyID
            if #available(iOS 12.0, *) {
                content.summaryArgument = "three small"
            } else {
                // Fallback on earlier versions
            }
            let tri = UNTimeIntervalNotificationTrigger.init(timeInterval: 1.0, repeats: false)
            let req = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: tri)
            UNUserNotificationCenter.current().add(req) { (err) in
                if err != nil { print((err?.localizedDescription) ?? "Notifi Error")}
                //print(err ?? "have no error")
            }
        }
        
    }
    static func permissionReq() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (result, err) in
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
            print(result)
        }
    }
}
