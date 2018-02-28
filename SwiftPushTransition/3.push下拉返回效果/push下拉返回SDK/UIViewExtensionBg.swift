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
    
    /// 获取高斯模糊的view，覆盖到需要的地方就OK了。
    class func getBlurView(frame: CGRect) -> UIVisualEffectView {
        let blur = UIBlurEffect.init(style: .light)
        let effectView = UIVisualEffectView.init(effect: blur)
        effectView.frame = frame
        return effectView
    }
}
