//
//  PointTransitionPop.swift
//  SwiftPushTransition
//
//  Created by zhangmingwei on 2018/2/7.
//  Copyright © 2018年 zhangmingwei. All rights reserved.
//

import UIKit
/// 缩小到某一个点的动画
class PointTransitionPop: NSObject, UIViewControllerAnimatedTransitioning {
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
        // 开始的UIBezierPath
        //        let maskStartBP = UIBezierPath.init(ovalIn: startFrame)
        let maskStartBP = UIBezierPath.init(ovalIn: startFrame.insetBy(dx: startFrame.width/2.0, dy: startFrame.width/2.0))
        
        // 获取动画的源控制器和目标控制器
        if let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) {
            // 都添加到contentV中，顺序不能错 --- 和push的正好相反
            contentV.addSubview(toVC.view)
            contentV.addSubview(fromVC.view)
            //创建两个圆形的 UIBezierPath 实例；一个是 button 的 size ，另外一个则拥有足够覆盖屏幕的半径。最终的动画则是在这两个贝塞尔路径之间进行的
            
            // 触发点的point
            let startPoint = CGPoint.init(x: startFrame.origin.x + startFrame.size.width/2.0, y: startFrame.origin.y + startFrame.size.height/2.0)
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height
            let x = (width/2.0 > startPoint.x ? width - startPoint.x : startPoint.x)
            let y = (height/2.0 > startPoint.y ? height - startPoint.y : startPoint.y)
            let finalRadius = sqrt((x * x) + (y * y))
            // 最终的UIBezierPath
            let maskFinalBP = UIBezierPath.init(ovalIn: startFrame.insetBy(dx: -finalRadius, dy: -finalRadius))
            // 创建一个CAShapeLayer负责展示圆形的遮盖
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskStartBP.cgPath
            fromVC.view.layer.mask = maskLayer
            
            // 组合动画开始
            let animation1 = CABasicAnimation.init(keyPath: "path")
            animation1.beginTime = 0.0
            animation1.fromValue = maskFinalBP.cgPath
            animation1.toValue = maskStartBP.cgPath
            animation1.duration = self.transitionDuration(using: transitionContext)
            animation1.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
            maskLayer.add(animation1, forKey: "PointTransitionPop")
            // 结束后移除
            /// 延迟animationGroup.duration秒后执行 - double类型
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(animation1.duration * 1000))) {
                transitionContext.completeTransition(true)
                fromVC.view.layer.mask = nil
                toVC.view.layer.mask = nil
            }
        }
    }// 核心动画方法结束
}

