//
//  LNRefreshAutoFooter.swift
//  LNRefreshExample
//
//  Created by Lin on 2018/2/8.
//  Copyright © 2018年 lin. All rights reserved.
//

import UIKit

public class LiNRefreshAutoFooter: LiNRefreshFooter {
    /** 当底部控件出现多少时就自动刷新(默认为1.0，也就是底部控件完全出现时，才会自动刷新) */
    var triggerAutomaticallyRefreshPercent: CGFloat = 1.0
    /** 是否自动刷新(默认为true) */
    var automaticallyRefresh: Bool = true
    /** 默认每一次拖拽只发一次请求 */
    var onlyRefreshPerDrag: Bool = true
    /** 判断是否是一个新的拖拽*/
    var isOneNewPan: Bool = false

    //MARK : - 初始化
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        //新的父控件
        if newSuperview != nil {
            if self.isHidden == false {
                self.scrollView!.ln_insetBottom += self.ln_h
            }
            
            //设置位置
            self.ln_y = self.scrollView!.ln_contentHeight
        } else {
            //移除了
            if self.isHidden == false {
                self.scrollView?.ln_insetBottom -= self.ln_h
            }
        }
    }
    
    //MARK : - 覆盖父类的方法
    override func prepare() {
        super.prepare()
        
        //默认底部控件100%出现才会自动刷新
        self.triggerAutomaticallyRefreshPercent = 1.0
        
        //设置默认状态
        self.automaticallyRefresh = true
        
        //设置当offset达到条件就发送请求（可连续）
        self.onlyRefreshPerDrag = false
    }
    
    override func scrollViewContentSizeDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentSizeDidChange(change)
        
        //设置位置
        self.ln_y = self.scrollView!.ln_contentHeight
        
    }
    
    override func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(change)
        
        if (self.state != LiNRefreshState.idel) || (!self.automaticallyRefresh) || (self.ln_y == 0) {
            return
        }
        
        if (self.scrollView!.ln_insetTop + self.scrollView!.ln_contentHeight) > self.scrollView!.ln_h { //内容超过一屏
            // 这里的scrollView.ln_contentHeight替换掉self.ln_y更为合理
            if self.scrollView!.ln_offsetY >=
                (self.scrollView!.ln_contentHeight - self.scrollView!.ln_h + self.ln_h * self.triggerAutomaticallyRefreshPercent + self.scrollView!.ln_insetBottom - self.ln_h) {
                //防止手松开时连续调用
                let old: CGPoint = change![NSKeyValueChangeKey.oldKey] as! CGPoint
                let new: CGPoint = change![NSKeyValueChangeKey.newKey] as! CGPoint
                
                if new.y > old.y {
                    
                    // 当底部刷新控件完全出现时，才刷新
                    self.beginRefreshing()
                }
            }
        }
    }
    
    override func scrollViewPanStateDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewPanStateDidChange(change)
        
        if self.state != LiNRefreshState.idel {
            return
        }
        
        let panState: UIGestureRecognizerState = self.scrollView!.panGestureRecognizer.state
        if panState == UIGestureRecognizerState.ended { //手松开了
            if (self.scrollView!.ln_insetTop + self.scrollView!.ln_contentHeight) <= self.scrollView!.ln_h { //不够一屏
                if self.scrollView!.ln_offsetY >= -self.scrollView!.ln_insetTop { //向上拽
                    self.beginRefreshing()
                }
            } else {    //超出一屏
                if self.scrollView!.ln_offsetY >=
                    (self.scrollView!.ln_contentHeight + self.scrollView!.ln_insetBottom - self.scrollView!.ln_h) {
                    self.beginRefreshing()
                }
            }
        } else if panState == UIGestureRecognizerState.began {
            self.isOneNewPan = true
        }
    }
    
    override func beginRefreshing() {
        if !self.isOneNewPan && self.onlyRefreshPerDrag {
            return
        }
        super.beginRefreshing()
        self.isOneNewPan = false
    }
    
    override var state: LiNRefreshState? {
        didSet {
            if oldValue == state {
                return
            }
            
            if state == LiNRefreshState.refreshing {
                self.refreshingClosure?()
            } else if state == LiNRefreshState.noMoreData || state == LiNRefreshState.idel {
                if oldValue == LiNRefreshState.refreshing {
                    self.endRefreshingClosure?()
                }
            }
        }
    }
    

    override public var isHidden: Bool {
        didSet {
            if !oldValue && isHidden {
                self.state = LiNRefreshState.idel
                self.scrollView?.ln_insetBottom -= self.ln_h
            }else if oldValue && !isHidden {
                self.scrollView?.ln_insetBottom += self.ln_h
                
                //设置位置
                self.ln_y = self.scrollView!.ln_contentHeight
            }
        }
    }
    
}
