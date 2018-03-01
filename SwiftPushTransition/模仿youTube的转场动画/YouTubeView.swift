//
//  YouTubeDetailView.swift
//  SwiftPushTransition
//
//  Created by zhangmingwei on 2018/3/1.
//  Copyright © 2018年 zhangmingwei. All rights reserved.
//

import UIKit

let kYoutubeScreenWidth         = UIScreen.main.bounds.width
let kYoutubeScreenHeight        = UIScreen.main.bounds.height

class YouTubeView: UIView {

    /// 单利
//    let shareYouTubeView: YouTubeDetailView
    /// youtube最小的宽度
    let youTuBeMinWidth: CGFloat    =   (kYoutubeScreenWidth - 60) / 2.0
    /// youtube最小的高度
    let youTuBeMinHeight: CGFloat    = ((kYoutubeScreenWidth - 60) / 2.0) * 0.66
    /// 顶部播放视频的view
    var topPlayerView: UIView!
    /// 视频控件当前是小窗口吗
    var isCurrentPlayerSmall: Bool = false
    /// 底部的view
    var bottomView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        topPlayerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kYoutubeScreenWidth, height: kYoutubeScreenWidth * 0.66))
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
        let proY = gestureRecognizer.translation(in: gestureRecognizer.view?.superview).y / kYoutubeScreenHeight
        let proX = gestureRecognizer.translation(in: gestureRecognizer.view?.superview).x / kYoutubeScreenWidth
        if self.isCurrentPlayerSmall {
            if fabs(proX) > fabs(proY) && fabs(proX) > 0.01 {
                print("左右滑动删除。。。。")
            }
        }
        progress = min(1.0, proY)
        if gestureRecognizer.state == UIGestureRecognizerState.began { // 开始滑动

        } else if gestureRecognizer.state == UIGestureRecognizerState.changed { // 正在滑动
            var w = kYoutubeScreenWidth * (1-progress)
            if self.isCurrentPlayerSmall { // 当前是小窗口的话
                w = youTuBeMinWidth - kYoutubeScreenWidth*progress
            }
            var top = topPlayerView.frame.origin.y * (1+progress)
            if w < youTuBeMinWidth { // 设置宽度的最小值
                w = youTuBeMinWidth
            }
            if w > kYoutubeScreenWidth {
                w = kYoutubeScreenWidth
            }
            if top > kYoutubeScreenHeight - self.youTuBeMinHeight - 10 {
                top = kYoutubeScreenHeight - self.youTuBeMinHeight - 10
            }
            if top < 0 {
                top = 0
            }
            var x = kYoutubeScreenWidth - w - 10*progress*1.2
            var y = kYoutubeScreenHeight - self.youTuBeMinHeight - 10 + kYoutubeScreenHeight*progress
            if !self.isCurrentPlayerSmall {
                y = kYoutubeScreenHeight*progress
            }
            if y < 0 {
                y = 0
            }
            if y > kYoutubeScreenHeight - self.youTuBeMinHeight - 10 {
                y = kYoutubeScreenHeight - self.youTuBeMinHeight - 10
            }
            if self.isCurrentPlayerSmall { // 当前是小窗口的话
                x = kYoutubeScreenWidth - w - 10*(1+progress*2)
                self.frame = CGRect(x:x, y:y, width:w, height: w * 0.66)
                topPlayerView?.frame = CGRect.init(x: 0, y: 0, width: w, height: w * 0.66)
            } else {
                self.frame = CGRect(x:x, y:y, width:w, height: w * 0.66)
                topPlayerView?.frame = CGRect.init(x: 0, y: 0, width: w, height: w * 0.66)
            }
            // 更新底部view的位置
            bottomView.frame =  CGRect.init(x: 0, y: topPlayerView.frame.origin.y + topPlayerView.frame.height, width: topPlayerView.frame.width, height: kYoutubeScreenHeight - topPlayerView.frame.origin.y - topPlayerView.frame.height)
            // 更新底部view的透明度
            if progress > 0 {
                bottomView.alpha = 1 - progress*2 < 0 ? 0 : 1 - progress*2
                if self.frame.origin.y + topPlayerView.frame.height > kYoutubeScreenHeight - 100 { // 避免在最底部的时候下拉就展示
                    bottomView.alpha = 0
                }
            } else {
                if self.frame.origin.y <= 0 {
                    bottomView.alpha = 1
                } else {
                    bottomView.alpha = -progress/2.0
                }
            }
        } else if gestureRecognizer.state == UIGestureRecognizerState.ended || gestureRecognizer.state == UIGestureRecognizerState.cancelled {
            if (self.isCurrentPlayerSmall && progress < -0.41) || (!self.isCurrentPlayerSmall && progress < 0.18)  { // 变成大窗口
                UIView.animate(withDuration: 0.2, animations: {
                    self.frame = CGRect(x:0, y:0, width:kYoutubeScreenWidth , height: kYoutubeScreenWidth*0.66)
                    self.topPlayerView.frame = CGRect.init(x: 0, y: 0, width: kYoutubeScreenWidth, height: kYoutubeScreenWidth*0.66)
                    // 更新底部view的位置
                    self.bottomView.frame =  CGRect.init(x: 0, y: self.topPlayerView.frame.origin.y + self.topPlayerView.frame.height, width: self.topPlayerView.frame.width, height: kYoutubeScreenHeight - self.topPlayerView.frame.origin.y - self.topPlayerView.frame.height)
                }, completion: {completed in
                    self.isCurrentPlayerSmall = false
                    self.bottomView.alpha = 1
                })
            } else { // 变成小窗口
                UIView.animate(withDuration: 0.2, animations: {
                    self.frame = CGRect(x:kYoutubeScreenWidth - self.youTuBeMinWidth - 10, y:kYoutubeScreenHeight - self.youTuBeMinHeight - 10, width:self.youTuBeMinWidth , height: self.youTuBeMinHeight)
                    self.topPlayerView.frame = CGRect.init(x: 0, y: 0, width: self.youTuBeMinWidth, height: self.youTuBeMinHeight)
                    // 更新底部view的位置
                    self.bottomView.frame =  CGRect.init(x: 0, y: self.topPlayerView.frame.origin.y + self.topPlayerView.frame.height, width: self.topPlayerView.frame.width, height: kYoutubeScreenHeight - self.topPlayerView.frame.origin.y - self.topPlayerView.frame.height)
                }, completion: {completed in
                    self.isCurrentPlayerSmall = true
                    self.bottomView.alpha = 0
                })
            }
        }
    }

    

}
