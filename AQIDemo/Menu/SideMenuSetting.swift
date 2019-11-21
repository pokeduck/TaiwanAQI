//
//  SideMenuSetting.swift
//  AQIDemo
//
//  Created by BenKu on 2019/8/19.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import Foundation
import SideMenu
enum SideMenuSetting {
    static func setupControl(){
        let menu = SideMenuNavigationController(rootViewController: MenuVC())
        menu.leftSide = true
        menu.settings.statusBarEndAlpha = 1.0
        menu.settings.menuWidth =  250
        menu.settings.presentationStyle.backgroundColor = .clear
        SideMenuManager.default.leftMenuNavigationController = menu
    }
}
