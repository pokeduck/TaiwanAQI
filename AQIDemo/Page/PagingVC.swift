//
//  PagingVC.swift
//  AQIDemo
//
//  Created by BenKu on 2019/8/21.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import UIKit
import Parchment
import PromiseKit
class PagingVC: UIViewController {
    private var currentIndex_:Int = 0
    private var currentSiteID:String?
    private var firstLoad = true
    private var sites:Aqi = []
    private var reloading = false
    private let pagingVC = PagingViewController<PagingIndexItem>()
    private let gradientLayer = CAGradientLayer()
    var currentIndex:Int {
        get { return currentIndex_ }
    }
    convenience init(_ siteID:String) {
        self.init(nibName:nil,bundle:nil)
        self.currentSiteID = siteID
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addGradient()
        setupPagingVC()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEditeddSite), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEditeddSite), name: kLocalDBDidUpdated, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEditeddSite), name: didEditedSiteKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLastAddSiteID(_:)), name: didLastAddKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(nearSiteUpdated(_:)), name: kUserNearSiteUpdated, object: nil)

    }
    deinit {
        //print("Paging Release")
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
    }
    override func viewWillLayoutSubviews() {
        gradientLayer.frame = view.bounds
    }
    func addGradient(){
        
        gradientLayer.frame = view.bounds
        
        gradientLayer.colors = [ThemeColor.lightBlue.cgColor, ThemeColor.darkBlue.cgColor]
        
        gradientLayer.startPoint = CGPoint(x:0.5,y:0)
        gradientLayer.endPoint = CGPoint(x:0.5,y:1)
        view.layer.addSublayer(gradientLayer)
    }
    func setupPagingVC() {
        pagingVC.dataSource = self
        pagingVC.delegate = self
        pagingVC.menuItemSize = .fixed(width: 0, height: 0)
        addChild(pagingVC)
        view.addSubview(pagingVC.view)
        pagingVC.view.fill()
        pagingVC.didMove(toParent: self)
    }
    private func refresh() {
        firstly{ () -> Promise<Aqi> in
            MenuController.default.readUserNearSite()
            }.then { (eles) -> Promise<Aqi> in
                self.sites = eles
                return MenuController.default.readTrackingSites()
            }.done { (eles) in
                self.sites.append(contentsOf: eles)
                self.updateIndexID()
                self.reloading = true
                self.pagingVC.reloadData()
                self.reloading = false
                self.pagingVC.select(index: self.currentIndex_)
            }.catch { (error) in
                print(error)
        }
    }

    private func updateIndexID(){
        if currentSiteID != nil {
            for i in 0..<self.sites.count{
                if sites[i].siteID == currentSiteID{
                    currentIndex_ = i
                    return
                }
            }
            currentIndex_ = sites.count - 1
        }else {
            currentIndex_ = 0
            firstLoad = false
        }
    }
}
// MARK: Notification
extension PagingVC {
    @objc func nearSiteUpdated(_ notifyObj:Notification){
        guard let obj = notifyObj.object,
        let site = obj as? AQIElement
            else { return}
        sites.remove(at: 0)
        sites.insert(site, at: 0)
        reloading = true
        pagingVC.reloadData()
        reloading = false
    }
    @objc func updateLastAddSiteID(_ notifyObj:Notification){
        guard let obj = notifyObj.object,
            let sid = obj as? String
            else { return }
        self.currentSiteID = sid
    }
    @objc func didEditeddSite(){
        refresh()
    }
}
extension PagingVC {
    func selectIndex(_ index:Int){
        if index == currentIndex_ { return }
        pagingVC.select(index: index ,animated: false)
    }
}
extension PagingVC: PagingViewControllerDataSource {
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemForIndex index: Int) -> T {
        
        return PagingIndexItem(index: index, title: sites[index].siteID) as! T
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForIndex index: Int) -> UIViewController {
        return DetailCollVC(with: sites[index])
    }
    
    func numberOfViewControllers<T>(in: PagingViewController<T>) -> Int {
        return sites.count
    }
  
}
extension PagingVC: PagingViewControllerDelegate {
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, didScrollToItem pagingItem: T, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) where T : PagingItem, T : Comparable, T : Hashable {
        if reloading { return }
        guard let item = pagingItem as? PagingIndexItem else { return }
        currentIndex_ = item.index
        currentSiteID = item.title
        print(item.index)
    }
}
