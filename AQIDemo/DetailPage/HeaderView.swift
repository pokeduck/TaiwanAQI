//
//  HeaderView.swift
//  AQIDemo
//
//  Created by BenKu on 2019/8/17.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import UIKit
protocol HeaderMenuDelegate: AnyObject {
    func pressMenuBtn(_ headerView:HeaderView)
}
class HeaderView: UICollectionReusableView {

    weak var delegate: HeaderMenuDelegate? 

    lazy var titleLabel: UILabel = {
        let l = UILabel()
        self.addSubview(l)
        l.drawShadow()
        l.font = UIFont.systemFont(ofSize: 30.0)
        l.textAlignment = .center
        l.textColor = .white
        l.fillSafeArea(withMargin: 0, left: 40, bottom: 0, right: 40)
        return l
    }()
    lazy var menuBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "menu-button"), for: .normal)
        btn.tintColor = UIColor.white
        btn.frame = CGRect(x: 20, y: 60, width: 40, height: 40)
        addSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        btn.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor,constant: 8.0).isActive = true
        btn.rightAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        btn.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        btn.imageView?.contentMode = .scaleAspectFit
        btn.addTarget(self, action: #selector(menuPress), for: .touchUpInside)
        return btn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ThemeColor.lightBlue
        let _ = titleLabel
        let _ = menuBtn
    }
    private func setupBlur() {
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bounds
        blurView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blurView)
        blurView.fill()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func menuPress() {
        delegate?.pressMenuBtn(self)
    }
    
}
