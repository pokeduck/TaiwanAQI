//
//  BaseNavigationController.swift
//  AQIDemo
//
//  Created by BenKu on 2019/8/22.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)

        // Do any additional setup after loading the view.
    }
}
