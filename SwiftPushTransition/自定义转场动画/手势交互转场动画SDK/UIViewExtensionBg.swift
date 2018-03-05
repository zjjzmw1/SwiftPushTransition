//
//  UIViewExtensionBg.swift
//  SwiftPushTransition
//
//  Created by zhangmingwei on 2018/2/26.
//  Copyright © 2018年 zhangmingwei. All rights reserved.
//

import Foundation

extension UIView {
    /// 简单的黑色蒙层
    public static var shadowView: UIView {
        let shadowView = UIView(frame: UIScreen.main.bounds)
        shadowView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        return shadowView
    }
    /// 毛玻璃效果
    public static var blurView: UIView {
        let blurView = UIView.getBlurView(frame: UIScreen.main.bounds)
        return blurView
    }
    
    /// 获取高斯模糊的view，覆盖到需要的地方就OK了。 ------- 项目中有重名的，先隐藏
    class func getBlurView(frame: CGRect) -> UIVisualEffectView {
        let blur = UIBlurEffect.init(style: .light)
        let effectView = UIVisualEffectView.init(effect: blur)
        effectView.frame = frame
        return effectView
    }
    
    /// 动画放大, 缩小 view scale ： 1 为本身大小
    func scaleAnimationSpring(scale: CGFloat) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
            // 从中间缩放。
//            self.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
            self.transform = CGAffineTransform.init(scaleX: scale, y: scale)
        }, completion: { (finish) in
            
        })
    }
}
