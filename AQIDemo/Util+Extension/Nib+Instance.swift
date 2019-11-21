//
//  Nib+Instance.swift
//  AQIDemo
//
//  Created by BenKu on 2019/7/31.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import UIKit
protocol NibInstantiable {}

extension UIView: NibInstantiable {}

extension NibInstantiable where Self: UIView {
    static func instantiateFromNib() -> Self {
        if let view = Bundle(for: self).loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as? Self {
            return view
        } else {
            assert(false, "The nib named \(self) is not found")
            return Self()
        }
    }
    static func nib() -> UINib {
        return UINib(nibName: String(describing: Self.self), bundle: nil)
    }
}
