//
//  SiteClusterView.swift
//  AQIDemo
//
//  Created by BenKu on 2019/8/9.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import MapKit
class SiteClusterView: MKAnnotationView {
    static let reuseID = "siteClusterReuseID"
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10) // Offset center point to animate better with marker annotations
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        guard let cluster = annotation as? MKClusterAnnotation,
            let sites:[SiteAnno] = cluster.memberAnnotations as? [SiteAnno]
            else {return}
        image = drawRatioCluster(sites)
    }
    private func drawRatioCluster(_ sites:[SiteAnno]) -> UIImage {
        let render = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
        let total:Int = sites.count
        let levelCnt = sites.aqiLevelCount()
        var starAngle:CGFloat = CGFloat.pi / 2
        var pieData:[(UIColor,CGFloat,CGFloat)] = []
        levelCnt.forEach { (level) in
            let color = level.key.aqiColor
            let cnt = level.value
            if cnt == 0 { return }
            let numeratorAngle = CGFloat(cnt) / CGFloat(total) * CGFloat.pi * 2.0
            let endAngle = starAngle + numeratorAngle
            pieData.append((color,starAngle,endAngle))
            starAngle = endAngle
        }
        return render.image { (context) in
            let center = CGPoint(x: 20, y: 20)
            let radius:CGFloat = 20.0
            pieData.forEach({ (data) in
                data.0.setFill()
                let piePath = UIBezierPath()
                piePath.addArc(withCenter: center, radius: radius, startAngle: data.1, endAngle: data.2, clockwise: true)
                piePath.addLine(to: center)
                piePath.close()
                piePath.fill()
            })
            
            UIColor.white.setFill()
            UIBezierPath(ovalIn: CGRect(x: 8, y: 8, width: 24, height: 24)).fill()
            
            let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.black,
                               NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
            let text = "\(total)"
            let size = text.size(withAttributes: attributes)
            let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
            text.draw(in: rect, withAttributes: attributes)
        }
        
    }
}
