//
//  NewYearAdView.swift
//  YLExpect_iOS
//
//  Created by zhangmingwei on 2018/2/9.
//  Copyright © 2018年 yaolan.com. All rights reserved.
//

import UIKit

class NewYearAdView: UIView {

    /// 对联的图片
    var duilianImageV: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initAllView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("NewYearAdView---deinit")
    }
    
    /// 创建所有自视图
    func initAllView() {
        self.backgroundColor = UIColor.clear
        let bgImageV = UIImageView.getImageV(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        self.addSubview(bgImageV)
        bgImageV.image = #imageLiteral(resourceName: "adBg")
        // 下雪------------------------------animation
        Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(xiaxueAction), userInfo: nil, repeats: true)
        // 对联添加
        duilianImageV = UIImageView.init(frame: CGRect.zero)
        duilianImageV.image = #imageLiteral(resourceName: "chun_lian")
        self.addSubview(duilianImageV)
        // 对联浮动------------------------------animation
        self.duilianAction()
        // 上边扩散的动画------------------------------animation
        self.spreadAction()
        // 顶部2018摆动的动画------------------------------animation
        self.swingAction()
    }
    
    /// 下雪动画
    @objc func xiaxueAction() {
        if self.subviews.count > 600 {
            return
        }
        // 雪花的宽
        var width = CGFloat(arc4random() % 20)
        while width < 5 {
            width = CGFloat(arc4random() % 20)
        }
        // 雪花的速度
        var speed = CGFloat(arc4random() % 10)
        while speed < 4 {
            speed = CGFloat(arc4random() % 10)
        }
        // 雪花的y
        let startY = -CGFloat(arc4random() % 100)
        let startX = CGFloat(arc4random() % 450)
        let endX = CGFloat(arc4random() % 450)
        let imageV = UIImageView.init(frame: CGRect.init(x: startX, y: startY, width: width, height: width))
        self.addSubview(imageV)
        let index = Int(arc4random()%5) + 1 // 获取到 【1，5】
        let imageName = String.init(format: "snow_%d",index)
        imageV.image =  UIImage.init(named: imageName)
        UIView.animate(withDuration: TimeInterval(speed), animations: {
            imageV.frame = CGRect.init(x: endX, y: UIScreen.main.bounds.size.height + 20, width: width, height: width)
            // 旋转
            imageV.transform = imageV.transform.rotated(by: CGFloat(Double.pi))
        }) { (isfinish) in
            imageV.removeFromSuperview()
        }
    }
    
    // 对联动画
    func duilianAction() {
        duilianImageV.frame = CGRect.init(x: self.frame.size.width - 115, y: self.frame.size.height - 260 - 50, width: 110, height: 20)
        duilianImageV.alpha = 0.0
        UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            self.duilianImageV.frame = CGRect.init(x: self.frame.size.width - 115, y: self.frame.size.height - 260 - 50, width: 110, height: 260)
            self.duilianImageV.alpha = 1.0
        }) { (isFinished) in
            
        }
        
        // 放大、缩小动画 --- 可以把他们俩写成 transform.scale 统一变化也是OK的。
        let scaleX = CAKeyframeAnimation.init(keyPath: "transform.scale.x")
        scaleX.values = [(1.0), (1.12), (1.0)]
        scaleX.keyTimes = [(0.0), (0.5), (1.0)]
        scaleX.repeatCount = MAXFLOAT
        scaleX.autoreverses = true
        scaleX.duration = 4
        duilianImageV.layer.add(scaleX, forKey: "scaleX")
        // 放大、缩小动画
        let scaleY = CAKeyframeAnimation.init(keyPath: "transform.scale.y")
        scaleY.values = [(1.0), (1.18), (1.0)]
        scaleY.keyTimes = [(0.0), (0.6), (1.0)]
        scaleY.repeatCount = MAXFLOAT
        scaleY.autoreverses = true
        scaleY.duration = 3
        duilianImageV.layer.add(scaleY, forKey: "scaleY")
    }
    
    /// 顶部2018摆动的动画
    func swingAction() {
        var left = 0
        for i in 0 ... 5 {
            let timeD = 1.5 + Double(arc4random() % 2)
            let beginT = Double(arc4random() % 1)
            let height = Int(15 + arc4random() % 15)
            left += Int(Int(40) + Int(arc4random() % 15))
            let imageV = UIImageView.init(frame: CGRect.init(x: left, y: 0, width: 2, height: height))
            imageV.backgroundColor = UIColor.yellow
            self.addSubview(imageV)
            let middleV = Double.pi/(Double(Int(arc4random()) % 10) + 15)
            let ani = baidongAction(fromValue: -Double.pi/(Double((arc4random()) % 10) + 20), toValue: middleV, timeD: timeD, beginTime: beginT)
            imageV.layer.add(ani, forKey: "ani")
            let imgV = UIImageView.init(frame: CGRect.init(x: -1, y: imageV.frame.size.height - 2, width: imageV.frame.size.width * 2, height: 4))
            imgV.layer.masksToBounds = true
            imgV.layer.cornerRadius = 2
            imgV.backgroundColor = UIColor.yellow
            imageV.addSubview(imgV)
            
            // 2018 需要飘动的多
            let left2 = left - Int(arc4random() % 15) + Int(arc4random() % 10)
            var imageH = 100
            var imageW = 50
            var image = #imageLiteral(resourceName: "new_year_logo")
            if i == 1 {
                imageH = 80
                imageW = 40
                image = #imageLiteral(resourceName: "new_year_2")
            }
            if i == 2 {
                imageH = 90
                imageW = 50
                image = #imageLiteral(resourceName: "new_year_0")
            }
            if i == 3 {
                imageH = 80
                imageW = 30
                image = #imageLiteral(resourceName: "new_year_1")
            }
            if i == 4 {
                imageH = 100
                imageW = 40
                image = #imageLiteral(resourceName: "new_year_8")
            }
            if i == 5 {
                imageH = 100
                imageW = 40
                image = #imageLiteral(resourceName: "new_year_fu")
            }
            let imageV2 = UIImageView.init(frame: CGRect.init(x: left2, y: 0, width: imageW, height: imageH))
            imageV2.image = image
            imageV2.contentMode = .scaleToFill
            self.addSubview(imageV2)
            let ani2 = baidongAction(fromValue: -Double.pi/(Double((arc4random()) % 10) + 10), toValue: middleV, timeD: timeD, beginTime: beginT)
            imageV2.layer.add(ani2, forKey: "ani2")
        }
    }
    
    /// 摆动动画
    func baidongAction(fromValue: Double, toValue: Double, timeD: Double, beginTime: Double) -> CAAnimation {
        
        let animation0 = CABasicAnimation.init(keyPath: "transform.rotation.z")
        animation0.duration = timeD; // 持续时间
        let mediaTiming0 = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation0.timingFunction = mediaTiming0;
        animation0.beginTime = beginTime
        animation0.repeatCount = MAXFLOAT; // 重复次数
        animation0.fromValue =  (toValue)// 起始角度
        animation0.toValue = (fromValue) // 终止角度
        animation0.autoreverses = false
        
        let animation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        animation.duration = timeD; // 持续时间
        let mediaTiming = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.timingFunction = mediaTiming;
        animation.beginTime = beginTime + timeD
        animation.repeatCount = MAXFLOAT; // 重复次数
        animation.fromValue =  (fromValue)// 起始角度
        animation.toValue = (toValue) // 终止角度
        animation.autoreverses = false
        
        let animation2 = CABasicAnimation.init(keyPath: "transform.rotation.z")
        animation2.duration = timeD; // 持续时间
        let mediaTiming2 = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation2.timingFunction = mediaTiming2;
        animation2.beginTime = beginTime + timeD + timeD
        animation2.repeatCount = MAXFLOAT; // 重复次数
        animation2.fromValue =  (toValue)// 起始角度
        animation2.toValue = (0) // 终止角度
        animation2.autoreverses = false
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [animation0, animation,animation2]
        groupAnimation.duration = beginTime + timeD + timeD + timeD   //持续时间
        groupAnimation.autoreverses = true //循环效果
        groupAnimation.repeatCount = MAXFLOAT
        groupAnimation.beginTime = 0
        return groupAnimation
    }
    
    /// 扩散动画
    func spreadAction() {
        for _ in 0 ... 30 {
            let left = CGFloat(arc4random() % 400)
            let top = CGFloat(arc4random() % 50)
            let imageV = UIImageView.init(frame: CGRect.init(x: left, y: top, width: 10, height: 10))
            imageV.backgroundColor = UIColor.white
            imageV.layer.masksToBounds = true
            imageV.layer.cornerRadius = 5
            self.addSubview(imageV)
            let beginTime = CFTimeInterval(arc4random() % 20)/10.0
            imageV.layer.add(self.startSpreadAnimation(beiginTime: beginTime), forKey: nil)
        }
    }
    /// 扩散动画
    func startSpreadAnimation(beiginTime: CFTimeInterval) -> CAAnimationGroup {
        // 透明
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1.0  // 起始值
        opacityAnimation.toValue = 0     // 结束值
        // 扩散动画
        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        let t = CATransform3DIdentity
        scaleAnimation.fromValue = NSValue(caTransform3D: CATransform3DScale(t, 0.0, 0.0, 0.0))
        scaleAnimation.toValue = NSValue(caTransform3D: CATransform3DScale(t, 6.0, 6.0, 0.0))
        // 给CAShapeLayer添加组合动画
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [opacityAnimation,scaleAnimation]
        groupAnimation.duration = 3   //持续时间
        groupAnimation.autoreverses = false //循环效果
        groupAnimation.repeatCount = MAXFLOAT
        groupAnimation.beginTime = beiginTime
        return groupAnimation
    }
}

