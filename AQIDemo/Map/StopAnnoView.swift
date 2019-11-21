//
//  StopAnnoView.swift
//  AQIDemo
//
//  Created by Well.Ku on 2019/7/5.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import MapKit
class StopAnnoView: MKAnnotationView {
    static let reuseID = "siteReuseID"
    override init(annotation: MKAnnotation?, reuseIdentifier: String?)
    {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "stop"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultLow
        
        guard let pin = annotation as? SiteAnno ,
            let value = pin.subtitle?.int else { return }
        image = drawAQINumber(value,value.aqiColor,pin.siteName)
    }
    private func drawAQINumber(_ number:Int,_ color:UIColor,_ title:String) -> UIImage{
        let labelHeight:CGFloat = 30.0
        let labelWidth:CGFloat = 46.0
        
        let titleAttrs = [NSAttributedString.Key.foregroundColor: UIColor.black,
                          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]
        let titleText = "\(title)"
        let titleSize = titleText.size(withAttributes: titleAttrs)
        
        let renderWidth = Swift.max(labelWidth,titleSize.width)
        let renderHeight = labelHeight + titleSize.height
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: renderWidth, height: renderHeight))
        
        var offset:CGFloat = 0.0
        var titleX:CGFloat = 0.0
        if titleSize.width > labelWidth {
            offset = ((titleSize.width - labelWidth) / 2)
        }else {
            titleX = ((labelWidth - titleSize.width) / 2)
        }
        return renderer.image { _ in
            //Label Background
            color.setFill()
            UIBezierPath(roundedRect: CGRect(x: 0+offset, y: 0, width: labelWidth, height: labelHeight), cornerRadius: 5).fill()

            //Aqi value
            let valueAttrs = [ NSAttributedString.Key.foregroundColor: UIColor.white,
                               NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
            
            let text = "\(number)"
            let size = text.size(withAttributes: valueAttrs)
            let rect = CGRect(x: offset + (labelWidth/2 - size.width / 2),
                              y: (labelHeight/2 - size.height / 2),
                              width: size.width,
                              height: size.height)
            text.draw(in: rect, withAttributes: valueAttrs)
            
            //Site name
            let titleRect = CGRect(x: titleX, y: labelHeight, width: titleSize.width, height: titleSize.height)
            
            titleText.draw(in: titleRect, withAttributes: titleAttrs)
            
           
        }
       
    }
}
