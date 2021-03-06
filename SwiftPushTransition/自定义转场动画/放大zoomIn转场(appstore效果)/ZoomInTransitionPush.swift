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
        return 0.3
    }
    // MARK: 动画核心方法
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 获取容器的视图
        let contentV = transitionContext.containerView
        // 获取动画的源控制器和目标控制器
        if let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) {
            toVC.navigationController?.navigationBar.isTranslucent = true
            toVC.tabBarController?.tabBar.isTranslucent = false
            // 都添加到contentV中，顺序不能错
            toVC.view.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            contentV.addSubview(fromVC.view)
            contentV.addSubview(toVC.view)
            let originToFrame = toVC.view.frame
            
            let maskStartBP = UIBezierPath.init(rect: startFrame)
            // 最终的UIBezierPath
            let maskFinalBP = UIBezierPath.init(rect: originToFrame)
            // 创建一个CAShapeLayer负责展示圆形的遮盖
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskFinalBP.cgPath
            toVC.view.layer.mask = maskLayer
            // 组合动画开始
            let animation1 = CABasicAnimation.init(keyPath: "path")
            animation1.beginTime = 0.0
            animation1.fromValue = maskStartBP.cgPath
            animation1.toValue = maskFinalBP.cgPath
            animation1.duration = self.transitionDuration(using: transitionContext)
            animation1.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
            // 从中间缩放。
            maskLayer.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
            maskLayer.add(animation1, forKey: "ZoomInTransitionPush") // 动画组
            // 结束后移除
            /// 延迟animationGroup.duration秒后执行 - double类型
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(self.transitionDuration(using: transitionContext) * 1000))) {
                transitionContext.completeTransition(true)
                fromVC.view.layer.mask = nil
                toVC.view.layer.mask = nil
            }
        }
    }// 核心动画方法结束
}

