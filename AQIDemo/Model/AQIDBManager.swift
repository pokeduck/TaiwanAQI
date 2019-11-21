//
//  AQIDBManager.swift
//  AQIDemo
//
//  Created by WellKu on 2019/6/7.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//
import Foundation
import CoreLocation
import RealmSwift
import PromiseKit
struct AQIDB {
    //private static let `default` = AQIDB()
    //var latestSites:Aqi = []
    static func initDBIfNeed() -> Promise<Bool>{
        return Promise<Bool> { seal in
            self.query().done({ (eles) in
                if eles.count > 0{
                    seal.fulfill(false)
                }else {
                    self.writeInitDateToDB().done({ (result) in
                        seal.fulfill(result)
                    }).catch({ (err) in
                        seal.reject(err)
                    })
                }
            }).catch({ (err) in
                seal.reject(err)
            })
        }
        
    }
    private static func writeInitDateToDB() -> Promise<Bool>{
        return Promise { seal in
            let jsonPath = Bundle.main.path(forResource: "default", ofType: "json")
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: jsonPath!)),
                let sites = try? Aqi(data: data) else {
                    seal.fulfill(false)
                    return
            }
            firstly{
                updateData(with: sites)
                }.done({ (_) in
                    seal.fulfill(true)
                }).catch({ (err) in
                    seal.reject(err)
            })
            
        }
        
    }
    
    static func updateData(with aqis:Aqi) -> Promise<Aqi>{
        return Promise{ seal in
            DispatchQueue.init(label: "write.db.realm").async {
                let realm = try! Realm()
                aqis.forEach { (element) in
                    if let model = realm.object(ofType: AQIModel.self, forPrimaryKey: "\(element.siteName)"){
                        try! realm.write {
                            model.update(with: element)
                        }
                    }else {
                        let model = AQIModel()
                        model.siteName = element.siteName
                        model.update(with: element)
                        try! realm.write {
                            realm.add(model)
                        }
                    }
                }
                seal.fulfill(aqis)
            }
        }
    }
    static func queryID(_ siteID:[String]) -> Promise<Aqi> {
        return Promise {  seal in
            DispatchQueue.init(label: "read.db.realm").async {
                var table:[String:Int] = [:]
                for i in 0..<siteID.count {
                    table[siteID[i]] = i
                }
                var eles:Aqi = []
                let realm = try! Realm()
                
                let re = realm.objects(AQIModel.self).filter("id IN %@",siteID).sorted(by: { (m1, m2) -> Bool in
                    let m1Index = table[m1.id]
                    let m2Index = table[m2.id]
                    return m1Index! < m2Index!
                })
                if re.count == 0 { seal.reject(NSError(domain: "GG", code: 0, userInfo: nil) as Error)
                    return 
                }
                re.forEach { (m) in
                    eles.append(AQIElement(siteName: m.siteName,
                                           county: m.cty,
                                           aqi: m.aqi,
                                           pollutant: "",
                                           status: "",
                                           so2: m.so2,
                                           co: m.co,
                                           co8Hr: "",
                                           o3: m.o3,
                                           o38Hr: "",
                                           pm10: m.pm10,
                                           pm25: m.pm2_5,
                                           no2: m.no2,
                                           nOx: "",
                                           no: "",
                                           windSpeed: m.winSpeed,
                                           windDirec: m.windDirec,
                                           publishTime: m.publishDate.aqiType,
                                           pm25_Avg: "",
                                           pm10Avg: "",
                                           so2Avg: "",
                                           longitude: String(m.lon),
                                           latitude: String(m.lat),
                                           siteID: m.id))
                }
                seal.fulfill(eles)
                
            }
        }
    }
    static func query(_ name:String? = nil) -> Promise<Aqi> {
        return Promise { seal in
            DispatchQueue.init(label: "read.db.realm").async {
                guard let _ = name else {
                    seal.fulfill(self.queryAll())
                    return
                }
                var eles:Aqi = []
                let realm = try! Realm()
                let predicate = NSPredicate(format: "siteName CONTAINS %@ OR cty CONTAINS %@", name!, name!)
                let re = realm.objects(AQIModel.self).filter(predicate).sorted(byKeyPath: "cty")
        
                re.forEach { (m) in
                    eles.append(AQIElement(siteName: m.siteName,
                                           county: m.cty,
                                           aqi: m.aqi,
                                           pollutant: "",
                                           status: "",
                                           so2: m.so2,
                                           co: m.co,
                                           co8Hr: "",
                                           o3: m.o3,
                                           o38Hr: "",
                                           pm10: m.pm10,
                                           pm25: m.pm2_5,
                                           no2: m.no2,
                                           nOx: "",
                                           no: "",
                                           windSpeed: m.winSpeed,
                                           windDirec: m.windDirec,
                                           publishTime: m.publishDate.aqiType,
                                           pm25_Avg: "",
                                           pm10Avg: "",
                                           so2Avg: "",
                                           longitude: String(m.lon),
                                           latitude: String(m.lat),
                                           siteID: m.id))
                }
                seal.fulfill(eles)
            }
        }
    }
    static func queryAll() -> Aqi {
        var eles:Aqi = []
        let realm = try! Realm()
        let result = realm.objects(AQIModel.self)
        result.forEach { (m) in
            eles.append(AQIElement(siteName: m.siteName,
                                   county: m.cty,
                                   aqi: m.aqi,
                                   pollutant: "",
                                   status: "",
                                   so2: m.so2,
                                   co: m.co,
                                   co8Hr: "",
                                   o3: m.o3,
                                   o38Hr: "",
                                   pm10: m.pm10,
                                   pm25: m.pm2_5,
                                   no2: m.no2,
                                   nOx: "",
                                   no: "",
                                   windSpeed: m.winSpeed,
                                   windDirec: m.windDirec,
                                   publishTime: m.publishDate.aqiType,
                                   pm25_Avg: "",
                                   pm10Avg: "",
                                   so2Avg: "",
                                   longitude: String(m.lon),
                                   latitude: String(m.lat),
                                   siteID: m.id))
        }
        return eles
    }
    

}
