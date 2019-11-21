//
//  MenuAddSiteVC.swift
//  AQIDemo
//
//  Created by BenKu on 2019/8/20.
//  Copyright © 2019 Pokeduck.Studio. All rights reserved.
//

import UIKit

class MenuAddSiteVC: UITableViewController {
    let aqis:Aqi
    let selectedHandler:SelectedSiteHandler
    init(aqis:Aqi,selectedHandler:@escaping SelectedSiteHandler) {
        self.aqis = aqis
        self.selectedHandler = selectedHandler
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "選擇監測站"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.menuPlainDarkMode()
        
        tableView.reloadData()
        
        let rightItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismiss_))
        let leftItem = UIBarButtonItem(image: #imageLiteral(resourceName: "btn-back"), style: .plain, target: self, action: #selector(pop))
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
        
        

    }
    @objc func pop(){
        navigationController?.popViewController(animated: true)
    }
    @objc func dismiss_(){
        dismiss(animated: true, completion: nil)
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aqis.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = aqis[indexPath.row].siteName
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.selectionStyle = .none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let site = aqis[indexPath.row]
        dismiss(animated: true) {
            self.selectedHandler(site)
        }
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
