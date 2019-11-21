//
//  AppDelegate.swift
//  AQIDemo
//
//  Created by WellKu on 2019/6/3.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import UIKit
import SideMenu
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        UIApplication.shared.setMinimumBackgroundFetchInterval(600)
        SideMenuSetting.setupControl()
        APIDaemon.start()
        //Local notification.
        //Notify.permissionReq()
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        AQIDataFetcher.updateAQIs()
        .then { (eles) in
            AQIDB.updateData(with: eles)
        }.done { (aqis) -> Void in
            completionHandler(.newData)
        }
        .catch { error in
            completionHandler(.noData)
        }
    }
}

