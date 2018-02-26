//
//  CustomPercentInteractiveVC.swift
//  SwiftPushTransition
//
//  Created by zhangmingwei on 2018/2/26.
//  Copyright © 2018年 zhangmingwei. All rights reserved.
//

import UIKit

class CustomPercentInteractiveVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "自定义的下拉返回"
        self.fd_prefersNavigationBarHidden = true
        self.view.backgroundColor = UIColor.gray
        
        let btn = UIButton.init(frame: CGRect.init(x: 10, y: 80, width: 100, height: 100))
        btn.backgroundColor = UIColor.green
        btn.addTarget(self, action: #selector(goTestVC), for: .touchUpInside)
        self.view.addSubview(btn)
        
        // 支持下拉返回 -- 第一步
        self.popFromTop = true
        self.popFromLeft = true
    }

    @objc func goTestVC() {
        let vc = TestVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 支持下拉返回 -- 第二步 （这两个代理方法必须要有）（可以考虑放到父类）
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if interactivePopTransition != nil {
            return interactivePopTransition
        }
        return nil
    }
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       if operation == UINavigationControllerOperation.pop {
            return CustomPopAnimation()
        }
        return nil
    }
}
