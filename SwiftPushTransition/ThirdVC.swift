//
//  ThirdVC.swift
//  SwiftPushTransition
//
//  Created by zhangmingwei on 2018/2/7.
//  Copyright © 2018年 zhangmingwei. All rights reserved.
//

import UIKit
import LazyTransitions

class ThirdVC: BaseVC {
    // 添加下拉返回效果
    var transitioner = LazyTransitioner()
    var didScrollCallback: (UIScrollView) -> () = { _ in }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "第三页"
        self.view.backgroundColor = UIColor.yellow
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScrollCallback(scrollView)
    }


    deinit {
        print("ThirdVC---deinit...")
    }
}
