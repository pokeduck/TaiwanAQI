//
//  String+Convert.swift
//  AQIDemo
//
//  Created by BenKu on 2019/8/21.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import Foundation
extension String {
    var double:Double {
        return Double(self) ?? 0
    }
    var int:Int {
        return Int(self) ?? 0
    }
}
