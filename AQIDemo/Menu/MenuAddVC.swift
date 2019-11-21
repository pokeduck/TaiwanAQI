//
//  MenuAddVC.swift
//  AQIDemo
//
//  Created by BenKu on 2019/8/20.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import UIKit
import PromiseKit

typealias SelectedSiteHandler = (AQIElement) -> Void

class MenuAddVC: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = .white
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = ThemeColor.menuTopBar
        let navigationTitleFont = UIFont(name: "Avenir", size: 20)!
        
        navigationBar.titleTextAttributes =
            [NSAttributedString.Key.font: navigationTitleFont,
             NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    convenience init(handler : @escaping SelectedSiteHandler) {
        self.init(rootViewController: MenuAddTVC(handler: handler))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
class MenuAddTVC: UITableViewController {
    enum Cou:String {
        case kee = "基隆市"
        case tpe = "臺北市"
        case ntp = "新北市"
        case tao = "桃園市"
        case hsin = "新竹縣"
        case hsin_cty = "新竹市"
        case miao = "苗栗縣"
        case tchun = "臺中市"
        case chan = "彰化縣"
        case nan = "南投縣"
        case yun = "雲林縣"
        case chia = "嘉義縣"
        case chia_cty = "嘉義市"
        case tna = "臺南市"
        case kao = "高雄市"
        case pin = "屏東縣"
        case yi = "宜蘭縣"
        case hua = "花蓮縣"
        case ttun = "臺東縣"
        case pen = "澎湖縣"
        case kin = "金門縣"
        case lien = "連江縣"
    }
    var sites:Aqi = []
    lazy var ctys:[String] = {
        return [Cou.kee.rawValue,
                Cou.tpe.rawValue,
                Cou.ntp.rawValue,
                Cou.tao.rawValue,
                Cou.hsin.rawValue,
                Cou.hsin_cty.rawValue,
                Cou.miao.rawValue,
                Cou.tchun.rawValue,
                Cou.chan.rawValue,
                Cou.nan.rawValue,
                Cou.yun.rawValue,
                Cou.chia.rawValue,
                Cou.chia_cty.rawValue,
                Cou.tna.rawValue,
                Cou.kao.rawValue,
                Cou.pin.rawValue,
                Cou.yi.rawValue,
                Cou.hua.rawValue,
                Cou.ttun.rawValue,
                Cou.pen.rawValue,
                Cou.kin.rawValue,
                Cou.lien.rawValue]
    }()
    var countyAqis:[String:Aqi] = [:]
    
    let selectedHandler:SelectedSiteHandler
    init(handler : @escaping SelectedSiteHandler) {
        self.selectedHandler = handler

        super.init(style: .plain)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "選擇縣市"
        let rightItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismiss_))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.leftBarButtonItem?.title = nil
        navigationItem.rightBarButtonItem = rightItem
        
        tableView.menuPlainDarkMode()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        firstly { () -> Promise<Aqi> in
            AQIDB.query()
            }.done { (eles) in
                self.sites = eles
                eles.forEach({ (ele) in
                    var a = self.countyAqis[ele.county] ?? []
                    a.append(ele)
                    self.countyAqis[ele.county] = a
                })
                self.tableView.reloadData()
            }.catch { (err) in
                print(err)
        }
        
    }
    @objc func dismiss_(){
        dismiss(animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ctys.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = ctys[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        cell.selectionStyle = .none

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cty = ctys[indexPath.row]
        guard let sites = countyAqis[cty] else { return }
        navigationController?.pushViewController(MenuAddSiteVC(aqis: sites, selectedHandler: self.selectedHandler), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = ThemeColor.menuHighlightBlack
    }

    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = .clear
    }
}
