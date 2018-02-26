//
//  SecondVC.swift
//  SwiftPushTransition
//
//  Created by zhangmingwei on 2018/2/7.
//  Copyright © 2018年 zhangmingwei. All rights reserved.
//

import UIKit

class SecondVC: BaseVC{
    /// 开始动画的frame --- 需要返回动画的时候就添加
    var startFrame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "第二页"
        self.view.backgroundColor = UIColor.blue
        // 滑动返回
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        // 添加滑动返回转场动画需要
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(SecondVC.handlePan(gestureRecognizer:)))
        self.view.addGestureRecognizer(gesture)
    }
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.delegate = self
        }
    
        func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            if operation == UINavigationControllerOperation.pop {
                let pop = PointTransitionPop()
                pop.startFrame = startFrame
                return pop
            }
            return nil
        }

    deinit {
        print("secondVC---deinit...")
    }
   
}

// MARK: 滑动返回添加转场动画相关
extension SecondVC {
    
    @objc func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        /*调用UIPercentDrivenInteractiveTransition的updateInteractiveTransition:方法可以控制转场动画进行到哪了，
         当用户的下拉手势完成时，调用finishInteractiveTransition或者cancelInteractiveTransition，UIKit会自动执行剩下的一半动画，
         或者让动画回到最开始的状态。*/

        if gestureRecognizer.translation(in: view).x >= 0 {
            // 手势滑动的比例
            var per = gestureRecognizer.translation(in: view).x / view.bounds.size.width
            per = min(1.0, max(0.0, per))
            if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled {
                if per > 0.3 {
                    navigationController?.popViewController(animated: true)
                }
            }
        }
    }// 手势的方法结束
    
}
