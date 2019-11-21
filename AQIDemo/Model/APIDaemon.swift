//
//  APIDeamon.swift
//  AQIDemo
//
//  Created by BenKu on 2019/8/21.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import Foundation
import PromiseKit
let kLocalDBDidUpdated = Notification.Name(rawValue: "local.db.updated")
class APIDaemon {
    static let shared = APIDaemon()
    private var executeTimer:Timer?
    class func start() {
        AQIDB.initDBIfNeed().done { (updated) in
            if updated {
                APIDaemon.shared.sendUpdatedNotify()
            }
        }.ensure {
            APIDaemon.shared.update()
            LocationScan.default.start()
        }.catch { (err) in
                print(err)
        }
        
    }
    private func update() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly { () -> Promise<Aqi> in
            AQIDataFetcher.updateAQIs()
            }.then { (eles) in
                AQIDB.updateData(with: eles)
            }.done { (eles) in
                self.runNextExeTimer()
                self.sendUpdatedNotify()
            }.catch { (error) in
                self.runRetryTimer()
                print(error.localizedDescription)
            }.finally {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    private func sendUpdatedNotify(){
        NotificationCenter.default.post(name: kLocalDBDidUpdated, object: nil)
    }
    private func runRetryTimer(){
        executeTimer?.invalidate()
        executeTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: false, block: { (_) in
            self.update()
        })
    }
    private func runNextExeTimer(){
        
        let current = Date()
        let format = DateFormatter()
        format.dateFormat = "MM"
        let min = format.string(from: current)
        let gap = 65 - min.int
        let calendar = Calendar.current
        guard let nextFireDate = calendar.date(byAdding: .minute, value: gap, to: current) else { return }
        let nexTime = nextFireDate.timeIntervalSinceNow
        executeTimer?.invalidate()
        executeTimer = Timer.scheduledTimer(withTimeInterval: nexTime, repeats: false, block: { (timer) in
            self.update()
        })
    }
}
