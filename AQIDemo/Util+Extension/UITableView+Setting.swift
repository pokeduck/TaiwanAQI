//
//  UITableView+Setting.swift
//  AQIDemo
//
//  Created by BenKu on 2019/8/20.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import UIKit
extension UITableView {
    func menuPlainDarkMode(){
        separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        separatorColor =  ThemeColor.menuSeparatorLine
        backgroundColor = ThemeColor.menuCellBg
        showsVerticalScrollIndicator = false
        let footer = UIView(frame: .zero)
        tableFooterView = footer
    }
    func menuGroupDarkMode(){
        
    }
}
