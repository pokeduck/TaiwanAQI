//
//  DetailCollVC.swift
//  AQIDemo
//
//  Created by BenKu on 2019/8/2.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import UIKit
import PromiseKit
import SideMenu
class DetailCollVC: UIViewController {
    enum TopViewStyle {
        case menu
        case add
    }
    enum BackgroundColorStyle {
        case clear
        case blue
    }
    private let topViewStyle:TopViewStyle
    private let bgColorStyle:BackgroundColorStyle
    private var aqiele:AQIElement
    private var collVM:DetailCollVM
    lazy var topView: DetailCollTopView = {
        let v = DetailCollTopView()
        self.view.addSubview(v)
        return v
    }()
    
    var collv:UICollectionView? = nil
    private var isRefreshing = false
    lazy var refreshCtrl : RefreshCtrl = {
        let rc = RefreshCtrl()
        rc.tintColor = .white
        rc.addTarget(self, action: #selector(refreshWithControlUI), for: .valueChanged)
        return rc
    }()
    private var gradientLayer:CAGradientLayer? = nil
    
     init(with
        element:AQIElement,
        topViewStyle tvStyle:TopViewStyle = .menu,
        backgroundColor bgStyle:BackgroundColorStyle = .clear) {
        self.aqiele = element
        self.collVM = DetailCollVM(aqiele)
        self.topViewStyle = tvStyle
        self.bgColorStyle = bgStyle
        super.init(nibName: String(describing: DetailCollVC.self), bundle: nil)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        //print("AQIDetail Release")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch bgColorStyle {
        case .blue:
            addGradient()
        case .clear:
            view.backgroundColor = .clear
        }
        setupCollV()
        setupTitle()
        
      
    }
    @objc func pop(){
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    @objc func addToList(){
        MenuController.default.addTrackingSite(aqiele.siteID)
        topView.rightBtn.isHidden = true
        showAlert("成功加入追蹤列表")
    }
    @objc func showMenu(){
        switch topViewStyle {
        case .menu:
            let menu = SideMenuManager.default.leftMenuNavigationController
            present(menu!, animated: true, completion: nil)
        case .add:
            self.dismiss(animated: true, completion: nil)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //NotificationCenter.default.addObserver(self, selector: #selector(didUpdated), name: kLocalDBDidUpdated, object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
extension DetailCollVC {
    @objc func didUpdated(){
        AQIDB.queryID([self.aqiele.siteID]).done { (ele) in
            self.aqiele = ele[0]
            self.collVM = DetailCollVM(self.aqiele)
            self.collv?.reloadData()
        }.catch { (err) in
            print(err)
        }
    }
    func setupTitle() {
        let v = topView
        v.translatesAutoresizingMaskIntoConstraints = false
        let cs = [v.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                  v.leftAnchor.constraint(equalTo: view.leftAnchor),
                  v.rightAnchor.constraint(equalTo: view.rightAnchor),
                  v.heightAnchor.constraint(equalToConstant: 60)]
        NSLayoutConstraint.activate(cs)
        v.leftBtn.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        switch topViewStyle {
        case .menu:
            v.leftBtn.setImage(#imageLiteral(resourceName: "menu-button"), for: .normal)
            v.leftBtn.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        case .add:
            v.leftBtn.setImage(#imageLiteral(resourceName: "btn-cancel"), for: .normal)
            v.leftBtn.addTarget(self, action: #selector(pop), for: .touchUpInside)
            MenuController.default.readTrackingSites().done { (eles) in
                if (eles.filter({ (ele) -> Bool in
                    ele.siteID == self.aqiele.siteID
                }).count == 0) {
                    v.rightBtn.addTarget(self, action: #selector(self.addToList), for: .touchUpInside)
                }
                }.catch{ (err) in
                    print(err)
            }
            
        }
        v.titleLabel.text = aqiele.siteName
        v.backgroundColor = .clear
    }
    func setupCollV(){
        let flow = StickyHeaderLayout()
        
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 0
        let colv = UICollectionView(frame: view.bounds, collectionViewLayout: flow)
        view.addSubview(colv)
        colv.translatesAutoresizingMaskIntoConstraints = false
        colv.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        colv.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        colv.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        colv.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        colv.backgroundColor = .clear
        collVM.registerCell(colv)
        self.collv = colv
        collv?.delegate = self
        collv?.dataSource = self
        collv?.reloadData()
        collv?.showsVerticalScrollIndicator = false
        
    }
    func addGradient(){
        gradientLayer = CAGradientLayer()
        gradientLayer!.frame = self.view.bounds
        
        gradientLayer!.colors = [ThemeColor.lightBlue.cgColor, ThemeColor.darkBlue.cgColor]
        
        gradientLayer!.startPoint = CGPoint(x:0.5,y:0)
        gradientLayer!.endPoint = CGPoint(x:1,y:1)
        self.view.layer.addSublayer(gradientLayer!)
    }

    override func viewWillLayoutSubviews() {
        gradientLayer?.frame = self.view.bounds
    }
}
extension DetailCollVC: UICollectionViewDelegate {
    //Write Delegate Code Here
    
}
extension DetailCollVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return collVM.cellCnt
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collVM.drawCell(collectionView, atIndex: indexPath)
    }
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collVM.headerView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath) as! HeaderView
//        header.delegate = self
//        return header
//    }
}
extension DetailCollVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collVM.cellSize(collectionView, sizeForIdx: indexPath)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return collVM.headerSize(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section)
//    }
}

extension DetailCollVC: HeaderMenuDelegate {
    func pressMenuBtn(_ headerView: HeaderView) {
        self.navigationController?.popViewController(animated: true)
    }

}
extension DetailCollVC {
    
    @objc func refreshWithControlUI(){
        if isRefreshing  { return }
        isRefreshing = true
        AQIDataFetcher.updateAQIs()
        .then{ aqis in
            AQIDB.updateData(with: aqis)
        }.then{ _ in
            AQIDB.query(self.aqiele.siteName)
        }.then { (eles) -> Promise<Void> in
            if let ele = eles.first {
                self.aqiele = ele
                self.collVM = DetailCollVM(ele)
            }
            return self.refreshCtrl.end(1.0)
        }.catch{ error in
            Util.showAlert(error.localizedDescription)
            self.refreshCtrl.end()
        }.finally {
            self.isRefreshing = false
            self.collv?.reloadData()
        }
    }
}


