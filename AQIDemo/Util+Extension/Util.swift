//
//  Util.swift
//  AQIDemo
//
//  Created by BenKu on 2019/8/3.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import UIKit
enum Util {
    static func showAlert(_ msg:String){
        let rootvc = UIApplication.shared.keyWindow?.rootViewController!
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "好", style: .default, handler: nil))
        rootvc?.present(alert, animated: true, completion: nil)
    }
}
extension UIViewController{
    func showAlert(_ msg:String){
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "好", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
