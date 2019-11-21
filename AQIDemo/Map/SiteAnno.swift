//
//  Site.swift
//  AQIDemo
//
//  Created by BenKu on 2019/8/9.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import MapKit
class SiteAnno: MKPointAnnotation {
    var siteID:Int = 0
    var aqiValue:Int = 0
    var siteName:String = "桃園(觀音工業區)"
    private var latitude: CLLocationDegrees = 0
    private var longitude: CLLocationDegrees = 0
    
    override var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
    init(lati:Double,lon:Double) {
        self.latitude = lati
        self.longitude = lon
    }
}
extension Array where Element == CLLocationCoordinate2D {
    func rect(increase widthRatio:Double = 1.0,_ heightRatio:Double = 1.0) -> MKMapRect {
        var rect = MKMapRect()
        let coordinates:[CLLocationCoordinate2D] = self
        if !coordinates.isEmpty {
            let first = coordinates.first!
            var top = first.latitude
            var bottom = first.latitude
            var left = first.longitude
            var right = first.longitude
            coordinates.forEach { coordinate in
                top = Swift.max(top, coordinate.latitude)
                bottom = Swift.min(bottom, coordinate.latitude)
                left = Swift.min(left, coordinate.longitude)
                right = Swift.max(right, coordinate.longitude)
            }
            let topLeft = MKMapPoint(CLLocationCoordinate2D(latitude:top, longitude:left))
            let bottomRight = MKMapPoint(CLLocationCoordinate2D(latitude:bottom, longitude:right))
            rect = MKMapRect(x:topLeft.x, y:topLeft.y,
                             width:1 * (bottomRight.x - topLeft.x),
                             height:1 * (bottomRight.y - topLeft.y))
            rect = rect.insetBy(dx: rect.width * widthRatio / -2,
                                dy: rect.height * heightRatio / -2)
            //https://stackoverflow.com/a/26918977/9186699
        }
        return rect
    }
    var mapRect : MKMapRect {
        return self.rect()
    }
}
extension Array where Element == SiteAnno {
    var region: MKCoordinateRegion {
        
        let coors = self.map { (site) -> CLLocationCoordinate2D in
            return site.coordinate
            }.filter { (coor) -> Bool in
                (coor.latitude != 0 && coor.longitude != 0)
        }
        let r = coors.rect(increase: 0.4,0.6)
        let rgn = MKCoordinateRegion(r)
        return rgn
    }
    func aqiLevelCount()-> [AQILevel:Int] {
        var lv0 = 0
        var lv1 = 0
        var lv2 = 0
        var lv3 = 0
        var lv4 = 0
        var lv5 = 0
        var lv6 = 0
        self.forEach { (site) in
            switch site.aqiValue {
            case 1...50:
                lv1 += 1
            case 51...100:
                lv2 += 1
            case 101...150:
                lv3 += 1
            case 151...200:
                lv4 += 1
            case 201...300:
                lv5 += 1
            case 301...:
                lv6 += 1
            default:
                lv0 += 1
            }
        }
        return [AQILevel.none:lv0,AQILevel.good:lv1,AQILevel.normal:lv2,AQILevel.orange:lv3,AQILevel.red:lv4,AQILevel.purple:lv5,AQILevel.die:lv6]
    }
}
extension Array where Element == Aqi.Element {
    func makeAnnos() -> [SiteAnno] {
        var annos:[SiteAnno] = []
        self.forEach { (ele) in
            let site = SiteAnno(lati: ele.latitude.double, lon: ele.longitude.double)
            site.title = ele.siteName
            site.subtitle = ele.aqi
            site.aqiValue = ele.aqi.int
            site.siteName = ele.siteName
            site.siteID = ele.siteID.int
            
            annos.append(site)
        }
        return annos
    }
    func query(with id:Int) -> AQIElement? {
        for i in 0..<self.count {
            if self[i].siteID.int == id {
                return self[i]
            }
        }
        return nil
    }
}
