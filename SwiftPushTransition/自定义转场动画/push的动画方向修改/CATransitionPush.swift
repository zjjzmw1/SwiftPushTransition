//
//  CATransitionPush.swift
//  SwiftPushTransition
//
//  Created by zhangmingwei on 2018/2/8.
//  Copyright © 2018年 zhangmingwei. All rights reserved.
//

/* 用法：
 //        let transitionPush = CATransitionPush(aType: kCATransitionPush, aSubtype: kCATransitionFromTop)
 //        self.navigationController?.view.layer.add(transitionPush, forKey: kCATransition)
 //        self.navigationController?.pushViewController(vc, animated: false)

 
 */


import UIKit

class CATransitionPush: CATransition {

//    var aType = kCATransitionPush
//    var aSubtype = kCATransitionFromLeft
    
    override init() {
        super.init()
    }
    
    init(aType: String?, aSubtype: String?) {
        super.init()
        if let aType = aType {
            type = aType
        }
        if let aSubtype = aSubtype {
            subtype = aSubtype
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
