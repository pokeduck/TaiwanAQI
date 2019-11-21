//
//  MenuVC.swift
//  AQIDemo
//
//  Created by BenKu on 2019/8/19.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import UIKit
import SideMenu
import PromiseKit

fileprivate let tvCellID = "cellID"

class MenuVC: UIViewController{
    var vm:MenuCellVM = MenuCellVM()
    var tv:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient()
        view.backgroundColor = ThemeColor.menuGrouped
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .clear
        tv = UITableView(frame: .zero
            , style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .clear
        tv.register(UITableViewCell.self, forCellReuseIdentifier: tvCellID)
        view.addSubview(tv)
        tv.fillSafeArea()
        tv.showsVerticalScrollIndicator = false
        tv.separatorColor = .clear
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        refresh()

        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    func addGradient(){
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurView)
        blurView.fill()
    }
    func refresh() {
        var aqis:Aqi = []
        firstly{ () -> Promise<Aqi> in
            MenuController.default.readUserNearSite()
            }.then { (eles) -> Promise<Aqi> in
                aqis = eles
                return MenuController.default.readTrackingSites()
            }.done { (eles) in
                aqis.append(contentsOf: eles)
                self.vm = MenuCellVM(aqis)
                self.tv.reloadData()
            }.catch { (error) in
                print(error)
        }
    }

}


extension MenuVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.rowAtSction(section: section)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return vm.section()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return vm.drawCell(at: indexPath, tv: tableView)
    }

}
extension MenuVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vm.didSelectRow(at: indexPath, tv: tv, originVC: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let _ = view as? UITableViewHeaderFooterView {
            let headerView = view as! UITableViewHeaderFooterView;
            headerView.backgroundView?.backgroundColor = ThemeColor.darkBlack
            
            //Other colors you can change here
            // headerView.backgroundColor = myColor
            // headerView.contentView.backgroundColor = myColor
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let _ = view as?  UITableViewHeaderFooterView {
            let footerView = view as! UITableViewHeaderFooterView;
            footerView.backgroundView?.backgroundColor =  ThemeColor.menuCellBg
            //Other colors you can change here
            //footerView.backgroundColor = myColor
            //footerView.contentView.backgroundColor = myColor
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = ThemeColor.menuHighlightBlack
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = ThemeColor.menuGroupedCell
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
}

protocol MenuCellActionImpl {
    func didSelectRow(at idxPath:IndexPath,tv:UITableView,originVC:UIViewController)
    func drawCell(at idxPath:IndexPath,tv:UITableView) -> UITableViewCell
}
struct MenuCellVM: MenuCellActionImpl {
    
    var sites:[MenuCellActionImpl] = []
    var mapVM = MenuCellMapVM()
    init(_ eles:Aqi? = nil){
        if eles == nil { return }
        sites.append(MenuCellEditVM())
        eles!.forEach { (ele) in
            sites.append(MenuCellSitesVM(ele))
        }
    }
    
    func didSelectRow(at idxPath: IndexPath, tv: UITableView, originVC: UIViewController) {
        if idxPath.section == 0 {
            sites[idxPath.row].didSelectRow(at: idxPath, tv: tv, originVC: originVC)
        }else {
            mapVM.didSelectRow(at: idxPath, tv: tv, originVC: originVC)
        }
    }
    
    func drawCell(at idxPath: IndexPath, tv: UITableView) -> UITableViewCell {
        if idxPath.section == 0 {
            return sites[idxPath.row].drawCell(at: idxPath, tv: tv)
        }else {
            return mapVM.drawCell(at: idxPath, tv: tv)
        }
    }
    func section()-> Int {
        return 2
    }
    func rowAtSction(section:Int) -> Int{
        if section == 0{
            return sites.count
        }else {
            return 1
        }
    }
    
}
struct MenuCellEditVM : MenuCellActionImpl {
    func didSelectRow(at idxPath: IndexPath, tv: UITableView, originVC: UIViewController) {
        guard let nv = originVC.navigationController as? SideMenuNavigationController,
            let _ = nv.presentingViewController
            else { return }
        
        //nv.dismiss(animated: true, completion: nil)
//        rnv.present(MenuEditCtrler(), animated: true, completion: nil)
        let editVC = MenuEditVC()
        editVC.modalPresentationStyle = .fullScreen
        originVC.present(editVC, animated: true, completion: nil)
    }
    
    func drawCell(at idxPath: IndexPath, tv: UITableView) -> UITableViewCell {
        let cell = tv.dequeueReusableCell(withIdentifier: tvCellID, for: idxPath)
        cell.textLabel?.text = "編輯監測站"
        cell.imageView?.image = #imageLiteral(resourceName: "ic-site")
        cell.textLabel?.textColor = .white
        cell.imageView?.tintColor = .yellow
        cell.imageView?.contentMode = .scaleAspectFit
        cell.backgroundColor = ThemeColor.menuGroupedCell
        cell.selectionStyle = .none
        return cell
    }
    
    
}
struct MenuCellSitesVM: MenuCellActionImpl {
    let aqi:AQIElement
    
    func didSelectRow(at idxPath: IndexPath, tv: UITableView, originVC: UIViewController) {
        guard let nv = originVC.navigationController as? SideMenuNavigationController,
        let rnv = nv.presentingViewController as? UINavigationController
            else { return }
        if let pgvc = rnv.viewControllers.first as? PagingVC,
            pgvc.currentIndex != (idxPath.row - 1)  {
                pgvc.selectIndex(idxPath.row - 1 )
        }else {
            rnv.viewControllers = [PagingVC(aqi.siteID)]
        }
       nv.dismiss(animated: true, completion: nil)
    }
    
    func drawCell(at idxPath: IndexPath, tv: UITableView) -> UITableViewCell {
        let cell = tv.dequeueReusableCell(withIdentifier: tvCellID, for: idxPath)
        cell.textLabel?.text = idxPath.row == 1 ? "附近監測站" : aqi.siteName
        cell.imageView?.image = #imageLiteral(resourceName: "ic-site")
        cell.textLabel?.textColor = .white
        cell.imageView?.tintColor = .white
        cell.backgroundColor = ThemeColor.menuGroupedCell
        cell.selectionStyle = .none
        return cell
    }
    init(_ aqi:AQIElement) {
        self.aqi = aqi
    }
}
struct MenuCellMapVM : MenuCellActionImpl {
    func didSelectRow(at idxPath: IndexPath, tv: UITableView, originVC: UIViewController) {
        guard let nv = originVC.navigationController as? SideMenuNavigationController,
            let rnv = nv.presentingViewController as? UINavigationController
            else { return }
        nv.dismiss(animated: true, completion: nil)
        guard let _ = rnv.viewControllers.first as? SiteMapVC else {
            rnv.viewControllers = [SiteMapVC()]
            return
        }
        
    }
    
    func drawCell(at idxPath: IndexPath, tv: UITableView) -> UITableViewCell {
        let cell = tv.dequeueReusableCell(withIdentifier: tvCellID, for: idxPath)
        cell.textLabel?.text = "監測站地圖"
        cell.imageView?.image = #imageLiteral(resourceName: "ic-map")
        cell.textLabel?.textColor = .white
        cell.imageView?.tintColor = .white
        cell.backgroundColor = ThemeColor.menuGroupedCell
        cell.selectionStyle = .none

        return cell
    }
    
    
}
