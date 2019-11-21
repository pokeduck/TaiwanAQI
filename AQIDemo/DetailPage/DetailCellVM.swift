//
//  DetailCellVM.swift
//  AQIDemo
//
//  Created by BenKu on 2019/8/1.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import UIKit
import IntentsUI
fileprivate enum CellKey {
    static let normal = "NormalCell"
    static let title = "TitleCell"
    static let circle = "CircleCell"
    static let hint = "HintCell"
    static let data = "DetailDataCell"
    static let footer = "PublishTimeCell"
    static let siriSct = "SiriCell"
    static let header = "header"
}
protocol CollCellImplement {
    func drawCell(_ collV:UICollectionView, atIndex idxPath:IndexPath) -> UICollectionViewCell
    func cellSize(_ collV:UICollectionView, sizeForIdx idxPath: IndexPath) -> CGSize
}
protocol CollHeaderImpl {
    func headerView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    func headerSize(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
}

struct AqiTitleHeaderVM: CollHeaderImpl  {
    let title:String
    
    func headerView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellKey.header, for: indexPath) as! HeaderView
        header.titleLabel.text = title
        return header
    }
    func headerSize(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 55)
    }
}
struct AqiAffectHintVM: CollCellImplement {
    func cellSize(_ collV: UICollectionView, sizeForIdx idxPath: IndexPath) -> CGSize {
        return CGSize(width: collV.frame.width, height: 70)
    }
    
    let hint:String
    func drawCell(_ collV: UICollectionView, atIndex idxPath: IndexPath) -> UICollectionViewCell {
        let cell = collV.dequeueReusableCell(withReuseIdentifier: CellKey.hint, for: idxPath) as! CollHintCell
        cell.titleLabel.text = hint
        return cell
    }
}
struct AqiFooterVM: CollCellImplement {
    func cellSize(_ collV: UICollectionView, sizeForIdx idxPath: IndexPath) -> CGSize {
        return CGSize(width: collV.frame.width, height: 55)
    }
    
    let publishTime:String
    func drawCell(_ collV: UICollectionView, atIndex idxPath: IndexPath) -> UICollectionViewCell {
        let cell = collV.dequeueReusableCell(withReuseIdentifier: CellKey.footer, for: idxPath) as! CollPublishCell
        cell.titleLabel.text = "發布時間\n" + publishTime
        return cell
    }
}

struct AqiDetailCellVM: CollCellImplement {
    func cellSize(_ collV: UICollectionView, sizeForIdx idxPath: IndexPath) -> CGSize {
        return CGSize(width: collV.frame.width / 2 , height: 90)
    }
    
    let title:NSAttributedString
    let subTitle:String
    let value:String
    let unit:NSAttributedString
    let key = "detailCell"
    func drawCell(_ collV: UICollectionView, atIndex idxPath: IndexPath) -> UICollectionViewCell {
        let cell:DetailCollCell = collV.dequeueReusableCell(withReuseIdentifier: CellKey.data, for: idxPath) as! DetailCollCell
        
        cell.titleLabel.attributedText = title
        cell.valueLabel.text = value
        cell.unitLabel.attributedText = unit
        cell.subTitleLabel.text = subTitle
        
        switch idxPath.row % 2 {
        case 0:
            cell.adjustLineMargin(20, 0)
        default:

            cell.adjustLineMargin(0, 20)
        }
        return cell
    }
    
}
struct AqiCircleCellVM: CollCellImplement {
    func cellSize(_ collV: UICollectionView, sizeForIdx idxPath: IndexPath) -> CGSize {
        return CGSize(width: collV.frame.width, height: 260)
    }
    
    let aqiValue:Int
    func drawCell(_ collV: UICollectionView, atIndex idxPath: IndexPath) -> UICollectionViewCell {
        let cell:DetailCollAqiCell = collV.dequeueReusableCell(withReuseIdentifier: CellKey.circle, for: idxPath) as! DetailCollAqiCell
        cell.circleView.aqiValue = aqiValue
        return cell
    }
}
@available(iOS 12.0, *)
class SiriShortCutCellVM:NSObject ,CollCellImplement {
    func cellSize(_ collV: UICollectionView, sizeForIdx idxPath: IndexPath) -> CGSize {
        return CGSize(width: collV.frame.width, height: 70)
    }
    func drawCell(_ collV: UICollectionView, atIndex idxPath: IndexPath) -> UICollectionViewCell {
        let cell = collV.dequeueReusableCell(withReuseIdentifier: CellKey.siriSct, for: idxPath) as! CollSiriCell
        cell.addSiriBtn.delegate = self
        return cell
    }
}
@available(iOS 12.0, *)
extension SiriShortCutCellVM : INUIAddVoiceShortcutButtonDelegate {
    func present(_ addVoiceShortcutViewController: INUIAddVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton){
 
    }
    
    func present(_ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton){
      

    }
}
struct DetailCollVM {
    let cells: [CollCellImplement]
    let headerVM : AqiTitleHeaderVM
    let aqiValue:Int
    let updateDate:String
    var cellCnt:Int {
        return cells.count
    }
    private typealias DTVM = AqiDetailCellVM
    private typealias CAStr = CellAttrStr
    
    init(_ data:AQIElement) {
        var cellVMs:[CollCellImplement] = []
        headerVM = AqiTitleHeaderVM(title: data.siteName)
        let aqi = (data.aqi == "") ? -1 : Int(data.aqi)
        cellVMs.append(AqiCircleCellVM(aqiValue: aqi!))
        cellVMs.append(AqiAffectHintVM(hint: aqi!.valueToHint))
        
        updateDate = data.publishTime
        aqiValue = (data.aqi == "") ? -1 : Int(data.aqi)!
        //aqiValue = 111
        let detailArr:[CollCellImplement] =
            [DTVM(title: CAStr.pm25,subTitle: "細懸浮微粒", value: data.pm25.d, unit: CAStr.gm3),
             DTVM(title: CAStr.pm10,subTitle: "懸浮微粒", value: data.pm10.d, unit: CAStr.gm3),
             DTVM(title: CAStr.o3,subTitle: "臭氧", value: data.o3.d, unit: "ppb".attr),
             DTVM(title: "CO".attr,subTitle: "一氧化碳", value: data.co.d, unit: "ppm".attr),
             DTVM(title: CAStr.so2,subTitle: "二氧化硫", value: data.so2.d, unit: "ppb".attr),
             DTVM(title: CAStr.no2,subTitle: "二氧化氮", value: data.no2.d, unit: "ppb".attr),
             //
             //
             DTVM(title: "風速".attr,subTitle: "", value: data.windSpeed.d, unit: "m/sec".attr),
             DTVM(title: "風向".attr,subTitle: "",
                  value: WindDirection.compass(from: data.windDirec.d.double).d,
                  unit: "".attr)]
        cellVMs.append(contentsOf: detailArr)
        cellVMs.append(AqiFooterVM(publishTime: data.publishTime))
        //cellVMs.append(SiriShortCutCellVM())
        cells = cellVMs
    }

}

extension String {
    var d :String {
        if self.count<1 { return "-"}
        return self
    }
}
extension DetailCollVM : CollHeaderImpl {
    func headerView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return headerVM.headerView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
    
    func headerSize(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return headerVM.headerSize(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section)
    }
    
    
}
extension DetailCollVM : CollCellImplement {
    func registerCell(_ collV:UICollectionView){
        collV.register(DetailCollCell.nib(), forCellWithReuseIdentifier: CellKey.data)
        collV.register(DetailCollAqiCell.nib(), forCellWithReuseIdentifier: CellKey.circle)
        collV.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CellKey.normal)
        
        collV.register(CollTitleCell.self, forCellWithReuseIdentifier: CellKey.title)
        collV.register(CollHintCell.self, forCellWithReuseIdentifier: CellKey.hint)
        collV.register(CollPublishCell.self, forCellWithReuseIdentifier: CellKey.footer)
        
        if #available(iOS 12.0, *) {
            collV.register(CollSiriCell.self, forCellWithReuseIdentifier: CellKey.siriSct)
        }
        
        collV.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellKey.header)
        
    }
    func cellSize(_ collV:UICollectionView, sizeForIdx idxPath: IndexPath) -> CGSize {
        return cells[idxPath.row].cellSize(collV, sizeForIdx: idxPath)
    }
    func drawCell(_ collV:UICollectionView, atIndex idxPath:IndexPath) -> UICollectionViewCell{
        return cells[idxPath.row].drawCell(collV, atIndex: idxPath)
    }
}
extension String {
    var attr:NSAttributedString {
        return NSAttributedString(string: self)
    }
}
extension Int {
    var valueToHint:String {
        switch self {
        case -1:
            return "沒有資料"
        case 0...50:
            return "空氣品質為良好，污染程度低或無污染。"
        case 51...100:
            return "空氣品質普通；但對非常少數之極敏感族群產生情為影響。"
        case 101...150:
            return "空氣污染物可能會對敏感族群的健康造成影響，但是對一般大眾的影響不明顯。"
        case 151...200:
            return "對所有人的健康開始產生影響，對於敏感族群可能產生較嚴重的健康影響。"
        case 201...300:
            return "健康警報：所有人都可能產生較嚴重的健康影響。"
        case 301...:
            return "健康威脅達到緊急，所有人都可能受到影響。"
        default:
            return "A"
        }
    }
}
extension UILabel {
    func drawShadow(){
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.masksToBounds = false
    }
}

struct DetailCellVM {
    let title:NSAttributedString
    let subTitle:String
    let value:String
    let unit:NSAttributedString
    var affectHint:String? = nil
    init(title:NSAttributedString,
         subTitle:String,
         value:String,
         unit:NSAttributedString
        ) {
        self.title = title
        self.subTitle = subTitle
        self.value = String(value)
        self.unit = unit
    }
}
