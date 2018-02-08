//
//  FiveVC.swift
//  SwiftPushTransition
//
//  Created by zhangmingwei on 2018/2/8.
//  Copyright © 2018年 zhangmingwei. All rights reserved.
//

import UIKit

class FiveVC: BaseVC {
    /// 对联的图片
    var duilianImageV: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        self.title = "第5页"
        // 下雪------------------------------animation
//        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] (_) in
//            self?.xiaxueAction()
        Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(xiaxueAction), userInfo: nil, repeats: true)
        // 对联添加
        duilianImageV = WaveImageV.init(frame: CGRect.init(x: 260, y: 300, width: 60, height: 200))
        duilianImageV.backgroundColor = UIColor.red
        view.addSubview(duilianImageV)
        // 对联浮动------------------------------animation
        self.duilianAction()
        
        // 上边扩散的动画
        self.spreadAction()
        
        // 顶部2018摆动的动画
        self.swingAction()
    }

    /// 下雪动画
    @objc func xiaxueAction() {
        
        if self.view.subviews.count > 500 {
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
        let startX = CGFloat(arc4random() % 400)
        let endX = CGFloat(arc4random() % 400)
        let imageV = UIImageView.init(frame: CGRect.init(x: startX, y: startY, width: width, height: width))
        self.view.addSubview(imageV)
        imageV.image = #imageLiteral(resourceName: "xh")
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
        self.duilianImageV.frame = CGRect.init(x: 260, y: 310, width: 60, height: 20)
        UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            self.duilianImageV.frame = CGRect.init(x: 260, y: 310, width: 60, height: 200)
        }) { (isFinished) in
            
        }
        
        let pathAnimation = CAKeyframeAnimation.init(keyPath: "position")
        pathAnimation.calculationMode = kCAAnimationPaced;
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.repeatCount = MAXFLOAT
        pathAnimation.autoreverses = true
        pathAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        pathAnimation.duration = 5
        let path = UIBezierPath.init(ovalIn: duilianImageV.frame.insetBy(dx: 55, dy: 55))
        pathAnimation.path = path.cgPath
        duilianImageV.layer.add(pathAnimation, forKey: "pathAnimation")

        // 放大、缩小动画
        let scaleX = CAKeyframeAnimation.init(keyPath: "transform.scale")
        scaleX.values = [(1.0), (1.1), (1.0)]
        scaleX.keyTimes = [(0.0), (0.5), (1.0)]
        scaleX.repeatCount = MAXFLOAT
        scaleX.autoreverses = true
        scaleX.duration = 4
        duilianImageV.layer.add(scaleX, forKey: "scaleX")

        
    }
    
    /// 顶部2018摆动的动画
    func swingAction() {
        var left = 0
        for _ in 0 ... 7 {
            let timeD = 1.5 + Double(arc4random() % 2)
            let beginT = Double(arc4random() % 1)
            let height = Int(100 + arc4random() % 80)
            left += Int((30 + arc4random() % 20))
            let imageV = UIImageView.init(frame: CGRect.init(x: left, y: 60, width: 5, height: height))
            imageV.backgroundColor = UIColor.red
            self.view.addSubview(imageV)
            let middleV = Double.pi/(Double(Int(arc4random()) % 10) + 15)
            let ani = baidongAction(fromValue: -Double.pi/(Double((arc4random()) % 10) + 20), toValue: middleV, timeD: timeD, beginTime: beginT)
            imageV.layer.add(ani, forKey: "ani")
            let imgV = UIImageView.init(frame: CGRect.init(x: -2.5, y: imageV.frame.size.height - 5, width: imageV.frame.size.width * 2, height: 10))
            imgV.layer.masksToBounds = true
            imgV.layer.cornerRadius = 5
            imgV.backgroundColor = UIColor.red
            imageV.addSubview(imgV)
            
            // 2018 需要飘动的多
            let left2 = left + Int(arc4random() % 10) + 10
            let imageV2 = UIImageView.init(frame: CGRect.init(x: left2, y: 60, width: 20, height: height))
            imageV2.backgroundColor = UIColor.blue
            self.view.addSubview(imageV2)
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
            let imageV = UIImageView.init(frame: CGRect.init(x: left, y: 70 + top, width: 10, height: 10))
            imageV.backgroundColor = UIColor.white
            imageV.layer.masksToBounds = true
            imageV.layer.cornerRadius = 5
            self.view.addSubview(imageV)
            let beginTime = CFTimeInterval(arc4random() % 10)/10.0
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
//        pulseLayer.add(groupAnimation, forKey: nil)
        return groupAnimation
    }
    
    
}
