//
//  RefreshCtrl.swift
//  AQIDemo
//
//  Created by BenKu on 2019/8/19.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import UIKit
import PromiseKit
class RefreshCtrl:UIRefreshControl {
    private var timer:Timer? = nil
    private var startDate:Date = Date()
    override init() {
        super.init()
        self.addTarget(self, action: #selector(begin), for: .valueChanged)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func removeFromSuperview() {
        super.removeFromSuperview()
        timer?.invalidate()
    }
    func setup(){
        let line = UIView()
        addSubview(line)
        line.adjToBottomLine()
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        
    }
    @objc func begin() {
        if isRefreshing {
            self.startDate = Date()
        }
    }
    @discardableResult
    func end(_ minTime:TimeInterval = 0.0) -> Promise<Void>{
        return Promise { seal in
            let currentDate = Date()
            let gap = currentDate.timeIntervalSince(startDate)
            if gap > minTime {
                endRefreshing()
                seal.fulfill_()
            }else {
                timer = Timer.scheduledTimer(withTimeInterval: minTime - gap, repeats: false) { (_) in
                    self.endRefreshing()
                    seal.fulfill_()
                }
            }
        }
        
    }
}
