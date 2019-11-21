//
//  WindDirection.swift
//  AQIDemo
//
//  Created by BenKu on 2019/8/11.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import Foundation
enum WindDirection {
    case n
    case nne
    case ne
    case ene
    case e
    case ese
    case se
    case sse
    case s
    case ssw
    case sw
    case wsw
    case w
    case wnw
    case nw
    case nnw
}
extension WindDirection {
    static func compass(from heading: Double) -> String {
        if heading < 0 { return "" }
        let dirns = ["北","東北偏北","東北","東北偏東","東","東南偏東","東南","東南偏南",
                     "南","西南偏南","西南","西南偏西","西","西北偏西","西北","西北偏北"]
        let index = Int((heading + 11.25) / 22.5) & 15
        return dirns[index]
    }
}
//N   北   0.00°
//NNE 東北偏北 22.50°
//NE  東北    45.00°
//ENE 東北偏東    67.50°
//E   東   90.00°
//ESE 東南偏東    112.50°
//SE  東南  135.00°
//SSE 東南偏南    157.50°
//S   南   180.00°
//SSW 西南偏南    202.50°
//SW  西南  225.00°
//WSW 西南偏西    247.50°
//W   西  270.00°
//WNW 西北偏西    292.50°
//NW  西北  315.00°
//NNW 西北偏北    337.50°
