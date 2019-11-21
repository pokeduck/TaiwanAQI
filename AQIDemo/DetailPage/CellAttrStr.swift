//
//  File.swift
//  AQIDemo
//
//  Created by BenKu on 2019/7/31.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import UIKit
enum CellAttrStr {
    static var pm25: NSAttributedString {
        return underbaselineStr("PM2.5", loc: 2, len: 3)
    }
    static var pm10: NSAttributedString {
        return underbaselineStr("PM10", loc: 2, len: 2)
    }
    static var o3: NSAttributedString {
        return underbaselineStr("O3", loc: 1, len: 1)
    }
    static var so2: NSAttributedString {
        return underbaselineStr("SO2", loc: 2, len: 1)
    }
    static var no2: NSAttributedString {
        return underbaselineStr("NO2", loc: 2, len: 1)
    }
    static var gm3: NSAttributedString {
        return upperbaselineStr("μg/m3", loc: 4, len: 1)
    }
    fileprivate static func upperbaselineStr(_ s:String,loc:Int,len:Int) -> NSAttributedString{
        let font = UIFont(name: "Helvetica", size: 28.0)
        
        let attrStr = NSMutableAttributedString(string: s, attributes: [NSAttributedString.Key.font : font!])
        attrStr.setAttributes([NSAttributedString.Key.baselineOffset : 4,
                               NSAttributedString.Key.font : UIFont(name: "Helvetica", size: 24.0)!,
            ], range: NSRange(location: loc, length: len))
        return attrStr
    }
    fileprivate static func underbaselineStr(_ s:String,loc:Int,len:Int) -> NSAttributedString{
        let font = UIFont(name: "Helvetica", size: 20.0)!
        let attrStr = NSMutableAttributedString(string: s, attributes: [NSAttributedString.Key.font : font])
        
        attrStr.setAttributes([NSAttributedString.Key.baselineOffset : -5,
                               NSAttributedString.Key.font : UIFont(name: "Helvetica", size: 10.0)!
            ], range: NSRange(location: loc, length: len))
        
        return attrStr
    }
}
