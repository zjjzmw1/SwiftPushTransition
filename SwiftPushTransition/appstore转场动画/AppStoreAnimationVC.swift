//
//  AppStoreAnimationVC.swift
//  SwiftPushTransition
//
//  Created by zhangmingwei on 2018/2/27.
//  Copyright © 2018年 zhangmingwei. All rights reserved.
//

import UIKit

class AppStoreAnimationVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "模仿app store"
        self.view.backgroundColor = UIColor.yellow
    
        // appstore的转场动画，这一句就OK
        self.popFromAll = true
    }



}
