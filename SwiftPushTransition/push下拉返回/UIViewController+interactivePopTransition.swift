//
//  UIViewController+interactivePopTransition.swift
//  SwiftPushTransition
//
//  Created by zhangmingwei on 2018/2/26.
//  Copyright © 2018年 zhangmingwei. All rights reserved.
//

import Foundation
import UIKit

// tip : 不添加这些变量的话，无法用 &获取关联的对象的值
private var kInteractionInProgress              = "kInteractionInProgress"
private var kInteractivePopTransition           = "kInteractivePopTransition"
private var kPopFromTop                         = "kPopFromTop"
private var kPopFromLeft                        = "kPopFromLeft"

/// 相关类需要继承： UINavigationControllerDelegate
extension UIViewController {
    
    /// 自定义--用于指示交互是否在进行中。 默认 false
    var interactionInProgress: Bool {
        set {
            objc_setAssociatedObject(self, &kInteractionInProgress, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, &kInteractionInProgress) as? Bool ?? false
        }
    }
    /// 自定义--交互控制器
    var interactivePopTransition : CustomPercentDrivenInteractiveTransition! {
        set {
            objc_setAssociatedObject(self, &kInteractivePopTransition, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &kInteractivePopTransition) as? CustomPercentDrivenInteractiveTransition ?? CustomPercentDrivenInteractiveTransition()
        }
    }
    /// 自定义--返回的方向是否是从上面下拉，默认为: false
    var popFromTop: Bool {
        set {
            objc_setAssociatedObject(self, &kPopFromTop, newValue, .OBJC_ASSOCIATION_ASSIGN)
            if newValue {
                let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(handleGesture(gestureRecognizer:)))
                self.view.addGestureRecognizer(gesture)
                self.navigationController?.delegate = self as? UINavigationControllerDelegate
            }
        }
        get {
            return objc_getAssociatedObject(self, &kPopFromTop) as? Bool ?? false
        }
    }
    /// 自定义--返回的方向是否是从上面下拉，默认为: false
    var popFromLeft: Bool {
        set {
            objc_setAssociatedObject(self, &kPopFromLeft, newValue, .OBJC_ASSOCIATION_ASSIGN)
            if newValue {
                let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(handleGesture(gestureRecognizer:)))
                self.view.addGestureRecognizer(gesture)
                self.navigationController?.delegate = self as? UINavigationControllerDelegate
            }
        }
        get {
            return objc_getAssociatedObject(self, &kPopFromLeft) as? Bool ?? false
        }
    }

    /// 自定义-- 以下是自定义交互器 上下手势 / 左右手势
    @objc func handleGesture(gestureRecognizer: UIPanGestureRecognizer) {
        var progress: CGFloat = 0.0
        if self.popFromLeft { // 允许从左滑动返回
            let pro = gestureRecognizer.translation(in: gestureRecognizer.view?.superview).x / self.view.bounds.size.width
            if pro > progress && pro > 0.01 && !interactivePopTransition.popFromTop { // 避免左右滑动的时候，突然变成上下滑动
                interactivePopTransition.popFromLeft = self.popFromLeft
                interactivePopTransition.popFromTop = false
                progress = pro
            }
        }
        if self.popFromTop { // 允许下拉
            let pro = gestureRecognizer.translation(in: gestureRecognizer.view?.superview).y / self.view.bounds.size.height
            if pro > progress && pro > 0.01 && !interactivePopTransition.popFromLeft { // 避免上下滑动的时候，突然变成左右滑动
                interactivePopTransition.popFromTop = self.popFromTop
                interactivePopTransition.popFromLeft = false
                progress = pro
            }
        }
        progress = min(1.0, max(0.0, progress))
        if gestureRecognizer.state == UIGestureRecognizerState.began { // 开始滑动
            if interactionInProgress == true {
                return
            }
            self.navigationController?.delegate = self as? UINavigationControllerDelegate
            self.interactivePopTransition = CustomPercentDrivenInteractiveTransition()
            interactionInProgress = true
            self.navigationController?.popViewController(animated: true)
        } else if gestureRecognizer.state == UIGestureRecognizerState.changed { // 正在滑动
            interactivePopTransition.update(progress)
        } else if gestureRecognizer.state == UIGestureRecognizerState.ended || gestureRecognizer.state == UIGestureRecognizerState.cancelled { // 结束
            interactivePopTransition.finishBy(cancelled: progress < 0.4)
            interactionInProgress = false
            self.interactivePopTransition = nil
        }
    }
}
