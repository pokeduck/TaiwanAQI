//
//  DetailCollTopView.swift
//  AQIDemo
//
//  Created by BenKu on 2019/8/19.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import UIKit

class DetailCollTopView: UIView {
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        self.addSubview(l)
        l.drawShadow()
        l.font = UIFont.systemFont(ofSize: 28.0)
        l.textAlignment = .center
        l.textColor = .white
        l.fill(withMargin: 0, left: 40, bottom: 0, right: 40)
        return l
    }()
    lazy var leftBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = UIColor.white
        btn.frame = CGRect(x: 20, y: 60, width: 40, height: 40)
        addSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        btn.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor,constant: 5.0).isActive = true
        btn.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        btn.widthAnchor.constraint(equalTo: btn.heightAnchor, multiplier: 1.0).isActive = true
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    lazy var rightBtn : UIButton = {
        let btn = UIButton(type: .contactAdd)
        btn.tintColor = UIColor.white
        btn.frame = CGRect(x: 20, y: 60, width: 40, height: 40)
        addSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        btn.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor,constant: -5.0).isActive = true
        btn.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        btn.widthAnchor.constraint(equalTo: btn.heightAnchor, multiplier: 1.0).isActive = true
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
}
