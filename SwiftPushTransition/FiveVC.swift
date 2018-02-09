//
//  FiveVC.swift
//  SwiftPushTransition
//
//  Created by zhangmingwei on 2018/2/8.
//  Copyright © 2018年 zhangmingwei. All rights reserved.
//

import UIKit

class FiveVC: BaseVC {

    /// 过年动画的view
    /// 过年广告动画
    var newYearV: NewYearAdView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.white
        /// 过年广告动画
        newYearV = NewYearAdView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 200))
        view.addSubview(newYearV)

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
}
