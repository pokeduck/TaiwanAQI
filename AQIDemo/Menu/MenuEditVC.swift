//
//  MenuEditVC.swift
//  AQIDemo
//
//  Created by BenKu on 2019/8/19.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import UIKit
import PromiseKit

let didLastAddKey = Notification.Name.init(rawValue: "did.last.add.key")
let didEditedSiteKey = Notification.Name.init(rawValue: "did.add.site.key")
fileprivate let cellid = "cellID"
class MenuEditVC : UIViewController {
    var sites:Aqi = []
    var tableView:UITableView!
    var navBar:UINavigationBar = UINavigationBar(frame: .zero)
    var lastAddSiteID:String?
    var hasEdited = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopBar()
        setupTableView()
        
        
        MenuController.default.readTrackingSites().done { (aqis) in
            self.sites = aqis
            self.tableView.reloadData()
            }.catch { (error) in
                print(error.localizedDescription)
        }
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    private func setupTableView(){
        view.backgroundColor = ThemeColor.menuTopBar
        
        tableView = UITableView(frame: .zero, style: .plain)
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let cs = [tableView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
                  tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                  tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
                  tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        NSLayoutConstraint.activate(cs)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellid)
        tableView.isEditing = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.menuPlainDarkMode()
    }
    private func setupTopBar(){
        navBar.tintColor = .white
        navBar.isTranslucent = false
        navBar.barTintColor = ThemeColor.menuTopBar
        
        view.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        let cs = [navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                  navBar.leftAnchor.constraint(equalTo: view.leftAnchor),
                  navBar.rightAnchor.constraint(equalTo: view.rightAnchor),
                  navBar.heightAnchor.constraint(equalToConstant: 44)]
        NSLayoutConstraint.activate(cs)
        let leftItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        let rightItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let navItem = UINavigationItem(title: "")
        navItem.leftBarButtonItem = leftItem
        navItem.rightBarButtonItem = rightItem
        navBar.items = [navItem]
    }
    @objc func add(){
        let addVC = MenuAddVC { (ele) in
            if self.sites.query(with: ele.siteID.int) != nil {
                self.showAlert("Already Chose Location")
                return
            }
            self.lastAddSiteID = ele.siteID
            self.hasEdited = true
            self.sites.append(ele)
            self.tableView.reloadData()
            self.scrollToLast()
        }
        addVC.modalPresentationStyle = .fullScreen;
        present(addVC, animated: true, completion: nil)
    }
    @objc func done(){
        if sites.count < 1 {
            showAlert("請至少追蹤一個監測站")
            return
        }
        let ids = sites.map { (ele) -> String in
            return ele.siteID
        }
        MenuController.default.saveUserTrackingSite(ids)
        if (hasEdited) {
            NotificationCenter.default.post(name: didEditedSiteKey, object: nil)
        }
        if lastAddSiteID != nil {
            NotificationCenter.default.post(name: didLastAddKey, object: lastAddSiteID)
        }
        dismiss(animated: true, completion: nil)
    }
    private func scrollToLast(){
        let lastRow = tableView.numberOfRows(inSection: 0) - 1
        let lastIdx = IndexPath(row: lastRow, section: 0)
        tableView.scrollToRow(at: lastIdx, at: .bottom, animated: true)
    }

    
   
}
extension MenuEditVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath)
        cell.textLabel?.text = sites[indexPath.row].siteName
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sites.count
    }
}
extension MenuEditVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            sites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            hasEdited = true
        case .insert:
            print("nothing")
        case .none:
            print("nothing")
        default:
            print("nothing")
        }
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let ele = sites[sourceIndexPath.row]
        sites.remove(at: sourceIndexPath.row)
        sites.insert(ele, at: destinationIndexPath.row)
        hasEdited = true
    }
}
