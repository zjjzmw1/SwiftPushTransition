//
//  UIViewExtensionBg.swift
//  SwiftPushTransition
//
//  Created by zhangmingwei on 2018/2/26.
//  Copyright © 2018年 zhangmingwei. All rights reserved.
//

import Foundation

extension UIView {
    public static var shadowView: UIView {
        let shadowView = UIView(frame: UIScreen.main.bounds)
        shadowView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        return shadowView
    }
}
