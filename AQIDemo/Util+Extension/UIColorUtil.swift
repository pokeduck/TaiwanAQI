//
//  UIColorUtil.swift
//  SwiftDemo
//
//  Created by BenKu on 2018/12/5.
//  Copyright © 2018年 BenKu. All rights reserved.
//

import UIKit


extension UIColor{
    convenience init(hexValue:UInt32){
        self.init(red: CGFloat((hexValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((hexValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(hexValue & 0x0000FF) / 255.0,
                  alpha: CGFloat(1.0))
    }
    convenience init(hex:String){
        let characterSet = NSCharacterSet.whitespacesAndNewlines as! NSMutableCharacterSet
        characterSet.formUnion(with: NSCharacterSet.init(charactersIn: "#") as CharacterSet)
        let cString = hex.trimmingCharacters(in: characterSet as CharacterSet).uppercased()
        if (cString.count != 6) {
            self.init(white: 1.0, alpha: 1.0)
        } else {
            var rgbValue: UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            self.init(hexValue: rgbValue)
        }
    }
    class func colorFromHex(withString hex:String)->UIColor{
        return UIColor(hex: hex)
    }

}
extension String{
    var color: UIColor {
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
        
    }
    
    func hexColor() -> UIColor {
        return self.color
//        let hex = trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int = UInt32()
//        Scanner(string: hex).scanHexInt32(&int)
//        let a, r, g, b: UInt32
//        switch hex.count {
//        case 3: // RGB (12-bit)
//            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
//        case 6: // RGB (24-bit)
//            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//        case 8: // ARGB (32-bit)
//            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
//        default:
//            return .clear
//        }
//        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
}
extension Array where Element == Int {
    var color: UIColor {
        if self.count < 3 { return .white }
        let nValue:[Int] = self.map { (value) -> Int in
            if value>255 {return 255}
            if value<0 {return 0}
            return value
        }
        let r = CGFloat(nValue[0])/255
        let g = CGFloat(nValue[1])/255
        let b = CGFloat(nValue[2])/255
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
