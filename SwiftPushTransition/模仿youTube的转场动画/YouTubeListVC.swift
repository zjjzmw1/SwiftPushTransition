//
//  YouTubeListVC.swift
//  SwiftPushTransition
//
//  Created by zhangmingwei on 2018/2/28.
//  Copyright © 2018年 zhangmingwei. All rights reserved.
//

import UIKit

class YouTubeListVC: BaseVC {

    var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "模仿YouTube转场动画"
        self.view.backgroundColor = UIColor.yellow
        
        self.initAllTableV()
        
    }
    
    /// 初始化表格
    func initAllTableV() {
        tableView = UITableView.init(frame: self.view.frame, style: .plain)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
}

extension YouTubeListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = String.init(format: "第%d行",indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = YouTubeDetailVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

