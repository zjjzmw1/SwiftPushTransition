//
//  CustomPercentInteractiveVC.swift
//  SwiftPushTransition
//
//  Created by zhangmingwei on 2018/2/26.
//  Copyright © 2018年 zhangmingwei. All rights reserved.
//

import UIKit

class CustomPercentInteractiveVC: BaseVC {

    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "自定义的下拉返回"
        self.fd_prefersNavigationBarHidden = true
        self.view.backgroundColor = UIColor.gray
        
        self.initAllTableV()
        
        let btn = UIButton.init(frame: CGRect.init(x: 10, y: 80, width: 100, height: 100))
        btn.backgroundColor = UIColor.green
        btn.addTarget(self, action: #selector(goTestVC), for: .touchUpInside)
        self.view.addSubview(btn)
        
        // 支持下拉返回 -- 第一步
        self.popFromTop = true
        self.popFromLeft = true
        self.popFromTopWithScrollView = true
    }
    
    /// 初始化表格
    func initAllTableV() {
        tableView = UITableView.init(frame: self.view.frame, style: .plain)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    @objc func goTestVC() {
        let vc = TestVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CustomPercentInteractiveVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = String.init(format: "第%d行",indexPath.row)
        return cell
    }
    
    
}



