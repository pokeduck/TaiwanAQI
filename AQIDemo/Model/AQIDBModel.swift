//
//  AQIDBModel.swift
//  AQIDemo
//
//  Created by WellKu on 2019/6/7.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import Foundation
import RealmSwift
class AQIModel: Object {
    @objc dynamic var siteName = ""
    @objc dynamic var cty = ""
    @objc dynamic var aqi = ""
    @objc dynamic var pm2_5 = ""
    @objc dynamic var pm10 = ""
    @objc dynamic var so2 = ""
    @objc dynamic var co = ""
    @objc dynamic var o3 = ""
    @objc dynamic var no2 = ""
    @objc dynamic var id = ""
    @objc dynamic var winSpeed = ""
    @objc dynamic var windDirec = ""
    
    @objc dynamic var publishDate = Date()
    @objc dynamic var lat: Float = 0.0
    @objc dynamic var lon: Float = 0.0
    override static func primaryKey() -> String {
        return "siteName"
    }
   
    
}
extension AQIModel {
    func update(with e:AQIElement){
        cty = e.county
        aqi = e.aqi
        pm2_5 = e.pm25
        pm10 = e.pm10
        so2 = e.so2
        co = e.co
        o3 = e.o3
        no2 = e.no2
        publishDate = e.publishTime.aqiDate
        id = e.siteID
        winSpeed = e.windSpeed
        windDirec = e.windDirec
        lat = (e.latitude == "") ? 0.0 : Float(e.latitude) ?? 0.0
        lon = (e.longitude == "") ? 0.0 : Float(e.longitude) ?? 0.0
    }
    
}
