//
//  File.swift
//  AQIDemo
//
//  Created by BenKu on 2019/8/3.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import CoreLocation
import PromiseKit
let kUserNearSiteUpdated = Notification.Name("user.near.site.updated")
class LocationScan: NSObject {
    static let `default`:LocationScan = LocationScan()
    var sites:Aqi = []
    var currentNearestSiteID:String = "1"
    var currentCoor: CLLocation = CLLocation(latitude: 0, longitude: 0)
    var locationM: CLLocationManager
    override init() {
        locationM = CLLocationManager()
        locationM.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    func start(){
        locationM.requestWhenInUseAuthorization()
        locationM.startUpdatingLocation()
        locationM.delegate = self
        
        firstly {
            AQIDB.query()
            }.then { (eles) -> Promise<Aqi> in
                self.sites = eles
            return MenuController.default.readUserNearSite()
            }.done { (sid) in
                self.currentNearestSiteID = sid.first!.siteID
            }.catch { (err) in
                print(err)
        }
    }
}
extension LocationScan : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentCoor = locations[0]
        let coor2d = currentCoor.coordinate
        let siteTuples = sites.queryWith(with: coor2d.latitude,
                                         lon: coor2d.longitude)
        guard let site = siteTuples.0 else { return }
        if site.siteID != currentNearestSiteID {
            currentNearestSiteID = site.siteID
            MenuController.default.saveUserNearSite(site.siteID)
            NotificationCenter.default.post(name: kUserNearSiteUpdated, object: site)
        }
    }
}
