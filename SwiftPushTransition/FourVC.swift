//
//  FourVC.swift
//  SwiftPushTransition
//
//  Created by zhangmingwei on 2018/2/8.
//  Copyright © 2018年 zhangmingwei. All rights reserved.
//

import UIKit
import LazyTransitions
class FourVC: BaseVC {
    // 添加下拉返回效果
    var transitioner = LazyTransitioner()
    var didScrollCallback: (UIScrollView) -> () = { _ in }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "第四页"
        self.view.backgroundColor = UIColor.gray

        // 添加下拉返回的动画
        transitioner.addTransition(forView: view)
        transitioner.triggerTransitionAction = { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        self.didScrollCallback = { [weak self] scrollView in
            self?.transitioner.didScroll(scrollView)
        }
        navigationController?.delegate = transitioner // 这句必不可少

    }

   
}
