//
//  YouTubeDetailVC.swift
//  SwiftPushTransition
//
//  Created by zhangmingwei on 2018/2/28.
//  Copyright © 2018年 zhangmingwei. All rights reserved.
//

import UIKit

class YouTubeDetailVC: BaseVC {
    
    /// youtube最小的宽度
    let youTuBeMinWidth: CGFloat    =   (UIScreen.main.bounds.width - 60) / 2.0
    /// youtube最小的高度
    let youTuBeMinHeight: CGFloat    = ((UIScreen.main.bounds.width - 60) / 2.0) * 0.66
    /// 顶部播放视频的view
    var topPlayerView: UIView!
    /// 视频控件当前是小窗口吗
    var isCurrentPlayerSmall: Bool = false
    /// 底部的view
    var bottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fd_prefersNavigationBarHidden = true
        self.view.backgroundColor = UIColor.yellow
        self.initAllView()
    }
    
    /// 初始化所有view
    func initAllView() {
        topPlayerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: view.frame.width, height: view.frame.width * 0.66))
        topPlayerView.backgroundColor = UIColor.red
        view.addSubview(topPlayerView)
        // 底部view
        bottomView = UIView.init(frame: CGRect.init(x: 0, y: topPlayerView.frame.height, width: view.frame.width, height: UIScreen.main.bounds.height - topPlayerView.frame.height))
        view.addSubview(bottomView)
        // 添加视频view的手势
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(playerHandleGesture(gestureRecognizer:)))
        topPlayerView.addGestureRecognizer(gesture)
        // 保持视频在最顶部
        view.bringSubview(toFront: topPlayerView)
    }
    
}

/// youtube的手势控制
extension YouTubeDetailVC {
    /// 自定义-- 以下是自定义交互器 上下手势 / 左右手势
    @objc func playerHandleGesture(gestureRecognizer: UIPanGestureRecognizer) {
        var progress: CGFloat = 0.0
        let pro = gestureRecognizer.translation(in: gestureRecognizer.view?.superview).y / self.view.bounds.size.height
        progress = min(1.0, pro)
        if gestureRecognizer.state == UIGestureRecognizerState.began { // 开始滑动
            
        } else if gestureRecognizer.state == UIGestureRecognizerState.changed { // 正在滑动
            var w = UIScreen.main.bounds.width * (1-progress)
            if self.isCurrentPlayerSmall { // 当前是小窗口的话
                w = youTuBeMinWidth - UIScreen.main.bounds.width*progress
            }
            var top = topPlayerView.frame.origin.y * (1+progress)
            if w < youTuBeMinWidth { // 设置宽度的最小值
                w = youTuBeMinWidth
            }
            if top > UIScreen.main.bounds.height - self.youTuBeMinHeight - 10 {
                top = UIScreen.main.bounds.height - self.youTuBeMinHeight - 10
            }
            if top < 0 {
                top = 0
            }
            var x = UIScreen.main.bounds.width - w - 10*progress*1.2
            if self.isCurrentPlayerSmall { // 当前是小窗口的话
                x = UIScreen.main.bounds.width - w - 10*(1+progress*2)
                topPlayerView?.frame = CGRect(x:x, y:UIScreen.main.bounds.height - self.youTuBeMinHeight - 10 + UIScreen.main.bounds.height*progress, width:w, height: w * 0.66)
            } else {
                topPlayerView?.frame = CGRect(x:x, y:UIScreen.main.bounds.height*progress, width:w, height: w * 0.66)
            }
            
        } else if gestureRecognizer.state == UIGestureRecognizerState.ended || gestureRecognizer.state == UIGestureRecognizerState.cancelled { // 结束
            if (self.isCurrentPlayerSmall && progress < -0.41) || (!self.isCurrentPlayerSmall && progress < 0.18)  { // 变成大窗口
                UIView.animate(withDuration: 0.2, animations: {
                    self.topPlayerView.frame = CGRect(x:0, y:0, width:self.view.frame.width , height: self.view.frame.width*0.66)
                }, completion: {completed in
                    self.isCurrentPlayerSmall = false
                })
            } else { // 变成小窗口
                UIView.animate(withDuration: 0.2, animations: {
                    self.topPlayerView.frame = CGRect(x:UIScreen.main.bounds.width - self.youTuBeMinWidth - 10, y:UIScreen.main.bounds.height - self.youTuBeMinHeight - 10, width:self.youTuBeMinWidth , height: self.youTuBeMinHeight)
                }, completion: {completed in
                    self.isCurrentPlayerSmall = true
                })
            }
        }
    }
    
}
