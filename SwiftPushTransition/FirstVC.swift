//
//  FirstVC.swift
//  SwiftPushTransition
//
//  Created by zhangmingwei on 2018/2/7.
//  Copyright © 2018年 zhangmingwei. All rights reserved.
//

import UIKit

class FirstVC: BaseVC {
    var btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.green
        self.title = "第一页"

        btn = UIButton.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(goAction), for: .touchUpInside)
        btn.setTitle("第二页", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.red
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.delegate = self
    }
    
    @objc func goAction() {
        let vc = SecondVC()
        vc.startFrame = btn.frame // 需要返回动画的时候添加
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == UINavigationControllerOperation.push {
            let push = PointTransitionPush()
            push.startFrame = btn.frame
            return push
        }
        return nil
    }

}
