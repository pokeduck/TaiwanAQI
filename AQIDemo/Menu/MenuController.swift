//
//  MenuController.swift
//  AQIDemo
//
//  Created by BenKu on 2019/8/19.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import UIKit
import PromiseKit
struct MenuController {
    static let `default` = MenuController()
    func readUserNearSite() -> Promise<Aqi> {
        let current = UserDefaults.standard[.current]
        return AQIDB.queryID(current)
    }
    func readTrackingSites() -> Promise<Aqi>{
        let userRecording = UserDefaults.standard[.tracking]
        return AQIDB.queryID(userRecording)
    }
    func addTrackingSite(_ siteID:String){
        var newIds = UserDefaults.standard[.tracking]
        newIds.append(siteID)
        saveUserTrackingSite(newIds)
    }
    func saveUserTrackingSite(_ siteIDs:[String]) {
        UserDefaults.standard[.tracking] = siteIDs
    }
    func saveUserNearSite(_ siteID:String){
        UserDefaults.standard[.current] = [siteID]
    }
    init() {
        checkUserData()
    }
    private func checkUserData(){
        if UserDefaults.standard[.current].first == nil {
           UserDefaults.standard[.current] = ["1"]
        }
        if UserDefaults.standard[.tracking].first == nil {
            UserDefaults.standard[.tracking] = ["12","32","54"]
        }
    }
}

enum UDSiteIDKey {
    case tracking
    case current
}
extension UDSiteIDKey : RawRepresentable {
    typealias RawValue = String
    var rawValue: RawValue {
        switch self {
        case .tracking:
            return "trackingSiteIDs1"
        case .current:
            return "current1"
        }
        
        
    }
    init?(rawValue: RawValue) {
        switch rawValue {
        case "trackingSiteIDs1":
            self = .tracking
        case "current1" :
            self = .current
        default:
            return nil
        }
    }
}
extension UserDefaults {
    subscript(key: UDSiteIDKey) -> [String] {
        set{
            set(newValue, forKey: key.rawValue)
        }
        get {
            guard let ids = array(forKey: key.rawValue) as? [String] else {
                let a:[String] = []
                self[key] = a
                return a
            }
            return ids
        }
    }
}
