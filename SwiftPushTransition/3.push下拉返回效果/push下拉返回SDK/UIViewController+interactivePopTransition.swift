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
private var kPopFromTopWithScrollView           = "kPopFromTopWithScrollView"   // 包含滚动视频
private var kPopFromLeft                        = "kPopFromLeft"

extension UIViewController: UIScrollViewDelegate, UINavigationControllerDelegate {

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
    var interactivePopTransition : CustomPercentDrivenInteractiveTransition? {
        set {
            objc_setAssociatedObject(self, &kInteractivePopTransition, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &kInteractivePopTransition) as? CustomPercentDrivenInteractiveTransition
        }
    }
    /// 自定义--返回的方向是否是从上面下拉，默认为: false
    var popFromTop: Bool {
        set {
            objc_setAssociatedObject(self, &kPopFromTop, newValue, .OBJC_ASSOCIATION_ASSIGN)
            if newValue {
                let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(handleGesture(gestureRecognizer:)))
                self.view.addGestureRecognizer(gesture)
                self.navigationController?.delegate = self
            }
        }
        get {
            return objc_getAssociatedObject(self, &kPopFromTop) as? Bool ?? false
        }
    }
    /// 自定义--返回的方向是否是从上面下拉，默认为: false
    var popFromTopWithScrollView: Bool {
        set {
            objc_setAssociatedObject(self, &kPopFromTopWithScrollView, newValue, .OBJC_ASSOCIATION_ASSIGN)
            if newValue {
                let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(handleGesture(gestureRecognizer:)))
                self.view.addGestureRecognizer(gesture)
                self.navigationController?.delegate = self
            }
        }
        get {
            return objc_getAssociatedObject(self, &kPopFromTopWithScrollView) as? Bool ?? false
        }
    }
    /// 自定义--返回的方向是否是从上面下拉，默认为: false
    var popFromLeft: Bool {
        set {
            objc_setAssociatedObject(self, &kPopFromLeft, newValue, .OBJC_ASSOCIATION_ASSIGN)
            if newValue {
                let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(handleGesture(gestureRecognizer:)))
                self.view.addGestureRecognizer(gesture)
                self.navigationController?.delegate = self
            }
        }
        get {
            return objc_getAssociatedObject(self, &kPopFromLeft) as? Bool ?? false
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.popFromTopWithScrollView { // 允许下拉
            var top: CGFloat = 0.0
            if #available(iOS 11.0, *) {
                top = scrollView.adjustedContentInset.top
            }
            if scrollView.contentOffset.y + scrollView.contentInset.top + top > 0 { // 向上滑动
                return
            } else {
                for gesture in scrollView.gestureRecognizers! {
                    if gesture.isKind(of: UIPanGestureRecognizer.self) {
                        self.handleGesture(gestureRecognizer: gesture as! UIPanGestureRecognizer)
                    }
                }
            }
        }
    }
    /// 手指离开屏幕的方法（不管有没有惯性都执行）
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.popFromTopWithScrollView { // 允许下拉
            var top: CGFloat = 0.0
            if #available(iOS 11.0, *) {
                top = scrollView.adjustedContentInset.top
            }
            if scrollView.contentOffset.y + scrollView.contentInset.top + top > 0 { // 向上滑动
                return
            } else {
                for gesture in scrollView.gestureRecognizers! {
                    if gesture.isKind(of: UIPanGestureRecognizer.self) {
                        self.handleGesture(gestureRecognizer: gesture as! UIPanGestureRecognizer)
                    }
                }
            }
        }
    }
    
    /// 自定义-- 以下是自定义交互器 上下手势 / 左右手势
    @objc func handleGesture(gestureRecognizer: UIPanGestureRecognizer) {
        var progress: CGFloat = 0.0
        if interactivePopTransition == nil {
            self.interactivePopTransition = CustomPercentDrivenInteractiveTransition()
        }
        if self.popFromLeft { // 允许从左滑动返回
            let pro = gestureRecognizer.translation(in: gestureRecognizer.view?.superview).x / self.view.bounds.size.width
            if pro > progress && pro > 0.01 && !(interactivePopTransition!.popFromTop) { // 避免左右滑动的时候，突然变成上下滑动
                interactivePopTransition?.popFromLeft = self.popFromLeft
                interactivePopTransition?.popFromTop = false
                progress = pro
            }
        }
        if self.popFromTop || self.popFromTopWithScrollView { // 允许下拉
            let pro = gestureRecognizer.translation(in: gestureRecognizer.view?.superview).y / self.view.bounds.size.height
            if pro > progress && pro > 0.01 && !(interactivePopTransition!.popFromLeft) { // 避免上下滑动的时候，突然变成左右滑动
                interactivePopTransition?.popFromTop = (self.popFromTop || self.popFromTopWithScrollView)
                interactivePopTransition?.popFromLeft = false
                progress = pro
            }
        }
        progress = min(1.0, max(0.0, progress))
        if gestureRecognizer.state == UIGestureRecognizerState.began { // 开始滑动
            if interactionInProgress == true {
                return
            }
            self.navigationController?.delegate = self
            self.interactivePopTransition = CustomPercentDrivenInteractiveTransition()
            interactionInProgress = true
            self.navigationController?.popViewController(animated: true)
        } else if gestureRecognizer.state == UIGestureRecognizerState.changed { // 正在滑动
            if interactivePopTransition?.transitionContext == nil && !interactionInProgress {
                self.navigationController?.delegate = self
                self.interactivePopTransition = CustomPercentDrivenInteractiveTransition()
                interactionInProgress = true
                self.navigationController?.popViewController(animated: true)
            } else {
                print("pro======\(progress)")
            }
            interactivePopTransition?.update(progress)

        } else if gestureRecognizer.state == UIGestureRecognizerState.ended || gestureRecognizer.state == UIGestureRecognizerState.cancelled { // 结束
            interactivePopTransition?.finishBy(cancelled: progress < 0.4)
            interactionInProgress = false
            self.interactivePopTransition = nil
            print("取消了。。。。。。")
        }
    }
    
    /// 支持下拉返回 -- 第二步 （这两个代理方法必须要有）（可以考虑放到父类）
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if interactivePopTransition != nil {
            return interactivePopTransition
        }
        return nil
    }
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == UINavigationControllerOperation.pop {
            return CustomPopAnimation()
        }
        return nil
    }
}
