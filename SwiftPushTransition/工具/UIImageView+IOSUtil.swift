//
//  UIImageView+IOSUtil.swift
//  ZMWSwiftFramework
//
//  Created by zhangmingwei on 2017/12/13.
//  Copyright © 2017年 zhangmingwei. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    public class func getImageV(frame:CGRect?) -> UIImageView {
        let imageV = UIImageView()
        imageV.backgroundColor = UIColor.clear
        if let frame = frame {
            imageV.frame = frame
        } else {
            imageV.frame = CGRect.zero
        }
        imageV.contentMode = .scaleAspectFill
        imageV.layer.masksToBounds = true
        return imageV
    }
}
