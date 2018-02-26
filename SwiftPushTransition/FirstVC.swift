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
    var btn2: UIButton!
    var btn4: UIButton!
    var btn5: UIButton!
    var startFrame = CGRect.init()
    /// 是否需要自定义动画
    var isNeedCustomAnimation   =   true

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.green
        self.title = "首页"

        btn = UIButton.init(frame: CGRect.init(x: 22, y: 100, width: 100, height: 100))
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(goAction), for: .touchUpInside)
        btn.setTitle("吸吮1", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.red
        
        btn2 = UIButton.init(frame: CGRect.init(x: 22, y: 220, width: 100, height: 100))
        view.addSubview(btn2)
        btn2.addTarget(self, action: #selector(goAction2), for: .touchUpInside)
        btn2.setTitle("吸吮2", for: .normal)
        btn2.layer.masksToBounds = true
        btn2.layer.cornerRadius = 50
        btn2.setTitleColor(UIColor.white, for: .normal)
        btn2.backgroundColor = UIColor.red
        
        btn4 = UIButton.init(frame: CGRect.init(x: 22, y: 420, width: 100, height: 100))
        view.addSubview(btn4)
        btn4.addTarget(self, action: #selector(goAction4), for: .touchUpInside)
        btn4.setTitle("过年动画", for: .normal)
        btn4.layer.masksToBounds = true
        btn4.layer.cornerRadius = 50
        btn4.setTitleColor(UIColor.white, for: .normal)
        btn4.backgroundColor = UIColor.red
        
        btn5 = UIButton.init(frame: CGRect.init(x: 222, y: 100, width: 100, height: 100))
        view.addSubview(btn5)
        btn5.addTarget(self, action: #selector(goAction5), for: .touchUpInside)
        btn5.setTitle("下拉返回", for: .normal)
        btn5.layer.masksToBounds = true
        btn5.layer.cornerRadius = 50
        btn5.setTitleColor(UIColor.white, for: .normal)
        btn5.backgroundColor = UIColor.red
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.delegate = self
    }
    
    // 吸吮效果1
    @objc func goAction() {
        let vc = SecondVC()
        startFrame = btn.frame
        isNeedCustomAnimation = true
        vc.startFrame = btn.frame // 需要返回动画的时候添加
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // 吸吮效果2
    @objc func goAction2() {
        let vc = ThirdVC()
        isNeedCustomAnimation = true
        startFrame = btn2.frame
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // 过年动画
    @objc func goAction4() {
        let vc = NewYearAnimationVC()
        isNeedCustomAnimation = false
        self.navigationController?.pushViewController(vc, animated: false)
    }
    // 下拉返回的效果
    @objc func goAction5() {
        let vc = CustomPercentInteractiveVC()
        // 正常的push
//        isNeedCustomAnimation = false
//        self.navigationController?.pushViewController(vc, animated: true)
        // 从下到上的push
        isNeedCustomAnimation = false
        let transitionPush = CATransitionPush(aType: kCATransitionPush, aSubtype: kCATransitionFromTop)
        self.navigationController?.view.layer.add(transitionPush, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    override func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == UINavigationControllerOperation.push && isNeedCustomAnimation {
            let push = PointTransitionPush()
            push.startFrame = startFrame
            return push
        }
        return nil
    }

}
