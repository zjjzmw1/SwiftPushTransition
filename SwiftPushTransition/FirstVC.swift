//
//  FirstVC.swift
//  SwiftPushTransition
//
//  Created by zhangmingwei on 2018/2/7.
//  Copyright © 2018年 zhangmingwei. All rights reserved.
//

import UIKit

// 进入下个页面的转场动画类型
enum ToNextPageAnimationType {
    case none           // 无动画
    case pointPush      // 吸吮动画
    case zoomInPush     // 放大动画
}

class FirstVC: BaseVC {
    var btn: UIButton!
    var btn2: UIButton!
    var btn4: UIButton!
    var btn5: UIButton!
    /// APPStore转场动画
    var appStoreAnimationBtn: UIButton!
    
    var startFrame = CGRect.init()
    /// 是否需要自定义动画
    var customAnimationType: ToNextPageAnimationType = .none

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
        
        btn4 = UIButton.init(frame: CGRect.init(x: 22, y: 333, width: 100, height: 100))
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
        
        appStoreAnimationBtn = UIButton.init(frame: CGRect.init(x: 222, y: 232, width: 150, height: 150))
        view.addSubview(appStoreAnimationBtn)
        appStoreAnimationBtn.addTarget(self, action: #selector(appStoreAnimationAction(btn:)), for: .touchUpInside)
        appStoreAnimationBtn.addTarget(self, action: #selector(appStoreAnimationAction0(btn:)), for: .touchDown)
        appStoreAnimationBtn.addTarget(self, action: #selector(appStoreAnimationAction1(btn:)), for: .touchUpOutside)
        appStoreAnimationBtn.setTitle("appstore转场", for: .normal)
        appStoreAnimationBtn.layer.masksToBounds = true
        appStoreAnimationBtn.layer.cornerRadius = 5
        appStoreAnimationBtn.setTitleColor(UIColor.white, for: .normal)
        appStoreAnimationBtn.backgroundColor = UIColor.red
        
        
        // 底部的label
        let bottomLabel = UILabel.init(frame: CGRect.init(x: 0, y: UIScreen.main.bounds.height - 80, width: UIScreen.main.bounds.width, height: 80))
        view.addSubview(bottomLabel)
        bottomLabel.textColor = UIColor.black
        bottomLabel.backgroundColor = UIColor.red
        bottomLabel.numberOfLines = 0
        bottomLabel.text = "这是测试文章这是测试文章这是测试文章这是测试文章这是测试文章这是测试文章这是测试文章这是测试文章这是测试文章这是测试文章这是测试文章这是测试文章这是测试文章这是测试文章这是v测试文章这是测试文章这是测试文章这是测试文章v"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.delegate = self
    }
    
    // 吸吮效果1
    @objc func goAction() {
        let vc = SecondVC()
        startFrame = btn.frame
        customAnimationType = .pointPush
        vc.startFrame = btn.frame // 需要返回动画的时候添加
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // 吸吮效果2
    @objc func goAction2() {
        let vc = ThirdVC()
        customAnimationType = .pointPush
        startFrame = btn2.frame
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // 过年动画
    @objc func goAction4() {
        let vc = NewYearAnimationVC()
        customAnimationType = .none
        self.navigationController?.pushViewController(vc, animated: false)
    }
    // 下拉返回的效果
    @objc func goAction5() {
        let vc = CustomPercentInteractiveVC()
        // 正常的push 也可以
//        isNeedCustomAnimation = false
//        self.navigationController?.pushViewController(vc, animated: true)
        // 从下到上的push
        customAnimationType = .none
        let transitionPush = CATransitionPush(aType: kCATransitionPush, aSubtype: kCATransitionFromTop)
        self.navigationController?.view.layer.add(transitionPush, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: false)
        // 支持下拉返回 --- 这三句就可以实现下拉返回了，很方便。
        vc.popFromTop = true // 下拉返回开关
        vc.popFromLeft = true // 同时需要右滑返回的时候需要
        vc.popFromTopWithScrollView = true    // 有滚动view的时候需要
    }
    
    /// APPStore转场动画
    @objc func appStoreAnimationAction(btn: UIButton) {
        // 缩放动画
        // 延迟0.2后执行
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(0.2 * 1000))) { [weak self] in
            let vc = AppStoreAnimationVC()
            self!.customAnimationType = .zoomInPush
            self!.startFrame = btn.frame
            vc.popFromAll = true // appstore的转场动画
            vc.popStartFrame = btn.frame // 必须的pop回到进来的view的位置
            self!.navigationController?.pushViewController(vc, animated: true)
            // 延迟0.5后执行
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(0.5 * 1000))) {
                btn.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }
        }
    }
    /// APPStore转场动画
    @objc func appStoreAnimationAction0(btn: UIButton) {
        btn.scaleAnimationSpring(scale: 0.9)
    }
    /// APPStore转场动画
    @objc func appStoreAnimationAction1(btn: UIButton) {
        btn.scaleAnimationSpring(scale: 1.0)
    }
    
    override func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == UINavigationControllerOperation.push {
            if customAnimationType == .pointPush { // 吸吮动画
                let push = PointTransitionPush()
                push.startFrame = startFrame
                return push
            } else if customAnimationType == .zoomInPush { // 放大动画
                let push = ZoomInTransitionPush()
                push.startFrame = startFrame
                return push
            }
        }
        return nil
    }

}
