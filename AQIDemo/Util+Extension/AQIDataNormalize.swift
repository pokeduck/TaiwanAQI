//
//  AQIDateNormalize.swift
//  AQIDemo
//
//  Created by Well.Ku on 2019/6/10.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import Foundation
extension Date {
    var aqiType:String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm"
        return f.string(from: self)
    }
}
extension String {
    var aqiDate: Date {
        //2019-06-06 20:00
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm"
        f.timeZone = TimeZone(secondsFromGMT: 8*3600) // +8HR
        //f.timeZone = TimeZone(abbreviation: "GMT+8") //Alternative
        let d = f.date(from: self)!
        return d
    }
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}
