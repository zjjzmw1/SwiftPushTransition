//
//  RightTransitionPop.swift
//  YLExpect_iOS
//
//  Created by zhangmingwei on 2018/3/3.
//  Copyright © 2018年 yaolan.com. All rights reserved.
//

import UIKit

/// 临时放这里。。。。。。。。方便删除（与自己项目中重名了直接删了就OK了。）
/// iPhoneX
let kIs_iphoneX     =   UIScreen.main.bounds.height == 812
let SCREEN_WIDTH        =    UIScreen.main.bounds.size.width
let SCREEN_HEIGHT       =    UIScreen.main.bounds.size.height
/// 导航栏高度 64
var NAVIGATIONBAR_HEIGHT: CGFloat {
    get {
        if kIs_iphoneX {
            return 64.0 + 24.0
        } else {
            return 64.0
        }
    }
}



/// 类似系统的右滑返回
class RightTransitionPop: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: 动画时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    // MARK: 动画核心方法
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 获取容器的视图
        let contentV = transitionContext.containerView
        
        // 获取动画的源控制器和目标控制器
        if let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) {
            // 都添加到contentV中，顺序不能错 --- 和push的正好相反
            contentV.addSubview(toVC.view)
            contentV.addSubview(fromVC.view)
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height
            var top: CGFloat = 0.0
            var fromTop: CGFloat = 0.0
            /// 导航栏是否隐藏
            if toVC.navigationController!.navigationBar.isHidden || toVC.navigationController!.navigationBar.alpha == 0.0 {
                top = 0
            } else {
                top = NAVIGATIONBAR_HEIGHT
            }
            if fromVC.view.frame.origin.y > 0.0 {
                fromTop = NAVIGATIONBAR_HEIGHT
            }
            toVC.view.frame = CGRect.init(x: -100, y: top, width: width, height: height)
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
                fromVC.view.frame = CGRect.init(x: SCREEN_WIDTH, y: fromTop, width: width, height: height)
                toVC.view.frame = CGRect.init(x: 0, y: top, width: width, height: height)
            }, completion: { (finish) in
                transitionContext.completeTransition(true)
                fromVC.view.layer.mask = nil
                toVC.view.layer.mask = nil
            })
        }
    }// 核心动画方法结束
}

