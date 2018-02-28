//
//  ZoomInTransitionPush.swift
//  SwiftPushTransition
//
//  Created by zhangmingwei on 2018/2/28.
//  Copyright © 2018年 zhangmingwei. All rights reserved.
//

import UIKit

/// 模仿App Store点击放大动画的转场
class ZoomInTransitionPush: NSObject, UIViewControllerAnimatedTransitioning {
    /// 开始动画的frame
    var startFrame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
    
    // MARK: 动画时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    // MARK: 动画核心方法
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 获取容器的视图
        let contentV = transitionContext.containerView
        // 获取动画的源控制器和目标控制器
        if let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) {
            // 都添加到contentV中，顺序不能错
            contentV.addSubview(fromVC.view)
            contentV.addSubview(toVC.view)
            let originToFrame = toVC.view.frame
            toVC.view.frame = startFrame
            // 缩放动画
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
                toVC.view.frame = originToFrame
            }, completion: { (finish) in
                transitionContext.completeTransition(true)
                fromVC.view.layer.mask = nil
                toVC.view.layer.mask = nil
            })
        }
    }// 核心动画方法结束
}

