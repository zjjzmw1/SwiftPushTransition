//
//  YouTubeDetailView.swift
//  SwiftPushTransition
//
//  Created by zhangmingwei on 2018/3/1.
//  Copyright © 2018年 zhangmingwei. All rights reserved.
//

import UIKit

class YouTubeView: UIView {

    /// 单利
//    let shareYouTubeView: YouTubeDetailView
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        topPlayerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.66))
        topPlayerView.backgroundColor = UIColor.red
        self.addSubview(topPlayerView)
        // 底部view
        bottomView = UIView.init(frame: CGRect.init(x: 0, y: topPlayerView.frame.height, width: topPlayerView.frame.width, height: self.frame.height - topPlayerView.frame.height))
        self.addSubview(bottomView)
        bottomView.backgroundColor = UIColor.yellow
        // 添加视频view的手势
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(playerHandleGesture(gestureRecognizer:)))
        topPlayerView.addGestureRecognizer(gesture)
        // 保持视频在最顶部
        self.bringSubview(toFront: topPlayerView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 自定义-- 以下是自定义交互器 上下手势 / 左右手势
    @objc func playerHandleGesture(gestureRecognizer: UIPanGestureRecognizer) {
        var progress: CGFloat = 0.0
        let pro = gestureRecognizer.translation(in: gestureRecognizer.view?.superview).y / UIScreen.main.bounds.height
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
                self.frame = CGRect(x:x, y:UIScreen.main.bounds.height - self.youTuBeMinHeight - 10 + UIScreen.main.bounds.height*progress, width:w, height: w * 0.66)
                topPlayerView?.frame = CGRect.init(x: 0, y: 0, width: w, height: w * 0.66)
            } else {
                self.frame = CGRect(x:x, y:UIScreen.main.bounds.height*progress, width:w, height: w * 0.66)
                topPlayerView?.frame = CGRect.init(x: 0, y: 0, width: w, height: w * 0.66)
            }
            // 更新底部view的位置
            bottomView.frame =  CGRect.init(x: 0, y: topPlayerView.frame.origin.y + topPlayerView.frame.height, width: topPlayerView.frame.width, height: UIScreen.main.bounds.height - topPlayerView.frame.origin.y - topPlayerView.frame.height)
            // 更新底部view的透明度
            if progress > 0 {
                bottomView.alpha = 1 - progress*2 < 0 ? 0 : 1 - progress*2
            } else {
                bottomView.alpha = -progress/2.0
            }
            print(progress)
        } else if gestureRecognizer.state == UIGestureRecognizerState.ended || gestureRecognizer.state == UIGestureRecognizerState.cancelled {
            if (self.isCurrentPlayerSmall && progress < -0.41) || (!self.isCurrentPlayerSmall && progress < 0.18)  { // 变成大窗口
                UIView.animate(withDuration: 0.2, animations: {
                    self.frame = CGRect(x:0, y:0, width:UIScreen.main.bounds.width , height: UIScreen.main.bounds.width*0.66)
                    self.topPlayerView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*0.66)
                    // 更新底部view的位置
                    self.bottomView.frame =  CGRect.init(x: 0, y: self.topPlayerView.frame.origin.y + self.topPlayerView.frame.height, width: self.topPlayerView.frame.width, height: UIScreen.main.bounds.height - self.topPlayerView.frame.origin.y - self.topPlayerView.frame.height)
                }, completion: {completed in
                    self.isCurrentPlayerSmall = false
                    self.bottomView.alpha = 1
                })
            } else { // 变成小窗口
                UIView.animate(withDuration: 0.2, animations: {
                    self.frame = CGRect(x:UIScreen.main.bounds.width - self.youTuBeMinWidth - 10, y:UIScreen.main.bounds.height - self.youTuBeMinHeight - 10, width:self.youTuBeMinWidth , height: self.youTuBeMinHeight)
                    self.topPlayerView.frame = CGRect.init(x: 0, y: 0, width: self.youTuBeMinWidth, height: self.youTuBeMinHeight)
                    // 更新底部view的位置
                    self.bottomView.frame =  CGRect.init(x: 0, y: self.topPlayerView.frame.origin.y + self.topPlayerView.frame.height, width: self.topPlayerView.frame.width, height: UIScreen.main.bounds.height - self.topPlayerView.frame.origin.y - self.topPlayerView.frame.height)
                }, completion: {completed in
                    self.isCurrentPlayerSmall = true
                    self.bottomView.alpha = 0
                })
            }
        }
    }

    

}
