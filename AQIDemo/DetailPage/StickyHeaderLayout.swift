//
//  StickyHeaderLayout.swift
//  AQIDemo
//
//  Created by BenKu on 2019/8/17.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import UIKit

class StickyHeaderLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttrs = super.layoutAttributesForElements(in: rect) as! [UICollectionViewLayoutAttributes]
        
        let headerNeedingLayout = NSMutableIndexSet()
        for attrs in layoutAttrs {
            headerNeedingLayout.add(attrs.indexPath.section)
        }
        
        for attrs in layoutAttrs {
            if let elementKind = attrs.representedElementKind,
                elementKind == UICollectionView.elementKindSectionHeader {
                headerNeedingLayout.remove(attrs.indexPath.section)
            }
        }
        
        headerNeedingLayout.enumerate { (index, stop) in
            let indexPath = IndexPath(item: 0, section: index)
            if let attrs = self.layoutAttributesForDecorationView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
                layoutAttrs.append(attrs)
            }
            
            
        }
        
        for attrs in layoutAttrs {
            if let eleKind = attrs.representedElementKind,
            eleKind == UICollectionView.elementKindSectionHeader {
                //let section = attrs.indexPath.section
                //let attrsForFirstItemInSection = layoutAttributesForItem(at: IndexPath(item: 0, section: section))
                //let attrsForLastItemInSection = layoutAttributesForItem(at: IndexPath(item: collectionView!.numberOfItems(inSection: section) - 1 , section: section))
                var frame = attrs.frame
                //let offset = collectionView!.contentOffset.y
                
                //let minY = attrsForFirstItemInSection!.frame.minY - frame.height
                //let maxY = attrsForLastItemInSection!.frame.maxY - frame.height
                //let y = min(max(offset, minY), maxY)
                //print("Coll-Offset:\(offset),MaxY:\(maxY),MinY:\(minY),headerY:\(y)")
                frame.origin.y = 0
                attrs.frame = frame
                attrs.zIndex = 99
                //https://youtu.be/ePCliV2CsuU
            }
        }
        return layoutAttrs
    }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

