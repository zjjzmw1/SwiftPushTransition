//
//  FirstVC.swift
//  SwiftPushTransition
//
//  Created by zhangmingwei on 2018/2/7.
//  Copyright © 2018年 zhangmingwei. All rights reserved.
//

import UIKit
import LazyTransitions

class FirstVC: BaseVC {
    var btn: UIButton!
    var btn2: UIButton!
    var btn3: UIButton!
    var startFrame = CGRect.init()
    // 下拉返回的效果需要
    fileprivate var transitioner = LazyTransitioner()
    /// 是否需要自定义动画
    var isNeedCustomAnimation   =   true

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
        
        btn2 = UIButton.init(frame: CGRect.init(x: 100, y: 220, width: 100, height: 100))
        view.addSubview(btn2)
        btn2.addTarget(self, action: #selector(goAction2), for: .touchUpInside)
        btn2.setTitle("第三页", for: .normal)
        btn2.layer.masksToBounds = true
        btn2.layer.cornerRadius = 50
        btn2.setTitleColor(UIColor.white, for: .normal)
        btn2.backgroundColor = UIColor.red

        btn3 = UIButton.init(frame: CGRect.init(x: 100, y: 320, width: 100, height: 100))
        view.addSubview(btn3)
        btn3.addTarget(self, action: #selector(goAction3), for: .touchUpInside)
        btn3.setTitle("第四页", for: .normal)
        btn3.layer.masksToBounds = true
        btn3.layer.cornerRadius = 50
        btn3.setTitleColor(UIColor.white, for: .normal)
        btn3.backgroundColor = UIColor.red
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.delegate = self
    }
    
    @objc func goAction() {
        let vc = SecondVC()
        startFrame = btn.frame
        isNeedCustomAnimation = true
        vc.startFrame = btn.frame // 需要返回动画的时候添加
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func goAction2() {
        let vc = ThirdVC()
        isNeedCustomAnimation = true
        startFrame = btn2.frame
        self.navigationController?.pushViewController(vc, animated: true)
        
//        transitioner.addTransition(forView: vc.view)
//        transitioner.triggerTransitionAction = { [weak self] _ in
//            _ = self?.navigationController?.popViewController(animated: true)
//        }
//        vc.didScrollCallback = { [weak self] scrollView in
//            self?.transitioner.didScroll(scrollView)
//        }
//        navigationController?.delegate = transitioner

    }

    @objc func goAction3() {
        let vc = FourVC()
        isNeedCustomAnimation = false
        let transitionPush = CATransitionPush(aType: kCATransitionPush, aSubtype: kCATransitionFromTop)
        self.navigationController?.view.layer.add(transitionPush, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: false)
    }

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == UINavigationControllerOperation.push && isNeedCustomAnimation {
            let push = PointTransitionPush()
            push.startFrame = startFrame
            return push
        }
        return nil
    }

}
