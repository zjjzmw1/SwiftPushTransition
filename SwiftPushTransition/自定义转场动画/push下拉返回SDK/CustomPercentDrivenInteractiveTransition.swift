//
//  CustomPercentDrivenInteractiveTransition.swift
//  SwiftPushTransition
//
//  Created by zhangmingwei on 2018/2/26.
//  Copyright © 2018年 zhangmingwei. All rights reserved.
//

import UIKit

/// 自定义不同方向的滑动返回
class CustomPercentDrivenInteractiveTransition: UIPercentDrivenInteractiveTransition {
    ///以下是自定义交互控制器
    var transitionContext : UIViewControllerContextTransitioning!
    var formView : UIView!
    var toView : UIView!
    let x_to : CGFloat = -100.0 ///toview起始x坐标
    let y_to : CGFloat = -100.0 ///toview起始y坐标
    var shadowView: UIView = UIView.shadowView      // 阴影蒙层
    var blurView: UIView = UIView.blurView          // 毛玻璃蒙层

    /// 自定义--是否是从上往下 默认false
    var popFromTop: Bool    =   false
    /// 自定义--是否是从左往右 默认false
    var popFromLeft: Bool   =   false
    /// 自定义呢--模仿App Store的转场动画 默认 false
    var popFromAll: Bool    =   false
    /// 开始动画的frame （模仿App Store的转场动画的时候需要）
    var popStartFrame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
    
    /// 以下----自定义交互控制器
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to) else {
                ///预防rootviewcontroller触发
                return
        }
        self.transitionContext = transitionContext
        containerView.insertSubview((toViewController.view)!, belowSubview: (fromViewController.view)!)
        /// 加点阴影
        fromViewController.view.layer.shadowOpacity = 0.8
        fromViewController.view.layer.shadowColor = UIColor.black.cgColor
        fromViewController.view.layer.shadowOffset = CGSize(width: 3, height: 3)
        fromViewController.view.layer.shadowRadius = 3
        
        self.formView = fromViewController.view
        self.toView = toViewController.view
        // 超出的部分不显示
        self.formView.clipsToBounds = true
        self.toView.clipsToBounds = false
        self.toView.frame = CGRect(x:x_to,y:y_to,width:self.toView.frame.width,height:self.toView.frame.height)
        blurView = UIView.blurView // 毛玻璃
        self.toView.addSubview(blurView)
        shadowView = UIView.shadowView // 初始化阴影
        shadowView.alpha = 1.0
        self.toView.addSubview(shadowView)
    }
    override func update(_ percentComplete: CGFloat) {
        if transitionContext == nil {
            ///预防rootviewcontroller触发
            return
        }
        shadowView.isHidden = false
        blurView.isHidden = false
        if self.popFromTop { // 上下滑动
            blurView.isHidden = true
            self.formView?.frame = CGRect(x:0, y:(self.formView?.frame.height)!*percentComplete, width:(self.formView?.frame.width)! , height: (self.formView?.frame.height)!)
            self.toView?.frame = CGRect(x:0, y:self.y_to+CGFloat(fabsf(Float(self.y_to*percentComplete))), width:(self.toView?.frame.width)! , height: (self.toView?.frame.height)!)
        } else if self.popFromLeft  { // 左右滑动
            blurView.isHidden = true
            self.formView?.frame = CGRect(x:(self.formView?.frame.width)!*percentComplete, y:0, width:(self.formView?.frame.width)! , height: (self.formView?.frame.height)!)
            self.toView?.frame = CGRect(x:self.x_to+CGFloat(fabsf(Float(self.x_to*percentComplete))), y:0, width:(self.toView?.frame.width)! , height: (self.toView?.frame.height)!)
        } else if self.popFromAll { // 模仿App Store的转场动画
            shadowView.isHidden = true
            let left = (self.formView?.frame.width)!*percentComplete * 0.3
            let top = (self.formView?.frame.height)!*percentComplete * 0.3
            self.formView?.frame = CGRect(x:left, y:top, width:UIScreen.main.bounds.size.width - left*2 , height: UIScreen.main.bounds.size.height - top*2)
            self.toView?.frame = CGRect(x:0, y:0, width:(self.toView?.frame.width)! , height: (self.toView?.frame.height)!)
        }
        transitionContext?.updateInteractiveTransition(percentComplete)
        shadowView.alpha = 1.0 - percentComplete
        blurView.alpha = 1.0
    }
    func finishBy(cancelled: Bool) {
        if self.transitionContext == nil {
            ///预防rootviewcontroller触发
            return
        }
        if cancelled { // 取消返回
            self.transitionContext!.cancelInteractiveTransition()
            UIView.animate(withDuration: 0.2, animations: {
                self.formView?.frame = CGRect(x:0, y:0, width:(self.formView?.frame.width)! , height: (self.formView?.frame.height)!)
                if self.popFromTop { // 上下滑动
                    self.toView?.frame = CGRect(x:0, y:self.y_to, width:(self.toView?.frame.width)! , height: (self.toView?.frame.height)!)
                } else if self.popFromLeft  { // 左右滑动
                    self.toView?.frame = CGRect(x:self.x_to, y:0, width:(self.toView?.frame.width)! , height: (self.toView?.frame.height)!)
                } else if self.popFromAll { // 模仿App Store的转场动画
                    self.formView?.frame = CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width , height: UIScreen.main.bounds.size.height)
                    self.toView?.frame = CGRect(x:0, y:0, width:(self.toView?.frame.width)! , height: (self.toView?.frame.height)!)
                }
                self.shadowView.alpha = 0.0
                self.blurView.alpha = 0.0
            }, completion: {completed in
                self.transitionContext!.completeTransition(false)
                self.transitionContext = nil
                self.toView = nil
                self.formView = nil
            })
        } else { // 执行pop
            UIView.animate(withDuration: 0.2, animations: {
                if self.popFromAll {
                    self.formView?.frame = self.popStartFrame
                } else {
                    if self.formView.frame.origin.y > 0 { // 上下
                        self.formView?.frame = CGRect(x:0, y:(self.formView?.frame.height)!, width:(self.formView?.frame.width)! , height: (self.formView?.frame.height)!)
                    } else { // 左右
                        self.formView?.frame = CGRect(x:(self.formView?.frame.width)!, y:0, width:(self.formView?.frame.width)! , height: (self.formView?.frame.height)!)
                    }
                }
                self.toView?.frame = CGRect(x:0, y:0, width:(self.toView?.frame.width)! , height: (self.toView?.frame.height)!)
                self.shadowView.alpha = 0.0
                self.blurView.alpha = 0.0
            }, completion: {completed in
                self.transitionContext!.finishInteractiveTransition()
                self.transitionContext!.completeTransition(true)
                self.transitionContext = nil
                self.toView = nil
                self.formView = nil
                self.shadowView.removeFromSuperview()
                self.blurView.removeFromSuperview()
                
            })
        }
    }

}
