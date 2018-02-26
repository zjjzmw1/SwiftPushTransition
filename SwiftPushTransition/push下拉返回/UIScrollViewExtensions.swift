//
//  UIScrollViewExtensions.swift
//  SwiftPushTransition
//
//  Created by zhangmingwei on 2018/2/26.
//  Copyright © 2018年 zhangmingwei. All rights reserved.
//

import Foundation

extension UIScrollView {
    /// 是否滚动到最上边了
    public var isAtTop: Bool {
        return (contentOffset.y + contentInset.top) == 0
    }
}

