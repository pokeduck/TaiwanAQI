//
//  CircleView.swift
//  AQIDemo
//
//  Created by WellKu on 2019/6/4.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import UIKit
enum StateColor {
    static let good:String = "7bed9f"//"43976A"
    static let normal = "FADF59"//"FADF59"
    static let orange = "ff7f50"//"43976A"
    static let red = "ff4757"//"BB2738"
    static let purple = "A118FF"//"5D0E93"
    static let die = "A12F10"//"5D0E93"
}
enum AQILevel {
    case none
    case good
    case normal
    case orange
    case red
    case purple
    case die
}
extension AQILevel{
    var aqiColor:UIColor {
        switch self {
        case .good:
            return StateColor.good.color
        case .normal:
            return StateColor.normal.color
        case .orange:
            return StateColor.orange.color
        case .red:
            return StateColor.red.color
        case .purple:
            return StateColor.purple.color
        case .die:
            return StateColor.die.color
        default:
            return .gray
        }
    }
}
enum StateTitle {
    static let good:String = "良好"
    static let normal = "普通"
    static let orange = "對敏感族群不健康"
    static let red = "對所有族群不健康"
    static let purple = "非常不健康"
    static let die = "危害"
}
extension Int {
    var aqiLevel:AQILevel {
        switch self {
        case -1:
            return .none
        case 1...50:
            return .good
        case 51...100:
            return .normal
        case 101...150:
            return .orange
        case 151...200:
            return .red
        case 201...300:
            return .purple
        case 301...:
            return .die
        default:
            return .none
        }
    }
    var aqiColor:UIColor {
        switch self {
        case -1:
            return .gray
        case 1...50:
            return StateColor.good.hexColor()
        case 51...100:
            return StateColor.normal.hexColor()
        case 101...150:
            return StateColor.orange.hexColor()
        case 151...200:
            return StateColor.red.hexColor()
        case 201...300:
            return StateColor.purple.hexColor()
        case 301...:
            return StateColor.die.hexColor()
        default:
            return .gray
        }
    }
}
@IBDesignable
class CircleView: UIView {
    var state:String = "AAAA"

    @IBInspectable var edgeColor: UIColor = UIColor.blue
    @IBInspectable var lineWidth: CGFloat = 10.0
    @IBInspectable var aqiValue: Int = 0 {
        didSet {
            switch aqiValue {
            case -1:
                self.edgeColor = .gray
                self.state = "沒有資料"
            case 1...50:
                self.edgeColor = StateColor.good.hexColor()
                self.state = StateTitle.good
            case 51...100:
                self.edgeColor = StateColor.normal.hexColor()
                state = StateTitle.normal
            case 101...150:
                self.edgeColor = StateColor.orange.hexColor()
                state = StateTitle.orange
            case 151...200:
                self.edgeColor = StateColor.red.hexColor()
                state = StateTitle.red
            case 201...300:
                self.edgeColor = StateColor.purple.hexColor()
                state = StateTitle.purple
            case 301...:
                self.edgeColor = StateColor.die.hexColor()
                state = StateTitle.die
            default:
                self.edgeColor = .gray
                self.state = "沒有資料"
            }
        }
    }
    
    lazy var nameL:UILabel = {
        let l:UILabel = commonLabel()
        l.text = "空氣品質指標AQI"
        return l
    }()
    lazy var stateL:UILabel = {
        return commonLabel()
    }()
    lazy var aqiL:UILabel = {
        return commonLabel()
    }()
    private func commonLabel() -> UILabel {
        let l:UILabel = UILabel(frame: .zero)
        l.textColor = .white
        l.textAlignment = .center
        l.drawShadow()
        addSubview(l)
        return l
    }
   
}
extension CircleView {
    convenience init(with aqi:Int?) {
        self.init(frame:.zero,aqi)
    }
    convenience  init(frame: CGRect,_ aqi:Int?) {
        self.init(frame:frame)
        self.aqiValue = aqi ?? -1
    }
    
    open func updateView(_ aqi:Int){
        self.aqiValue = aqi
        setNeedsDisplay()
    }
}
extension CircleView {
    override func draw(_ rect: CGRect) {
        addCircle(arcR: min(rect.width/2, rect.height/2), color: edgeColor)
        let aqiW = rect.width/1.6
        let aqiX = rect.midX - aqiW/2
        let aqiY = rect.midY - rect.height/4
        let aqiH = rect.height/2
        let aqiF = CGRect(x: aqiX, y: aqiY, width: aqiW, height: aqiH)
        aqiL.text = ((aqiValue == -1) || (aqiValue == 0)) ? "_" : String(aqiValue)
        aqiL.frame = aqiF
        aqiL.font = UIFont.systemFont(ofSize: min(aqiH, aqiW)/1.5, weight: .medium)
        //aqiL.adjustsFontSizeToFitWidth = true
        addSubview(aqiL)
        
        let nameW = aqiW * 1.2
        let nameH = aqiH / 4
        let nameX = aqiL.frame.midX - nameW / 2
        let nameY = aqiL.frame.minY - nameH + aqiH / 12
        let nameF = CGRect(x: nameX, y: nameY, width: nameW, height: nameH)
        nameL.frame = nameF
        nameL.font = UIFont.systemFont(ofSize: nameH/1.8, weight: .light)
        
        let stateW = nameW
        let stateH = nameH
        let stateX = aqiL.frame.midX - nameW / 2
        let stateY = aqiL.frame.maxY - stateH / 3
        let stateF = CGRect(x: stateX, y: stateY, width: stateW, height: stateH)
        stateL.frame = stateF
        stateL.text = state
        stateL.font = UIFont.systemFont(ofSize: stateH/1.7, weight: .light)
        
        
    }
    
    fileprivate func addCircle(arcR: CGFloat, color:UIColor){
        let path = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: (arcR - lineWidth / 2), startAngle: CGFloat(Float.pi), endAngle: 5 * CGFloat(Float.pi), clockwise: true).cgPath
        
        self.addOval(lineWidth: lineWidth, path: path , strokeStart: 0, strokeEnd: 0.5, strokeColor: color, fillColor: .clear, shadowRadius: 0, shadowOpacity: 0, shadowOffsset: .zero)
    }
    fileprivate func addOval(lineWidth: CGFloat, path: CGPath, strokeStart: CGFloat, strokeEnd: CGFloat, strokeColor: UIColor, fillColor: UIColor, shadowRadius: CGFloat, shadowOpacity: Float, shadowOffsset: CGSize) {
        
        let arc = CAShapeLayer()
        arc.lineWidth = lineWidth
        arc.path = path
        arc.strokeStart = strokeStart
        arc.strokeEnd = strokeEnd
        arc.strokeColor = strokeColor.cgColor
        arc.fillColor = fillColor.cgColor
        arc.shadowColor = UIColor.black.cgColor
        arc.shadowRadius = shadowRadius
        arc.shadowOpacity = shadowOpacity
        arc.shadowOffset = shadowOffsset
        layer.addSublayer(arc)
    }
    

}
