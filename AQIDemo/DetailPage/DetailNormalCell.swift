//
//  DetailNormalCell.swift
//  AQIDemo
//
//  Created by BenKu on 2019/8/13.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import UIKit
class CollBaseCell: UICollectionViewCell {
    private var topLineLeftConstraint:NSLayoutConstraint? = nil
    private var topLineRightConstraint:NSLayoutConstraint? = nil
    
    lazy var topLine:UIView = {
        let v = UIView()
        self.contentView.addSubview(v)
        let cs = v.adjToTopLine()
        self.topLineLeftConstraint = cs[.left]
        self.topLineRightConstraint = cs[.right]
        return v
    }()
    enum SeparateLine {
        case top
        //case bottom
    }
    func adjustLineMargin(_ left:CGFloat = 0.0,
                          _ right:CGFloat = 0.0,
                          position:SeparateLine = .top) {
        switch position {
        case .top:
            topLineLeftConstraint?.constant = left
            topLineRightConstraint?.constant = -right
        }
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        cellInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        cellInit()
    }
    private func cellInit(){
        let _ = topLine
        backgroundColor = .clear
    }
}
class CollOneLabelCell: CollBaseCell {
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        self.contentView.addSubview(l)
        return l
    }()
}
////
class CollTitleCell: CollOneLabelCell {
    override func draw(_ rect: CGRect) {
        titleLabel.drawShadow()
        titleLabel.font = UIFont.systemFont(ofSize: 30.0)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.fill()
        topLine.isHidden = true
    }
}


class CollHintCell: CollOneLabelCell {
    override func draw(_ rect: CGRect) {
        adjustLineMargin(20, 20)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .white
        titleLabel.drawShadow()
        titleLabel.font = UIFont.systemFont(ofSize: 16.0)
        titleLabel.numberOfLines = 2
        titleLabel.fill(withMargin: 0, left: 20, bottom: 0, right: 20)
    }
}
class CollPublishCell: CollOneLabelCell {
    override func draw(_ rect: CGRect) {
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 11.0)
        titleLabel.textColor = "D3D3D3".color
        titleLabel.numberOfLines = 2
        titleLabel.fill()
    }
}

import IntentsUI
@available(iOS 12.0, *)
class CollSiriCell: UICollectionViewCell {
    lazy var addSiriBtn = INUIAddVoiceShortcutButton(style: .whiteOutline)
    override func draw(_ rect: CGRect) {
        contentView.addSubview(addSiriBtn)
        addSiriBtn.translatesAutoresizingMaskIntoConstraints = false
        addSiriBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        addSiriBtn.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
