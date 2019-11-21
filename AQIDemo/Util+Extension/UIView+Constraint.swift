//
//  UIView+Constraint.swift
//  AQIDemo
//
//  Created by BenKu on 2019/8/2.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import UIKit
extension UIView {
    func fill(withMargin top:CGFloat = 0,left:CGFloat = 0,bottom:CGFloat = 0,right:CGFloat = 0){
        let s = superview!
        self.translatesAutoresizingMaskIntoConstraints = false
        let cs =
            [self.topAnchor.constraint(equalTo: s.topAnchor,constant: top),
             self.bottomAnchor.constraint(equalTo: s.bottomAnchor,constant: -bottom),
             self.leftAnchor.constraint(equalTo: s.leftAnchor,constant: left),
             self.rightAnchor.constraint(equalTo: s.rightAnchor,constant: -right)]
        NSLayoutConstraint.activate(cs)
    }
    func fillSafeArea(withMargin top:CGFloat = 0,left:CGFloat = 0,bottom:CGFloat = 0,right:CGFloat = 0){
        let s = superview!
        self.translatesAutoresizingMaskIntoConstraints = false
        let cs =
            [self.topAnchor.constraint(equalTo: s.safeAreaLayoutGuide.topAnchor,constant: top),
             self.bottomAnchor.constraint(equalTo: s.safeAreaLayoutGuide.bottomAnchor,constant: -bottom),
             self.leftAnchor.constraint(equalTo: s.safeAreaLayoutGuide.leftAnchor,constant: left),
             self.rightAnchor.constraint(equalTo: s.safeAreaLayoutGuide.rightAnchor,constant: -right)]
        NSLayoutConstraint.activate(cs)
    }
    
    @discardableResult
    func adjToTopLine(withMargin left:CGFloat = 0,right:CGFloat = 0) -> [NSLayoutConstraint.Attribute:NSLayoutConstraint]{
        let sv = superview!
        self.translatesAutoresizingMaskIntoConstraints = false
        let leftMargin = self.leftAnchor.constraint(equalTo: sv.leftAnchor,constant: left)
        let rightMargin = self.rightAnchor.constraint(equalTo: sv.rightAnchor,constant: -right)
        let cs = [topAnchor.constraint(equalTo: sv.topAnchor),
                  heightAnchor.constraint(equalToConstant: 0.5),
                  leftMargin,rightMargin]
        NSLayoutConstraint.activate(cs)
        self.alpha = 0.8
        self.backgroundColor = .white
        return [.left:leftMargin,.right:rightMargin]
    }
    @discardableResult
    func adjToBottomLine(withMargin left:CGFloat = 0,right:CGFloat = 0) -> [NSLayoutConstraint.Attribute:NSLayoutConstraint]{
        let sv = superview!
        self.translatesAutoresizingMaskIntoConstraints = false
        let leftMargin = self.leftAnchor.constraint(equalTo: sv.leftAnchor,constant: left)
        let rightMargin = self.rightAnchor.constraint(equalTo: sv.rightAnchor,constant: -right)
        let cs = [bottomAnchor.constraint(equalTo: sv.bottomAnchor),
                  heightAnchor.constraint(equalToConstant: 0.5),
                  leftMargin,rightMargin]
        NSLayoutConstraint.activate(cs)
        self.alpha = 0.8
        self.backgroundColor = .white
        return [.left:leftMargin,.right:rightMargin]
    }
    func removeAllConstraints() {
        var _sv = self.superview
        
        while let sv = _sv {
            for constraint in sv.constraints {
                
                if let first = constraint.firstItem as? UIView, first == self {
                    sv.removeConstraint(constraint)
                }
                
                if let second = constraint.secondItem as? UIView, second == self {
                    sv.removeConstraint(constraint)
                }
            }
            
            _sv = sv.superview
        }
        
        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = true
        //https://stackoverflow.com/a/30491911/9186699
    }
    var leftConstraint:NSLayoutConstraint? {
        let sv:UIView! = self.superview!
        let cs = sv.constraints
        func isLeft(_ constraint:NSLayoutConstraint) -> Bool {
            if constraint.firstAttribute == .left &&
                constraint.secondAttribute == .left { return true}
            return false
        }
        for i in 0 ..< cs.count {
            let c = cs[i]
            if let item = c.firstItem,
                item.isEqual(self){
                if isLeft(c) {return c}
            }
        }
        return nil
    }
    var rightConstraint:NSLayoutConstraint? {
        let sv:UIView! = self.superview!
        let cs = sv.constraints
    
        func isRight(_ constraint:NSLayoutConstraint) -> Bool {
            if constraint.firstAttribute == .right &&
                constraint.secondAttribute == .right { return true}
            return false
        }
        for i in 0 ..< cs.count {
            let c = cs[i]
            if let item = c.firstItem,
                item.isEqual(self){
                if isRight(c) {return c}
            }
        }
        return nil
    }
}
extension UINavigationBar {
    
    func setBottomBorderColor(color: UIColor, height: CGFloat) {
        let bottomBorderRect = CGRect(x: 0, y: frame.height, width: frame.width, height: height)
        let bottomBorderView = UIView(frame: bottomBorderRect)
        bottomBorderView.backgroundColor = color
        addSubview(bottomBorderView)
    }
}
