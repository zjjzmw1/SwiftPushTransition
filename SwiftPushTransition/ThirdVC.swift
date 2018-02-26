//
//  ThirdVC.swift
//  SwiftPushTransition
//
//  Created by zhangmingwei on 2018/2/7.
//  Copyright © 2018年 zhangmingwei. All rights reserved.
//

import UIKit

class ThirdVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "第三页"
        self.view.backgroundColor = UIColor.yellow
    }
    

    deinit {
        print("ThirdVC---deinit...")
    }
}
