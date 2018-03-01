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
    var startFrame = CGRect.init()
    /// 是否需要自定义动画
    var customAnimationType: ToNextPageAnimationType = .none
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "模仿YouTube转场动画"
        self.view.backgroundColor = UIColor.yellow
        
        self.initAllTableV()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.delegate = self // 否则转场动画不执行。
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
        // 获取cell的frame
        let rectInTable = tableView.rectForRow(at: indexPath)
        let cellRectInView = tableView.convert(rectInTable, to: self.view)
        /// 弹出youtube
        YouTubeView.showYouTube(startFrame: cellRectInView)
    }
    
    override func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == UINavigationControllerOperation.push {
            if customAnimationType == .zoomInPush { // 放大动画
                let push = ZoomInTransitionPush()
                push.startFrame = startFrame
                return push
            }
        }
        return nil
    }
    
    
}

